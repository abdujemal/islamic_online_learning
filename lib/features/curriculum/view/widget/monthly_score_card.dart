import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/model/monthly_score.dart';

class MonthlyScoreCard extends ConsumerStatefulWidget {
  final MonthlyScore monthlyScore;
  const MonthlyScoreCard({super.key, required this.monthlyScore});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MonthlyScoreCardState();
}

class _MonthlyScoreCardState extends ConsumerState<MonthlyScoreCard> {
  Color getColor(double prcnt) {
    prcnt = prcnt * 100;
    if (prcnt < 50) {
      return Colors.red;
    } else {
      return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
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
                      Icons.grade,
                      color: Colors.amber,
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
                                "ወርሃዊ ውጤት",
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                "ወር ${widget.monthlyScore.month}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
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
                                  border: Border.all(
                                    color: getColor(
                                      widget.monthlyScore.score /
                                          widget.monthlyScore.outOf,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  "${widget.monthlyScore.score}/${widget.monthlyScore.outOf} ነጥብ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: getColor(
                                      widget.monthlyScore.score /
                                          widget.monthlyScore.outOf,
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: widget.isCurrent && score == null
                //       ? BouncyElevatedButton(
                //           child: ElevatedButton(
                //             onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) =>
                //         QuestionPage(widget.examData.title),
                //   ),
                // );
                //             },
                //             style: ElevatedButton.styleFrom(
                //               backgroundColor: Colors.purple,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(50),
                //               ),
                //             ),
                //             child: const Text(
                //               "ፈተናውን ጀምር",
                //               style: TextStyle(
                //                 fontSize: 16,
                //                 color: whiteColor,
                //               ),
                //             ),
                //           ),
                //         )
                //       : SizedBox(),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
