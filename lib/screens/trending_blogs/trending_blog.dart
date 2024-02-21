// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:MyMedTrip/providers/home_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/screens/trending_blogs/read_blog.dart';

import '../../components/CustomAppAbrSecondary.dart';
import '../../components/CustomImageView.dart';
import '../../constants/size_utils.dart';
import '../../helper/CustomSpacer.dart';
import '../../helper/Utils.dart';
import '../../models/blog.dart';
import '../../theme/app_style.dart';

class TrendingBlogs extends StatefulWidget {
  const TrendingBlogs({super.key});

  @override
  State<TrendingBlogs> createState() => _TrendingBlogsState();
}

class _TrendingBlogsState extends State<TrendingBlogs> {
  bool blogLoading = true;
  List blogs = [];
  int currPage = 1;
  bool noBlogs = false;
  ScrollController lazyScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    fetchBlogData(1);
    lazyScrollController.addListener(() {
      if(lazyScrollController.position.pixels == lazyScrollController.positions.last.maxScrollExtent){
        fetchBlogData(currPage);
      }
    });
    super.initState();
  }

  void fetchBlogData(int page) async {
    try{
      if(!noBlogs){
        List<Blog> blogData = await Get.put(HomeProvider()).fetchBlogData(page: page);
        print(blogData);
        if(context.mounted) {
          if(blogData.isEmpty){
            setState(() {
              noBlogs = true;
            });
          }else{
            setState(() {
              blogs.addAll(blogData);
              // blogs = ;
              blogLoading = false;
              currPage = currPage+1;
            });
          }
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSecondary(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        ),
        leadingWidth: 64,
        height: getVerticalSize(kToolbarHeight),
        title: Text("Trending Blogs".tr, style: AppStyle.txtUrbanistRomanBold20),
        centerTitle: true,
      ),
      // backgroundColor: MYcolors.blackcolor,
      body: blogs.isNotEmpty ?ListView.builder(
          controller: lazyScrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: blogLoading ? (blogs.length + 1) : blogs.length,
          itemBuilder: (_, index) {
            Blog currBlog = blogs[index];
            RegExp exp = RegExp(r"<[^>]*>",
                multiLine: true, caseSensitive: true);
            if(blogLoading){
              return
              SizedBox(
                child: Center(child: CircularProgressIndicator(),),
              );
            }
            // return Text(index.toString());
            return GestureDetector(
              onTap: () {
                Get.to(() => ReadBlogPage(currBlog.title!,
                    currBlog.content!, currBlog.thumbnail!));
              },
              child: SizedBox(
                height: 350,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomImageView(
                          url: currBlog.thumbnail!,
                          fit: BoxFit.cover,
                          height: getVerticalSize(150),
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(CustomSpacer.XS),
                        child: Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    right: CustomSpacer.XS,
                                    left: CustomSpacer.XS),
                                decoration: BoxDecoration(
                                    color: MYcolors.bluecolor,
                                    borderRadius:
                                    BorderRadius.circular(
                                        10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(0.5),
                                        blurRadius: 2,
                                        spreadRadius: 0,
                                        offset:
                                        const Offset(0, 1),
                                      )
                                    ]),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.20,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${currBlog.getFormattedDate().day}",
                                      style: AppStyle
                                          .txtUrbanistRomanBold32
                                          .copyWith(
                                          color:
                                          Colors.white),
                                    ),
                                    Text(
                                      Utils.getMonthShortName(
                                          currBlog
                                              .getFormattedDate()
                                              .month),
                                      style: AppStyle
                                          .txtUrbanistRomanBold20
                                          .copyWith(
                                          color:
                                          Colors.white),
                                    ),
                                  ],
                                )),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${currBlog.title}",
                                    maxLines: 3,
                                    style: AppStyle
                                        .txtUrbanistRomanBold20
                                        .copyWith(
                                        overflow:
                                        TextOverflow
                                            .ellipsis),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${currBlog.excerpt?.replaceAll(exp, '')}",
                                      maxLines: 3,
                                      style: AppStyle
                                          .txtUrbanistRegular18
                                          .copyWith(
                                          overflow:
                                          TextOverflow
                                              .ellipsis),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            right: CustomSpacer.XS),
                        child: TextButton(
                          onPressed: () {
                            Get.to(() => ReadBlogPage(
                                currBlog.title!,
                                currBlog.content!,
                                currBlog.thumbnail!));
                          },
                          child: Text(
                            'Explore'.tr,
                            style: AppStyle
                                .txtUrbanistRomanBold18Cyan60001,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }): Center(
        child: SizedBox(
          child: noBlogs ? Center(child: Text("No Blogs Data Available".tr),):Center(child: CircularProgressIndicator(),),
        ),
      ),
    );
  }
}
