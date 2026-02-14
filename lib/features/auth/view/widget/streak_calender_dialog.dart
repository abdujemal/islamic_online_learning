import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StreakCalendarDialog extends StatefulWidget {
  final List<DateTime> streakDates;

  const StreakCalendarDialog({super.key, required this.streakDates});

  @override
  State<StreakCalendarDialog> createState() => _StreakCalendarDialogState();
}

class _StreakCalendarDialogState extends State<StreakCalendarDialog> {
  late DateTime _current;
  final now = DateTime.now();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _current = DateTime(now.year, now.month);
  }

  void _nextMonth() {
    setState(() {
      _current = DateTime(_current.year, _current.month + 1);
    });
  }

  void _prevMonth() {
    setState(() {
      _current = DateTime(_current.year, _current.month - 1);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(_current.year, _current.month);
    final firstDay = DateTime(_current.year, _current.month, 1);

    final streakDayNumbers = widget.streakDates
        .where((d) => d.month == _current.month && d.year == _current.year)
        .map((d) => d.day)
        .toSet();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.85, end: 1),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1B2A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconButton(Icons.chevron_left, _prevMonth),

                  // Month and Year (clickable)
                  Column(
                    children: [
                      InkWell(
                        onTap: () => _pickMonth(context),
                        child: Text(
                          DateFormat.MMMM().format(_current),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _pickYear(context),
                        child: Text(
                          _current.year.toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  _iconButton(Icons.chevron_right, _nextMonth),
                ],
              ),

              const SizedBox(height: 16),

              // WEEKDAYS ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                    .map(
                      (w) => Expanded(
                        child: Center(
                          child: Text(
                            w,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 13),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 8),

              // DAYS GRID
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daysInMonth + firstDay.weekday - 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (_, index) {
                  final day = index - (firstDay.weekday - 2);

                  if (day < 1) return const SizedBox();

                  final date = DateTime(_current.year, _current.month, day);
                  final isToday = _isSameDay(date, now);
                  final isStreak = streakDayNumbers.contains(day);

                  return _buildDayTile(day, isToday, isStreak);
                },
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Close",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // DAY CELL
  Widget _buildDayTile(int day, bool isToday, bool isStreak) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isToday ? Colors.amber.withOpacity(0.25) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isToday ? Border.all(color: Colors.amber, width: 1.5) : null,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color:
                isStreak ? Colors.green.withOpacity(0.2) : Colors.transparent,
            shape: BoxShape.circle,
            border: isStreak
                ? Border.all(color: Colors.greenAccent, width: 2)
                : null,
          ),
          child: Text(
            "$day",
            style: TextStyle(
              color: isStreak ? Colors.greenAccent : Colors.white,
              fontWeight: isStreak ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // MONTH PICKER
  Future<void> _pickMonth(BuildContext context) async {
    final months = List.generate(
        12,
        (i) => DateFormat.MMMM().format(
              DateTime(2000, i + 1),
            ));

    final selected = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: const Color(0xFF1B263B),
        title:
            const Text("Select Month", style: TextStyle(color: Colors.white)),
        children: months
            .asMap()
            .entries
            .map((e) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, e.key + 1),
                  child: Text(
                    e.value,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        _current = DateTime(_current.year, selected);
      });
    }
  }

  // YEAR PICKER
  Future<void> _pickYear(BuildContext context) async {
    final currentYear = DateTime.now().year;
    final years = List.generate(30, (i) => currentYear - 15 + i);

    final selected = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text("Select Year", style: TextStyle(color: Colors.white)),
        children: years
            .map((year) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, year),
                  child: Text(
                    year.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        _current = DateTime(selected, _current.month);
      });
    }
  }

  // ICON BUTTON
  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
