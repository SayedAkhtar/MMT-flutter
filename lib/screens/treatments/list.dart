import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/CustomCardWithImage.dart';
import 'package:MyMedTrip/components/MarginBox.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/models/treatment.dart';
import 'package:MyMedTrip/providers/hospital_provider.dart';
import 'package:MyMedTrip/screens/Home_screens/SearchScreen.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TreatmentsList extends StatefulWidget {
  const TreatmentsList({super.key});

  @override
  State<TreatmentsList> createState() => _TreatmentsListState();
}

class _TreatmentsListState extends State<TreatmentsList> {
  late HospitalProvider provider;

  @override
  void initState() {
    provider = Get.put(HospitalProvider());
    super.initState();
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
        title: Text("Treatments List", style: AppStyle.txtUrbanistRomanBold20),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
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
                  Text('Search for Treatments'.tr),
                  CustomSpacer.s(),
                  const Icon(Icons.search_rounded),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: provider.getAllTreatments(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.isNotEmpty) {
                        List<Treatment?>? data = snapshot.data;
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, i) {
                              return CustomCardWithImage(
                                width: getHorizontalSize(160),
                                onTap: () {},
                                imageUri: data![i]!.logo,
                                title: data[i]!.name!,
                                titleStyle: AppStyle.txtUrbanistRomanBold10
                                    .copyWith(fontSize: 11),
                                bgColor: MYcolors.bluecolor,
                                imageHeight: 40,
                                // bodyText: hospitals[i]!.address,
                              );
                            });
                      }
                    }
                    return const Center(
                      child: Text("No Treatment to show"),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
