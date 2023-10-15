import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/audio_item.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/current_audio_view.dart';

class CourseDetail extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const CourseDetail(this.courseModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseDetailState();
}

class _CourseDetailState extends ConsumerState<CourseDetail> {
  List<String> audios = [];

  @override
  void initState() {
    super.initState();
    audios = widget.courseModel.courseIds.split(",");
  }

  @override
  Widget build(BuildContext context) {
    final currentAudio = ref.watch(currentAudioProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseModel.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            currentAudio != null ? 60 : 0,
          ),
          child: currentAudio != null
              ? CurrentAudioView(currentAudio)
              : const SizedBox(),
        ),
      ),
      body: Stack(
        children: [
          Image.network(
            widget.courseModel.image,
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            padding: const EdgeInsets.only(
              top: 20,
            ),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: ListView.builder(
              itemCount: audios.length,
              itemBuilder: (context, index) => AudioItem(
                audios[index],
                "${widget.courseModel.title} ${index + 1}",
                widget.courseModel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
