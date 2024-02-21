// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/CustomCardWithImage.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/helper/Debouncer.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/constants/colors.dart';

import '../../controller/controllers/hospital_controller.dart';
import '../../models/hospital_model.dart';

class HospitalsListPage extends GetView<HospitalController> {
  const HospitalsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Debouncer? debouncer = Debouncer(milliseconds: 800);
    controller.getHospitals();
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
        title: Text("All Hospitals".tr, style: AppStyle.txtUrbanistRomanBold20),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4, top: 4),
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
              // height: CustomSpacer.M * 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for Hospitals'.tr,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: Icon(Icons.search_rounded),
                        suffixIconConstraints: BoxConstraints.tightFor(height: 20)
                      ),
                      onChanged: (String search){

                        debouncer.run(() {
                          String query = "query=$search&page=1";
                          controller.searchText.value = query;
                          controller.getHospitals();
                        });
                        // print(search);
                      },
                    ),
                  ),
                  // CustomSpacer.s(),
                  // const Icon(Icons.search_rounded),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                 (){
                  return FutureBuilder(
                    future: controller.hospital.value,
                    builder: (_, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }else if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasData && snapshot.data != null &&snapshot.data!.isNotEmpty){
                          List<Hospital?>? hospitals = snapshot.data;
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, i) {
                              return CustomCardWithImage(
                            width: getHorizontalSize(160),
                            fit: BoxFit.fitWidth,
                            imageAlign: Alignment.center,
                            imagePadding: EdgeInsets.symmetric(horizontal: 10),
                            onTap: () {
                              Get.toNamed(Routes.hospitalPreview,
                                  arguments: {'id': hospitals[i]!.id});
                            },
                            imageUri: hospitals![i]!.logo,
                            title: hospitals[i]!.name!,
                            // bodyText: hospitals[i]!.address,
                          );
                        }
                          );
                        }
                        else{
                          return Center(child: Text("No Hospitals to show".tr),);
                        }
                      }
                      return SizedBox();
                    }
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
