import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:islamic_online_learning/core/Schedule%20Feature/schedule.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

class ScheduleView extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const ScheduleView(this.courseModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends ConsumerState<ScheduleView> {
  DateTime selectedSheduleDateTime = DateTime.now();
  final TextEditingController _timeController = TextEditingController();

  Map<String, bool> weekDays = {
    "ሰኞ": false,
    "ማክሰኞ": false,
    "ረቡእ": false,
    "ሐሙስ": false,
    "አርብ": false,
    "ቅዳሜ": false,
    "እሁድ": false,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  timePicker() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _timeController.text.isEmpty
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(
              selectedSheduleDateTime,
            ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      final DateTime currentTime = DateTime.now();
      selectedSheduleDateTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      _timeController.text = DateFormat.jm().format(selectedSheduleDateTime);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 330,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "አስታዋሽ መመዝገቢያ",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "እባክዎ የሚመችዎትን ሰዓት ይሙሉ።";
                    }
                    return null;
                  },
                  controller: _timeController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    focusColor: primaryColor,
                    hintText: "የቂርዓት ሰዓት",
                    suffixIcon: Icon(
                      Icons.timer,
                      color: primaryColor,
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    timePicker();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Wrap(
                  spacing: 3,
                  children: List.generate(
                    weekDays.keys.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          weekDays[weekDays.keys.toList()[index]] =
                              !weekDays.values.toList()[index];
                        });
                      },
                      child: Chip(
                        label: Text(
                          weekDays.keys.toList()[index],
                        ),
                        backgroundColor: weekDays.values.toList()[index]
                            ? primaryColor
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      bool check = false;
                      weekDays.forEach((key, value) {
                        if (value) {
                          check = true;
                        }
                      });
                      if (!check) {
                        toast(
                          "እባክዎ ከቀናት ውስጥ የሚመችዎትን ቀን ይምረጡ።",
                          ToastType.error,
                          isLong: true,
                        );
                        return;
                      }

                      Schedule().scheduleNotification(0, "title", "body");
                      Navigator.pop(context);

                      // action
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 5,
                      ),
                      child: Text("መዝግብ"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
