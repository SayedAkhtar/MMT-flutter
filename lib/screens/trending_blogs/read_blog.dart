// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';

class ReadBlogPage extends StatelessWidget {
  ReadBlogPage( this.title,this.description, this.thumbnail, {super.key, this.pageTitle = "Blog Detail", this.videos = "", this.images = ""});
  final String description;
  final String title;
  final String thumbnail;
  String pageTitle;
  final videos;
  final images;
  @override
  Widget build(BuildContext context) {
    String htmlData = '<h1>$title</h1><br/> <img src="$thumbnail" /> $description';
    return Scaffold(
      appBar: CustomAppBar(pageName: pageTitle.tr,showDivider: true,),
      body: Padding(
    padding: const EdgeInsets.symmetric(horizontal: CustomSpacer.S),
    child: SingleChildScrollView(
      child: Html(data: htmlData)
    ),
      ),
    );
  }
}
