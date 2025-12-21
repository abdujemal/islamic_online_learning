import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/view/pages/sign_in.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';
import 'package:islamic_online_learning/features/prerequisiteTest/view/pages/prerequisite_test_page.dart';

class CurriculumCard extends ConsumerStatefulWidget {
  final Curriculum curriculum;
  const CurriculumCard({required this.curriculum, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurriculumCardState();
}

class _CurriculumCardState extends ConsumerState<CurriculumCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: InkWell(
        onTap: () {
          if (!widget.curriculum.active) {
            toast("ይህ ክፍል ገና አልተጀመረም።", ToastType.error, context);
            return;
          }
          if (widget.curriculum.prerequisite) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PrerequisiteTestPage(
                  curr: widget.curriculum,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SignIn(
                  curriculumId: widget.curriculum.id,
                ),
              ),
            );
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 5),
              )
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            leading: Container(
              width: 70,
              // height: 70,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/grad.png",
                color: whiteColor,
              ),
            ),
            title: Text(widget.curriculum.title),
            subtitle: Text(widget.curriculum.description),
            trailing: Text(widget.curriculum.active ? "" : "በቅርብ ቀን"),
          ),
        ),
      ),
    );
  }
}
