import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_calendar/hijri_calendar.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/static_datas.dart';
import 'package:islamic_online_learning/core/widgets/bouncy_button.dart';
import 'package:islamic_online_learning/features/auth/model/const_score.dart';
import 'package:islamic_online_learning/features/auth/model/score.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/features/quiz/model/test_attempt.dart';
import 'package:islamic_online_learning/features/quiz/view/pages/question_page.dart';

class RestCard extends ConsumerStatefulWidget {
  final Rest rest;
  final bool isLocked;
  const RestCard({
    super.key,
    required this.rest,
    required this.isLocked,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RestCardState();
}

class _RestCardState extends ConsumerState<RestCard> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    // final authState = ref.watch(authNotifierProvider);
    final starthijri = HijriCalendarConfig.fromGregorian(widget.rest.date);
    final startArabicDate = "${starthijri.toFormat("DD, MM dd, yyyy")} هـ";
    final endhijri = HijriCalendarConfig.fromGregorian(
      widget.rest.date.add(
        Duration(
          days: widget.rest.amount,
        ),
      ),
    );
    final endArabicDate = "${endhijri.toFormat("DD, MM dd, yyyy")} هـ";

    return Container(
      // key:_key,
      margin: EdgeInsets.only(
        top: 10,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 10,
            ),
            child: Stack(
              children: [
                Column(
                  spacing: 3,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.coffee_rounded,
                          color: Colors.grey,
                          size: 40,
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 3,
                                children: [
                                  Text(
                                    "እረፍት",
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    widget.rest.reason,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "ከ $startArabicDate",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        // fontSize: 16,
                                        // fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Text(
                                    "እስክ $endArabicDate",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        // fontSize: 16,
                                        // fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3,
                                    vertical: .5,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    //: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    "ለ ${widget.rest.amount} ቀን",
                                    // style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                if (widget.isLocked)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(Icons.lock_outline),
                  ),
              ],
            ),
          ),
          if (widget.isLocked)
            Positioned.fill(
              child: Container(
                color:
                    theme == ThemeMode.light ? Colors.white60 : Colors.black54,
              ),
            ),
        ],
      ),
    );
  }
}
