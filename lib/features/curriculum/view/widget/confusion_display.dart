import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/auth/model/confusion.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/confusion_display_dialog.dart';

class ConfusionDisplay extends ConsumerStatefulWidget {
  final Confusion confusion;
  const ConfusionDisplay({super.key, required this.confusion});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfusionDisplayState();
}

class _ConfusionDisplayState extends ConsumerState<ConfusionDisplay> {
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
                      Icons.question_answer_outlined,
                      color: Colors.blue,
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
                                "ጥያቄ",
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                              widget.confusion.rejectedBecause != null
                                  ? Text(
                                      "ምክንያት: ${widget.confusion.rejectedBecause!}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : Text(
                                      "ተመልሷል",
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
                                    color: widget.confusion.response != null
                                        ? Colors.blue
                                        : Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  widget.confusion.response != null
                                      ? "ተመልሷል"
                                      : "አልተመለሰም",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: widget.confusion.response != null
                                        ? Colors.blue
                                        : Colors.red,
                                  ),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                widget.confusion.rejectedBecause != null
                    ? SizedBox()
                    : SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) =>
                            //         QuestionPage(widget.examData.title),
                            //   ),
                            // );
                            showBottomSheet(
                              context: context,
                              builder: (context) {
                                return ConfusionDisplayDialog(
                                  confusion: widget.confusion,
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            foregroundColor: Colors.blue,
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            "ክፈት",
                            style: TextStyle(
                              fontSize: 16,
                              // color: whiteColor,
                            ),
                          ),
                        ),
                        // )
                        // : SizedBox(),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
