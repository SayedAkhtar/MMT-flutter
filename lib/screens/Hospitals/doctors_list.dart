// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/doctor_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/locale/AppTranslation.dart';
import 'package:MyMedTrip/models/doctor.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Hospitals/doctors_details.dart';
import 'package:MyMedTrip/constants/colors.dart';

class Doctors_list_page extends StatefulWidget {
  const Doctors_list_page({super.key});

  @override
  State<Doctors_list_page> createState() => _Doctors_list_pageState();
}

class _Doctors_list_pageState extends State<Doctors_list_page> {
  late DoctorController controller;
  List<Doctor?>? _doctors = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<DoctorController>();
    var arguments = Get.arguments;
    fetchDoctors(arguments);
  }

  void fetchDoctors(arguments) async{
    List<Doctor?>? res= await controller.getDoctors(arguments: arguments);
    setState(() {
      _doctors = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_doctors!.length > 0){
      return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(pageName: "Doctors List", showDivider: true,),
            body: ListView.builder(
              itemCount: _doctors?.length,
              itemBuilder: (context, i){
                Doctor? _doctor = _doctors![i];
                return GestureDetector(
                  onTap: () {
                    controller.selectedDoctor = _doctor;
                    Get.toNamed(Routes.doctorPreview);
                  },
                  child: Container(
                    padding: EdgeInsets.all(CustomSpacer.S),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(_doctor!.image!),
                              ),
                              color: MYcolors.whitecolor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  // color: Color.fromARGB(255, 189, 181, 181),
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: Offset(0, 1),
                                )
                              ]
                          ),
                        ),
                        CustomSpacer.s(),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_doctor.name}",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                    color: MYcolors.blacklightcolors,
                                    fontFamily: "Brandon",
                                    fontSize: 18),
                              ),
                              Text(
                                "${_doctor.experience} years",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                    color: MYcolors.blacklightcolors,
                                    fontFamily: "Brandon",
                                    fontSize: 18),
                              ),
                              Text(
                                "${_doctor.specialization}",
                                softWrap: true,
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                    color: MYcolors.blacklightcolors,
                                    fontFamily: "Brandon",
                                    fontSize: 18),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ));
    }
    return Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );

  }
}
