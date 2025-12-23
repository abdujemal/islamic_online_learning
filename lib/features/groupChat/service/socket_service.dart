import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  static final SocketService _instance = SocketService._internal();
  SocketService._internal();
  factory SocketService() => _instance;

  Future<void> connect() async {
    final token = await getAccessToken();
    socket = IO.io(
      mainUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({"token": token})
          .enableReconnection()
          .enableForceNew()
          .build(),
    );
    print("Socket connecting...");
    socket.connect();
    socket.onConnect((_) => print("Connected to socket"));
    socket.onError((_) => print("Error: $_"));
    socket.onDisconnect((_) => print("Disconnected"));
  }

  void joinChat(String groupId) {
    socket.emit("join_chat", {"groupId": groupId});
  }

  void onNewMessage(Function callback) {
    socket.on("new_message", (data) => callback(data));
  }

  void onEditMessage(Function callback) {
    socket.on("message_edited", (data) => callback(data));
  }

  void onChatRead(Function callback) {
    socket.on("chat_status_updated", (data) => callback(data));
  }

  void onDeleteMessage(Function callback) {
    socket.on("message_deleted", (data) => callback(data));
  }

  void readChat(String groupId, String userId, String chatId) {
    socket.emit(
      "chat_read",
      {
        "chatId": chatId,
        "userId": userId,
        "groupId": groupId,
      },
    );
  }

  void sendMessage(Map msg) {
    socket.emit("send_message", msg);
  }

  void editMessage(Map msg) {
    socket.emit("edit_message", msg);
  }

  void disconnect() {
    // if (socket == null) return;

    socket.dispose(); // removes all listeners
    socket.disconnect(); // disconnect transport
    socket.close();

    print("SOCKET CLEANED UP");
  }
}
