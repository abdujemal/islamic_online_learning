import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRoomPage extends ConsumerStatefulWidget {
  const VoiceRoomPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VoiceRoomPageState();
}

class _VoiceRoomPageState extends ConsumerState<VoiceRoomPage> {
  Room? _room;
  bool _isConnecting = false;
  bool _isMuted = false;
  List<RemoteParticipant> _participants = [];
  Timer? _speakerPollTimer;
  String _identity = 'guest${DateTime.now().millisecondsSinceEpoch % 10000}';
  String _roomName = 'telegram-style-room';
  EventsListener<RoomEvent>? _listener;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _speakerPollTimer?.cancel();
    _room?.dispose();
    super.dispose();
  }

  Future<String> _fetchToken(String identity, String roomName) async {
    final resp = await customPostRequest(
      TOKEN_ENDPOINT,
      {"identity": identity, "room": roomName},
      authorized: true,
    );

    if (resp.statusCode != 200) {
      throw Exception(
          'Token request failed (${resp.statusCode}): ${resp.body}');
    }
    // Accept both JSON { token } and plain string body
    try {
      final j = json.decode(resp.body);
      if (j is Map && j['token'] != null) return j['token'];
    } catch (_) {}
    return resp.body.trim();
  }

  Future<void> _ensureMicPermission() async {
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        throw Exception('Microphone permission not granted');
      }
    }
  }

  Future<void> _connect() async {
    setState(() => _isConnecting = true);
    try {
      await _ensureMicPermission();

      final token = await _fetchToken(_identity, _roomName);

      // Connect to LiveKit. In typical LiveKit Cloud flow you pass the WSS URL
      // and the server-generated token (JWT).
      final roomOptions = RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        // ... your room options
      );

      final room = Room(roomOptions: roomOptions);

      await room.connect(LIVEKIT_URL, token);

      await room.localParticipant?.setMicrophoneEnabled(true);

      _listener = room.createListener();
      _listener!
        ..on<RoomDisconnectedEvent>((_) {
          // handle disconnect
          debugPrint('Disconnected: ${_.reason}');
          _stopSpeakerPoll();
          setState(() {
            _participants = [];
          });
        })
        ..on<ParticipantConnectedEvent>((e) {
          print("participant joined: ${e.participant.identity}");
        });

      // Keep participants in local state
      void updateParticipants() {
        final remote = room.remoteParticipants;
        // convert to RemoteParticipant list snapshot:
        print("remote participants: ${remote.length}");
        final list = remote.values.whereType<RemoteParticipant>().toList();
        setState(() {
          _participants = list;
        });
      }

      // initial snapshot
      updateParticipants();

      // subscribe to participant events (SDK exposes participant events; this uses a simple poll)
      _speakerPollTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        updateParticipants();
      });

      // Automatically enable mic (local publish)
      try {
        await room.localParticipant?.setMicrophoneEnabled(!_isMuted);
      } catch (e) {
        debugPrint('Could not enable mic: $e');
      }

      setState(() {
        _room = room;
        _isConnecting = false;
      });
    } catch (e) {
      setState(() => _isConnecting = false);
      _showError('Connection failed: $e');
    }
  }

  Future<void> _disconnect() async {
    _stopSpeakerPoll();
    try {
      await _room?.dispose();
    } catch (_) {}
    setState(() {
      _room = null;
      _participants = [];
    });
  }

  void _stopSpeakerPoll() {
    _speakerPollTimer?.cancel();
    _speakerPollTimer = null;
  }

  Future<void> _toggleMute() async {
    try {
      final newMuted = !_isMuted;
      await _room?.localParticipant?.setMicrophoneEnabled(!newMuted);
      setState(() {
        _isMuted = newMuted;
      });
    } catch (e) {
      _showError('Failed to toggle mic: $e');
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildParticipantTile(RemoteParticipant p, bool isLarge) {
    final identity = p.identity ?? 'anon';
    final isSpeaking = p.isSpeaking ?? false;
    final initials = identity.isEmpty ? 'U' : identity[0].toUpperCase();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(8),
      padding: EdgeInsets.all(isLarge ? 16 : 8),
      decoration: BoxDecoration(
        color:
            isSpeaking ? Colors.tealAccent.withOpacity(0.15) : Colors.white12,
        borderRadius: BorderRadius.circular(isLarge ? 16 : 12),
        border: Border.all(
          color: isSpeaking ? Colors.tealAccent : Colors.transparent,
          width: isSpeaking ? 3 : 0,
        ),
      ),
      width: isLarge ? 180 : 110,
      height: isLarge ? 220 : 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: isLarge ? 40 : 28,
            backgroundColor:
                Colors.primaries[identity.hashCode % Colors.primaries.length],
            child: Text(initials,
                style: TextStyle(
                    fontSize: isLarge ? 28 : 18, color: Colors.white)),
          ),
          const SizedBox(height: 12),
          Text(identity,
              style: TextStyle(
                  fontSize: isLarge ? 18 : 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
              p.isMuted == true
                  ? 'Muted'
                  : (isSpeaking ? 'Speaking' : 'Listening'),
              style: TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildMainArea() {
    // Arrange participants: highlight a "speaker" (first speaking participant or first participant)
    RemoteParticipant? main;
    if (_participants.isNotEmpty) {
      main = _participants.firstWhere((p) => p.isSpeaking == true,
          orElse: () => _participants.first);
    }

    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          'Voice Chat — ${_roomName.replaceAll('-', ' ')}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        if (main != null)
          _buildParticipantTile(main, true)
        else
          Container(
            width: 180,
            height: 220,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white12, borderRadius: BorderRadius.circular(16)),
            child: const Text('No participants',
                style: TextStyle(color: Colors.white70)),
          ),
        const SizedBox(height: 18),
        Text(
          '${_participants.length + (_room != null ? 1 : 0)} participant(s) connected',
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            childAspectRatio: 0.7,
            children: _participants
                .map((p) => _buildParticipantTile(p, false))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    final connected = _room != null;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            // Mute/unmute
            FloatingActionButton(
              heroTag: 'mute',
              backgroundColor: _isMuted ? Colors.redAccent : Colors.white,
              onPressed: connected ? _toggleMute : null,
              child: Icon(_isMuted ? Icons.mic_off : Icons.mic,
                  color: _isMuted ? Colors.white : Colors.black),
            ),
            const SizedBox(width: 12),
            // Leave / Join
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      connected ? Colors.redAccent : Colors.tealAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isConnecting
                    ? null
                    : () async {
                        if (connected) {
                          await _disconnect();
                        } else {
                          await _connect();
                        }
                      },
                child: Text(
                  _isConnecting
                      ? 'Connecting...'
                      : (connected ? 'Leave Call' : 'Join Call'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // More (raise hand / settings) placeholder
            FloatingActionButton(
              heroTag: 'more',
              backgroundColor: Colors.white12,
              onPressed: () {
                // future actions
                _showError('Not implemented yet — settings');
              },
              child: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.tealAccent,
              child: const Icon(Icons.mic, color: Colors.black),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Telegram Voice Chat',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                    (_room != null) ? 'In call as $_identity' : 'Not connected',
                    style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            )),
            IconButton(
              onPressed: () async {
                final identity = await _showIdentityDialog();
                if (identity != null && identity.isNotEmpty) {
                  setState(() {
                    _identity = identity;
                  });
                }
              },
              icon: const Icon(Icons.edit, color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> _showIdentityDialog() {
    final controller = TextEditingController(text: _identity);
    return showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Set display name'),
        content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Display name')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(c, controller.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // replicate a Telegram vibe
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(child: _buildMainArea()),
          _buildBottomControls(),
        ],
      ),
    );
  }
}
