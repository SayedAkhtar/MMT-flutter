// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/CustomCardWithImage.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/constants/api_constants.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/providers/hospital_provider.dart';
import 'package:MyMedTrip/screens/Hospitals/hospital_preview.dart';
import 'package:MyMedTrip/constants/colors.dart';

import '../../controller/controllers/hospital_controller.dart';
import '../../models/hospital_model.dart';

class HospitalsListPage extends GetView<HospitalController> {
  const HospitalsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    HospitalProvider provider = Get.put(HospitalProvider());
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
        title: Text("All Hospitals", style: AppStyle.txtUrbanistRomanBold20),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(CustomSpacer.S),
        child: FutureBuilder(
          future: provider.getAllHospitals(),
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
            }
            return Center(child: Text("No Hospitals to show"),);
          }
        ),
      ),
    );
  }
}
