import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_calendar/hijri_calendar.dart' as h;
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/model/rest.dart';

class HijriStreakCalenderDialog extends ConsumerStatefulWidget {
  final int discussionWDay;
  final List<Rest> rests;
  const HijriStreakCalenderDialog(
      {super.key, required this.discussionWDay, required this.rests});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HijriStreakCalenderDialogState();
}

class _HijriStreakCalenderDialogState
    extends ConsumerState<HijriStreakCalenderDialog> {
  late HijriCalendar _currentHijri;
  final todayHijri = HijriCalendar.now();

  bool isLoading = false;
  List<DateTime> currentStreaks = [];

  List<String> months = [
    "Muharram",
    "Safar",
    "Rabi' Al-Awwal",
    "Rabi' Al-Thani",
    "Jumada Al-Awwal",
    "Jumada Al-Thani",
    "Rajab",
    "Sha'aban",
    "Ramadan",
    "Shawwal",
    "Dhu Al-Qi'dah",
    "Dhu Al-Hijjah",
  ];

  @override
  void initState() {
    super.initState();
    _currentHijri = HijriCalendar.now();
    getStreaks(_currentHijri.hYear, _currentHijri.hMonth);
  }

  void _nextMonth() {
    setState(() {
      _currentHijri = HijriCalendar()
        ..hYear = _currentHijri.hMonth == 12
            ? _currentHijri.hYear + 1
            : _currentHijri.hYear
        ..hMonth = _currentHijri.hMonth == 12 ? 1 : _currentHijri.hMonth + 1
        ..hDay = 1;
    });
    getStreaks(_currentHijri.hYear, _currentHijri.hMonth);
  }

  void _prevMonth() {
    setState(() {
      _currentHijri = HijriCalendar()
        ..hYear = _currentHijri.hMonth == 1
            ? _currentHijri.hYear - 1
            : _currentHijri.hYear
        ..hMonth = _currentHijri.hMonth == 1 ? 12 : _currentHijri.hMonth - 1
        ..hDay = 1;
    });
    getStreaks(_currentHijri.hYear, _currentHijri.hMonth);
  }

  void getStreaks(int year, int month) async {
    setState(() {
      isLoading = true;
    });
    final streaks = await ref
        .read(authNotifierProvider.notifier)
        .getStreakFor(year, month, context);
    setState(() {
      currentStreaks = streaks;
      isLoading = false;
    });
  }

  bool _isSameHijriDay(HijriCalendar a, HijriCalendar b) {
    return a.hYear == b.hYear && a.hMonth == b.hMonth && a.hDay == b.hDay;
  }

  @override
  Widget build(BuildContext context) {
    // Convert streak dates to hijri
    final hijriStreaks = currentStreaks
        .map((g) => HijriCalendar.fromDate(g))
        .where((h) =>
            h.hYear == _currentHijri.hYear && h.hMonth == _currentHijri.hMonth)
        .map((h) => h.hDay)
        .toSet();

    final daysInMonth = HijriCalendar().getDaysInMonth(
      _currentHijri.hYear,
      _currentHijri.hMonth,
    );

    // First day hijri to gregorian to get weekday
    final firstGregorian = HijriCalendar()
      ..hYear = _currentHijri.hYear
      ..hMonth = _currentHijri.hMonth
      ..hDay = 1;
    final weekday = firstGregorian.weekDay();

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
            color: Theme.of(context).cardColor,
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
                  Column(
                    children: [
                      InkWell(
                        onTap: () => _pickHijriMonth(context),
                        child: Text(
                          months[_currentHijri.hMonth - 1],
                          // "${_currentHijri.hMonth}",
                          style: const TextStyle(
                            // color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _pickHijriYear(context),
                        child: Text(
                          _currentHijri.hYear.toString(),
                          style: const TextStyle(
                            // color: Colors.white70,
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

              // WEEKDAYS
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
              isLoading
                  ? CircularProgressIndicator()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daysInMonth + weekday - 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (_, index) {
                        final day = index - (weekday - 2);

                        if (day < 1) return const SizedBox();

                        final currentDayHijri = HijriCalendar()
                          ..hYear = _currentHijri.hYear
                          ..hMonth = _currentHijri.hMonth
                          ..hDay = day;

                        final isToday =
                            _isSameHijriDay(currentDayHijri, todayHijri);
                        final isStreak = hijriStreaks.contains(day);

                        final isDayHasRest = widget.rests.any((r) {
                          int i = 0;
                          while (i <= r.numOfDays) {
                            final restHijri = HijriCalendar.fromDate(
                                r.startDate.add(Duration(days: i)));
                            if (_isSameHijriDay(restHijri, currentDayHijri)) {
                              return true;
                            }
                            i++;
                          }
                          final restHijri = HijriCalendar.fromDate(r.startDate);
                          return _isSameHijriDay(restHijri, currentDayHijri);
                        });

                        final isRest = currentDayHijri.weekDay() >= 5 &&
                                currentDayHijri.weekDay() !=
                                    widget.discussionWDay ||
                            isDayHasRest;

                        return _buildDayTile(day, isToday, isStreak,
                            isRest: isRest);
                      },
                    ),

              const SizedBox(height: 16),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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

  // Day Tile UI
  Widget _buildDayTile(int day, bool isToday, bool isStreak,
      {bool isRest = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isToday ? Colors.amber.withOpacity(0.25) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isToday ? Border.all(color: Colors.amber, width: 1.5) : null,
      ),
      child: Center(
        child: Container(
          // padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color:
                isStreak ? Colors.green.withOpacity(0.2) : Colors.transparent,
            shape: BoxShape.circle,
            border:
                isStreak ? Border.all(color: Colors.orange, width: 2) : null,
          ),
          child: isStreak
              ? Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.orange,
                )
              : isRest
                  ? Icon(
                      Icons.coffee,
                      color: Theme.of(context) == ThemeData.dark()
                          ? Colors.white24
                          : Colors.black26,
                      // color: Colors.orange,
                    )
                  : Text(
                      "$day",
                      style: TextStyle(
                        // color: Colors.white,
                        fontWeight:
                            isStreak ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
        ),
      ),
    );
  }

  // Month picker
  Future<void> _pickHijriMonth(BuildContext context) async {
    final months =
        h.monthNames.values.toList(); //HijriCalendar.getLongMonthNames();
    print(months);
    final selected = await showDialog<int>(
      context: context,
      builder: (_) => SimpleDialog(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text("Select Hijri Month",
            style: TextStyle(color: Colors.white)),
        children: months.asMap().entries.map((e) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, e.key + 1),
            child: Text(e.value, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        _currentHijri = HijriCalendar()
          ..hYear = _currentHijri.hYear
          ..hMonth = selected
          ..hDay = 1;
      });
      getStreaks(_currentHijri.hYear, _currentHijri.hMonth);
    }
  }

  // Year picker
  Future<void> _pickHijriYear(BuildContext context) async {
    final years = List.generate(40, (i) => todayHijri.hYear - 20 + i);

    final selected = await showDialog<int>(
      context: context,
      builder: (_) => SimpleDialog(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text("Select Hijri Year",
            style: TextStyle(color: Colors.white)),
        children: years
            .map(
              (y) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, y),
                child: Text(
                  "$y",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
            .toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        _currentHijri = HijriCalendar()
          ..hYear = selected
          ..hMonth = _currentHijri.hMonth
          ..hDay = 1;
      });
      getStreaks(_currentHijri.hYear, _currentHijri.hMonth);
    }
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context) == ThemeData.dark()
              ? Colors.white10
              : Colors.black12,
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }
}
