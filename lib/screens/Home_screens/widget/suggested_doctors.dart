import 'package:MyMedTrip/components/CustomCardWithImage.dart';
import 'package:MyMedTrip/components/RowHeader.dart';
import 'package:MyMedTrip/constants/home_model.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/doctor/doctor_details_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestedDoctors extends StatelessWidget {
  const SuggestedDoctors({super.key, required this.data});

  final List<DoctorsHome> data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RowHeader(
            heading: "Suggested Doctors",
            action: () {
              Get.toNamed(Routes.doctors, arguments: {'type': 'allDoctor'});
            }),
        SizedBox(
          height: getVerticalSize(240),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (_, index) {
                return CustomCardWithImage(
                  width: getHorizontalSize(160),
                  onTap: () {
                    Get.toNamed(Routes.doctorPreviewNew, arguments: {
                      'id': data[index].id,
                    });
                  },
                  imageUri: data[index].avatar,
                  title: data[index].name!,
                  bodyText: data[index].designation,
                );
              }),
        ),
      ],
    );
  }
}
