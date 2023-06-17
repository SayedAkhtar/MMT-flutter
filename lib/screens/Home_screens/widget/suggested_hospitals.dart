import 'package:MyMedTrip/components/CustomCardWithImage.dart';
import 'package:MyMedTrip/components/RowHeader.dart';
import 'package:MyMedTrip/constants/home_model.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Hospitals/hospital_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestedHospitals extends StatelessWidget {
  const SuggestedHospitals({super.key, required this.data});

  final List<Hospitals> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RowHeader(
            heading: "Suggested Hospitals",
            action: () {
              Get.toNamed(Routes.hospitals,
                  arguments: {'type': 'allHospitals'});
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
                    Get.toNamed(Routes.hospitalPreview,
                        arguments: {'id': data[index].id});
                  },
                  imageUri: data[index].logo,
                  title: data[index].name,
                  bodyText: data[index].address,
                  imagePadding: const EdgeInsets.all(10),
                );
              }),
        ),
      ],
    );
  }
}
