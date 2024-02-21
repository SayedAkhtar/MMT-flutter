// ignore_for_file: prefer_const_constructors

import 'package:MyMedTrip/components/CustomImageView.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PatientStories extends StatelessWidget {
  PatientStories(this.description, this.thumbnail,
      {super.key, this.videos, this.images});
  final String description;
  final String thumbnail;
  List<String>? videos;
  List<String>? images;

  List<String> _ids = [
  ];


  @override
  Widget build(BuildContext context) {
    String htmlData = description;
    _ids = [];
    videos?.forEach((element) {
      _ids.add(element.replaceAll('https://www.youtube.com/watch?v=', ''));
    });
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    );
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Patient Testimonials".tr,
        showDivider: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CustomSpacer.S),
        child: ListView(
          children: [
            Html(data: htmlData),
            CustomSpacer.s(),
            Text("Images : ", style: AppStyle.txtUrbanistSemiBold18.copyWith(fontSize: 20),),
            CustomSpacer.xs(),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: images?.length,
              itemBuilder: (context, index) {
                return Image.network(
                  images![index],
                  fit: BoxFit.cover,
                );
              },
            ),
            CustomSpacer.s(),
            Text("Videos : ", style: AppStyle.txtUrbanistSemiBold18.copyWith(fontSize: 20),),
            CustomSpacer.xs(),
            YoutubePlayer(controller: _controller),

          ],
        ),
      ),
    );
  }
}
