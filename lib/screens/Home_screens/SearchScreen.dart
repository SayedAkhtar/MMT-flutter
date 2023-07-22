import 'dart:convert';

import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomCardWithImage.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/controller/controllers/doctor_controller.dart';
import 'package:MyMedTrip/controller/controllers/hospital_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/providers/base_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchFieldController;
  late FocusNode searchNode;
  late BaseProvider provider;
  final searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchFieldController = TextEditingController();
    provider = Get.put(BaseProvider());
    searchNode = FocusNode();
    searchNode.requestFocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    provider.dispose();
  }

  Future searchDoctorsAndHospitals() async {
    if (searchFieldController.text.length > 2) {
      Response? res =
          await provider.get('/search?term=${searchFieldController.text}');
      if (res.isOk) {
        var jsonString = res.body['DATA'];
        return jsonString;
      }
    }
    return Future(() => null);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Row(
          children: [
            Flexible(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios))),
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: CustomSpacer.S),
                padding: const EdgeInsets.symmetric(horizontal: CustomSpacer.S),
                decoration: BoxDecoration(
                    color: MYcolors.whitecolor,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: const Offset(0, 1),
                      )
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_rounded),
                    CustomSpacer.s(),
                    Expanded(
                      child: TextField(
                        controller: searchFieldController,
                        onChanged: (term) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            hintText: 'Search for doctors and hospitals'.tr,
                            border: InputBorder.none),
                        focusNode: searchNode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: searchDoctorsAndHospitals(),
        builder: (_, AsyncSnapshot snapshot) {
          if (searchFieldController.text.length < 3) {
            return const Padding(
              padding: EdgeInsets.all(CustomSpacer.S),
              child: Text("Please enter 3 or more character to begin search"),
            );
          }
          if (snapshot.hasData) {
            List result = snapshot.data;
            return searchSection(result);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Text("No data to display");
        },
      ),
    ));
  }

  Widget searchSection(List data) {
    // if(searchFieldController.text.length < 3){
    //   return Container(
    //     child: Text("Please enter 3 or more character to begin search"),
    //   );
    // }else{
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: data.length,
        itemBuilder: (_, i) {
          return CustomCardWithImage(
            width: getHorizontalSize(160),
            onTap: () {
              if (data[i]['type'] == 'doctor') {
                Get.toNamed(Routes.doctorPreviewNew,
                    arguments: {'id': data[i]['id']});
              }
              if (data[i]['type'] == 'hospital') {
                Get.toNamed(Routes.hospitalPreview,
                    arguments: {'id': data[i]['id']});
              }
            },
            imageUri: data[i]['logo'],
            title: data[i]['name'],
            bodyText: data[i]['description'],
            // bodyText: hospitals[i]!.address,
          );
        });
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, index) {
          return SizedBox(
              height: 100,
              child: InkWell(
                onTap: () {},
                child: Card(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Image.network("${data[index]['logo']}",
                            fit: BoxFit.fill,
                            width: 180, loadingBuilder: (BuildContext ctx,
                                Widget child,
                                ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                            );
                          }
                        }, errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                          return const Center(
                              child: Text('No image to display'));
                        }),
                      ),
                      CustomSpacer.s(),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[index]['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 60,
                              child: RichText(
                                text: TextSpan(
                                    text: data[index]['description'],
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black54)),
                                overflow: TextOverflow.clip,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
          return CustomCardWithImage(
            onTap: () {},
            imageUri:
                "https://via.placeholder.com/640x480.png/00eeaa?text=No%20Image",
            title: "Text",
            bodyText: "52, nando ghosh road. Howrah 711101",
            icon: Icons.pin_drop,
          );
        });
    // }
  }
}
