// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/CustomCardWithImage.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/providers/doctor_provider.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/models/doctor.dart';
import 'package:MyMedTrip/routes.dart';

class Doctors_list_page extends StatefulWidget {
  const Doctors_list_page({super.key});

  @override
  State<Doctors_list_page> createState() => _Doctors_list_pageState();
}

class _Doctors_list_pageState extends State<Doctors_list_page> {
  late DoctorProvider api;
  List<Doctor?>? _doctors = [];
  @override
  void initState() {
    super.initState();
    api = Get.put(DoctorProvider());
    var arguments = Get.arguments;
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
        title: Text("Doctors List", style: AppStyle.txtUrbanistRomanBold20),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(CustomSpacer.S),
              margin: const EdgeInsets.only(bottom: CustomSpacer.S),
              decoration: BoxDecoration(
                  color: MYcolors.whitecolor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: const Offset(0, 1),
                    )
                  ]),
              height: CustomSpacer.M * 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Search for Doctors'.tr),
                  CustomSpacer.s(),
                  const Icon(Icons.search_rounded),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: api.getAllDoctors(),
                builder: (_, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }else if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData && snapshot.data != null &&snapshot.data!.isNotEmpty){
                      List<Doctor?>? data = snapshot.data;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, i) {
                          return CustomCardWithImage(
                        width: getHorizontalSize(160),
                        onTap: () {
                          Get.toNamed(Routes.hospitalPreview,
                              arguments: {'id': data![i]!.id});
                        },
                        imageUri: data![i]!.image!,
                        title: data[i]!.name!,
                        // bodyText: hospitals[i]!.address,
                      );
                    }
                      );
                    }
                  }
                  return Center(child: Text("No Hospitals to show"),);
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
