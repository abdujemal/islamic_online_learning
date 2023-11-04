// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';

import 'package:islamic_online_learning/features/main/data/model/faq_model.dart';

class FaqItem extends ConsumerStatefulWidget {
  final FAQModel faqModel;
  const FaqItem({
    super.key,
    required this.faqModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FaqItemState();
}

class _FaqItemState extends ConsumerState<FaqItem> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, ct) {
      return ExpansionTile(
        textColor: primaryColor,
        title: Text(widget.faqModel.question),
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(Icons.subdirectory_arrow_right),
              Expanded(child: Text(widget.faqModel.answer)),
            ],
          ),
          SizedBox(
            height: 15,
          )
        ],
      );
    });
  }
}