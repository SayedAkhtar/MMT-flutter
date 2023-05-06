// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/components/CustomAutocomplete.dart';
import 'package:mmt_/components/CustomElevetedButton.dart';
import 'package:mmt_/components/FormLabel.dart';
import 'package:mmt_/constants/colors.dart';
import 'package:mmt_/controller/controllers/teleconsult_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/models/doctor.dart';
import 'package:mmt_/screens/Video_consult/shedule.dart';

class TeLe_Consult_page extends StatefulWidget {
  const TeLe_Consult_page({super.key});

  @override
  State<TeLe_Consult_page> createState() => _TeLe_Consult_pageState();
}

class _TeLe_Consult_pageState extends State<TeLe_Consult_page> {

  late TeleconsultController controller;
  bool _doctorsFound = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(TeleconsultController());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        pageName: "Video Consulting",
        showDivider: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormLabel(
              "Specializations",
            ),
            CustomSpacer.s(),
            CustomAutocomplete(
                searchTable: "specializations",
                selectedId: controller.specializationId),
            CustomSpacer.s(),
            Row(
              children: [
                Text(
                  "Doctors",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                CustomSpacer.s(),
                Obx(
                      () => controller.doctors.value.length > 0 ? Text(
                        "( Found ${controller.doctors.value.length} doctor )",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ):SizedBox(),
                ),
              ],
            ),
            Expanded(
              child: Container(
                child: Obx(() {
                  if (!controller.isSearchingDoctor.value) {
                    return ListView.builder(
                        itemCount: controller.doctors.value.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            leading: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        controller.doctors.value[index].image!),
                                  ),
                                  color: MYcolors.bluecolor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      // color: Color.fromARGB(255, 189, 181, 181),
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 2,
                                      spreadRadius: 0,
                                      offset: Offset(0, 1),
                                    )
                                  ]),
                            ),
                            title: Text(
                              "${controller.doctors.value[index].name!}",
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                  color: MYcolors.blacklightcolors,
                                  fontFamily: "Brandon",
                                  fontSize: 18),
                            ),
                            subtitle: Text(
                              "${controller.doctors.value[index].experience!} years \n${controller.doctors.value[index].specialization!}",
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                  color: MYcolors.blacklightcolors,
                                  fontFamily: "Brandon",
                                  fontSize: 14),
                            ),
                            children:  controller.doctors.value[index].timeSlots!.map((DoctorTimeSlot e) =>ActionChip(
                              backgroundColor: MYcolors.greenlightcolor,
                              avatar: Icon(Icons.timer, color: Colors.white70,),
                              labelStyle: TextStyle(
                                  color: Colors.white70
                              ),
                              label: Text("${e.dayName}"),
                              onPressed: (){
                                controller.confirmAppointmentSlot(e, controller.doctors.value[index].price);
                              },
                            )).toList(),
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
              ),
            ),
            CustomElevatedButton(
              onPressed: () {
                controller.getDoctors();
                // Get.to(Schedule_page());
              },
              child: Text(
                _doctorsFound?"Proceed":"Search Doctor",
                style: TextStyle(
                    color: MYcolors.whitecolor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              // alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                "Please remember that there is may be charge applied to video consulting",
                style: TextStyle(
                    // color: MYcolors.whitecolor,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
