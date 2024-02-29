// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:MyMedTrip/components/FileViewerScreen.dart';
import 'package:MyMedTrip/constants/constants.dart';
import 'package:MyMedTrip/models/query_response_model.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/FormLabel.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/FirebaseFunctions.dart';
import 'package:logger/logger.dart';

import '../../constants/api_constants.dart';
import '../../constants/colors.dart';

class EditDocumentForVisaForm extends StatefulWidget {
  const EditDocumentForVisaForm(this.response, {super.key});
  final QueryResponse response;
  @override
  State<EditDocumentForVisaForm> createState() =>
      _EditDocumentForVisaFormState();
}

class _EditDocumentForVisaFormState extends State<EditDocumentForVisaForm> {
  late QueryController _controller;

  String patientPassport = "";
  List<dynamic> attendantPassport = [];
  String secondAttendantPassport = "";
  String selectedCountry = "";
  String selectedCity = "";
  String fromCountry = "";
  String fromCity = "";
  List? vil = [];
  List<String> cityNames = [];
  @override
  void initState() {
    // TODO: implement initState
    selectedCountry = widget.response.response!['country'];
    patientPassport = widget.response.response!['passport'];
    attendantPassport = widget.response.response!['attendant_passport'] ?? [];
    selectedCity = widget.response.response!['city'];
    fromCountry = widget.response.response!['from_country'] ?? '';
    fromCity = widget.response.response!['from_city'] ?? '';
    vil = widget.response.response!['vil'];
    buildCountryOption(Constants.countryIdMap[selectedCountry.toLowerCase()]!);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  buildCountryOption(int countryId) async {
    var t = await GetConnect(allowAutoSignedCert: true)
        .get('$base_uri/ajax-search/cities?country_id=$countryId');
    List<String> temp = [];
    Logger().d(t.statusText);
    if (t.statusCode == 200) {
      t.body['data'].forEach((element) {
        temp.add(element['name']);
      });
    }
    setState(() {
      cityNames = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(vil);
    return Scaffold(
      body: SingleChildScrollView(
        child: Builder(builder: (ctrl) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: CustomSpacer.S),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (vil != null && vil!.isNotEmpty)
                    ? GridView(
                  shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: CustomSpacer.S, crossAxisSpacing: CustomSpacer.S),
                        children: vil!
                            .map(
                              (e) => GestureDetector(
                                onTap: () async {
                                  Get.to(() => FileViewerScreen(fileUrl: e!));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(CustomSpacer.XS),
                                  // decoration: BoxDecoration(
                                  //   border: Border.fromBorderSide(BorderSide(color: Colors.black54)),
                                  //   borderRadius: BorderRadius.circular(CustomSpacer.S)
                                  // ),
                                  margin:
                                      EdgeInsets.only(bottom: CustomSpacer.L),
                                  child:
                                  Column(
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: e!.endsWith('.pdf') ?  Image.asset('assets/icons/pdf_file.png') : Image.network(
                                            e!,),
                                      ),
                                      CustomSpacer.xs(),
                                      Flexible(child: Text(e!.split('/').last, style: AppStyle.txtUrbanistRegular16.copyWith(color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : const SizedBox(),
                CustomSpacer.m(),
                FormLabel(
                  "From which country will you be applying for the visa?".tr,
                ),
                CustomSpacer.m(),
                FormLabel(
                  "Country".tr,
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(
                      left: 15, bottom: 15, top: 11, right: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withAlpha(60)),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    selectedCountry.isNotEmpty ? selectedCountry : "",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                CustomSpacer.s(),
                FormLabel(
                  "City".tr,
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(
                      left: 15, bottom: 15, top: 11, right: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withAlpha(60)),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    selectedCity.isEmpty ? "Select City".tr : selectedCity,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                Builder(builder: (ctx){
                  if(fromCountry.isNotEmpty && fromCity.isNotEmpty){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSpacer.m(),
                        FormLabel(
                          "Please select your destination country for travel".tr,
                        ),
                        CustomSpacer.m(),
                        FormLabel(
                          "Country".tr,
                        ),
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(
                              left: 15, bottom: 15, top: 11, right: 15),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.withAlpha(60)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            fromCountry.isNotEmpty ? fromCountry : "",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                        CustomSpacer.s(),
                        FormLabel(
                          "City".tr,
                        ),
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(
                              left: 15, bottom: 15, top: 11, right: 15),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.withAlpha(60)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            fromCity.isEmpty ? "Select City".tr : fromCity,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    );
                  }
                  return SizedBox();
                }),

              ],
            ),
          );
        }),
      ),
    );
  }
}
