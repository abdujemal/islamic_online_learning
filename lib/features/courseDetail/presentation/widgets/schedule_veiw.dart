import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:islamic_online_learning/core/Schedule%20Feature/schedule.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

class ScheduleView extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  final Future<int?> Function(
      String scheduleDates, String scheduleTime, int isScheduleOn) onSave;
  const ScheduleView({
    required this.courseModel,
    required this.onSave,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends ConsumerState<ScheduleView> {
  DateTime selectedSheduleDateTime = DateTime.now();
  final TextEditingController _timeController = TextEditingController();

  int isScheduledOn = 0;

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
  void initState() {
    super.initState();

    if (widget.courseModel.scheduleDates.isEmpty) {
      isScheduledOn = 1;
    }

    if (widget.courseModel.scheduleDates.isNotEmpty &&
        widget.courseModel.scheduleTime.isNotEmpty) {
      _timeController.text = DateFormat.jm().format(
        DateTime.parse(
          widget.courseModel.scheduleTime,
        ),
      );

      selectedSheduleDateTime = DateTime.parse(
        widget.courseModel.scheduleTime,
      );

      final days =
          widget.courseModel.scheduleDates.split(",").map((e) => int.parse(e));

      for (int i in days) {
        weekDays[weekDays.keys.toList()[i - 1]] = true;
      }

      isScheduledOn = widget.courseModel.isScheduleOn;
      setState(() {});
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
          height: 360,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Text(
                //   "አስታዋሽ መመዝገቢያ",
                //   style: TextStyle(fontSize: 18),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                SwitchListTile(
                  dense: true,
                  title: const Text(
                    "አስታዋሽ መመዝገቢያ",
                    style: TextStyle(fontSize: 18),
                  ),
                  value: isScheduledOn == 1,
                  activeColor: primaryColor,
                  inactiveTrackColor: Colors.transparent,
                  onChanged: (bool? v) {
                    if (v == true) {
                      setState(() {
                        isScheduledOn = 1;
                      });
                    } else {
                      setState(() {
                        isScheduledOn = 0;
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
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
                      Icons.access_alarms_rounded,
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
                          style: TextStyle(
                            color: weekDays.values.toList()[index]
                                ? whiteColor
                                : null,
                          ),
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
                  onTap: () async {
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
                          context,
                          isLong: true,
                        );
                        return;
                      }

                      // final bool state =
                      //     await FlutterOverlayWindow.isPermissionGranted();

                      // if (!state) {
                      //   final bool? status =
                      //       await FlutterOverlayWindow.requestPermission();

                      //   if (status != true) {
                      //     toast("አስታዋሽዎን መመዝገብ አልቻልንም።", ToastType.error);
                      //     return;
                      //   }
                      // }

                      List<int> days = [];
                      int i = 0;
                      for (bool d in weekDays.values) {
                        i++;
                        if (d) {
                          days.add(i);
                        }
                      }

                      int? id = await widget.onSave(
                        days.join(","),
                        selectedSheduleDateTime.toString(),
                        isScheduledOn,
                      );

                      print("courseId: $id");

                      if (isScheduledOn == 1 && id != null) {
                        await Schedule().scheduleNotification(
                          id,
                          "የደርስ አስታዋሽ",
                          widget.courseModel.title,
                          selectedSheduleDateTime,
                          days,
                        );

                        List<int> otherDays = [1, 2, 3, 4, 5, 6, 7];
                        for (int e in days) {
                          otherDays.remove(e);
                        }
                        print(otherDays);
                        await Schedule().deleteNotification(
                          id,
                          otherDays,
                        );
                      } else {
                        await Schedule().deleteNotification(
                          id!,
                          days,
                        );
                      }

                      if (mounted) {
                        Navigator.pop(context);
                      }
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
                      child: Text(
                        "መዝግብ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
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
