// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/constants/query_step_name.dart';
import 'package:mmt_/controller/controllers/query_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/providers/query_provider.dart';
import 'package:mmt_/screens/Medical_visa/visa_end_page.dart';

import '../../constants/colors.dart';
import '../../models/query_response_model.dart';

class Upload_Ticket_visa extends StatefulWidget {
  const Upload_Ticket_visa({super.key});

  @override
  State<Upload_Ticket_visa> createState() => _Upload_Ticket_visaState();
}

class _Upload_Ticket_visaState extends State<Upload_Ticket_visa> {
  late QueryProvider _provider;
  late QueryController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provider = Get.put(QueryProvider());
    _controller = Get.find<QueryController>();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(pageName: "Upload Ticket and Visa", showDivider: true,),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: FutureBuilder(
          future: _provider.getQueryStepData(_controller.selectedQuery, QueryStep.ticketsAndVisa),
          builder: (context, AsyncSnapshot snapshot) {
            print(snapshot);
            if(snapshot.hasData){
              QueryResponse data = snapshot.data;
              print(data.response.toString());
              print('printing');
            }
            return Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showAdaptiveActionSheet(
                          context: context,
                          actions: <BottomSheetAction>[
                            BottomSheetAction(
                              title: Text('Upload New Photo'.tr),
                              onPressed: (_) {},
                            ),
                            BottomSheetAction(
                              title: Text('Choose from Library'.tr),
                              onPressed: (_) {},
                            ),
                            BottomSheetAction(
                              title: Text('Remove Photo'.tr,
                                  style: TextStyle(color: MYcolors.redcolor)),
                              onPressed: (_) {},
                            ),
                          ],
                          cancelAction: CancelAction(
                              title: Text(
                            'Cancel'.tr,
                            style: TextStyle(color: MYcolors.redcolor),
                          )),
                        );
                      },
                      child: Container(
                        // color: MYcolors.bluecolor,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border:
                                Border.all(color: MYcolors.blackcolor, width: 0.2)),
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Icon(Icons.add),
                      ),
                    ),
                    CustomSpacer.s(),
                    Text(
                      "Upload ticket here".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                CustomSpacer.m(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showAdaptiveActionSheet(
                          context: context,
                          actions: <BottomSheetAction>[
                            BottomSheetAction(
                              title: Text('Upload New Photo'.tr),
                              onPressed: (_) {},
                            ),
                            BottomSheetAction(
                              title: Text('Choose from Library'.tr),
                              onPressed: (_) {},
                            ),
                            BottomSheetAction(
                              title: Text('Remove Photo'.tr,
                                  style: TextStyle(color: MYcolors.redcolor)),
                              onPressed: (_) {},
                            ),
                          ],
                          cancelAction: CancelAction(
                              title: Text(
                            'Cancel'.tr,
                            style: TextStyle(color: MYcolors.redcolor),
                          )),
                        );
                      },
                      child: Container(
                        // color: MYcolors.bluecolor,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border:
                                Border.all(color: MYcolors.blackcolor, width: 0.2)),
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Icon(Icons.add),
                      ),
                    ),
                    CustomSpacer.s(),
                    Text(
                      "Upload ticket here".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.to(Visa_submit_page());
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      minimumSize: Size(double.infinity, 40)),
                  child: Text(
                    "Submit".tr,
                    style: TextStyle(
                      color: MYcolors.whitecolor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    ));
  }
}
