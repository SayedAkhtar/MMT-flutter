// ignore_for_file: prefer_const_constructors
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/locale/AppTranslation.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/models/confirmed_query.dart';
import 'package:MyMedTrip/providers/query_provider.dart';
import 'package:MyMedTrip/screens/update_screen/connect_coordinotor.dart';
import 'package:logger/logger.dart';


class QueryConfirmed extends StatelessWidget {
  QueryConfirmed({super.key, this.showBack=true });
  final bool showBack;
  final Map<String, dynamic>? arguments = Get.arguments;
  String? familyUserId = "";
  int queryId = 0;
  @override
  Widget build(BuildContext context) {
    QueryProvider provider = Get.put(QueryProvider());
    if(arguments != null ){
      if(arguments!['family_user_id'] != null){
        familyUserId = arguments!['family_user_id'];
      }
     if(arguments!['query_id'] != null){
       if(arguments!['query_id'].runtimeType == String){
         queryId = int.parse(arguments!['query_id']);
       }else{
         queryId = arguments!['query_id'];
       }
     }
    }

    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Confirmed details".tr,
        showDivider: false,
        showBack: showBack,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          children: [

            DefaultTabController(
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(
                          child: Text(
                            "Status".tr,
                            style: AppStyle.txtUrbanistRomanBold20Cyan60001,
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Quick Information".tr,
                            style: AppStyle.txtUrbanistRomanBold20Cyan60001,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder<ConfirmedQuery?>(
                          future: provider.getConfirmedQueryDetail(
                              queryId, familyId: familyUserId),
                          builder:
                              (context, AsyncSnapshot<ConfirmedQuery?> data) {
                            if (data.hasData) {
                              return TabBarView(children: [
                                Builder(
                                  builder: (ctx) {
                                    if (data.data!.statuses == null ||
                                        data.data!.statuses!.isEmpty) {
                                      return Center(
                                          child: Text("No Status Updated yet".tr));
                                    }
                                    return ListView.builder(
                                      itemCount: data.data!.statuses!.length,
                                      itemBuilder: (context, index) {
                                        return TimelineItem(
                                          event: data
                                              .data!.statuses![index].status!,
                                          timestamp: data.data!.statuses![index]
                                              .timestamp!,
                                          isFirst: index == 0,
                                          isLast: index ==
                                              data.data!.statuses!.length - 1,
                                          file:
                                              data.data!.statuses![index].file,
                                        );
                                      },
                                    );
                                  },
                                ),
                                CoOrdinatorDetails(data.data),
                              ]);
                            } else if (data.connectionState ==
                                    ConnectionState.done &&
                                !data.hasData) {
                              return Center(
                                child: Text("No Status Updated yet".tr)
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(NoCoordinator(
                  phoneNumber: Get.find<UserController>().user?.phoneNo,
                ));
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color?>(MYcolors.blueGray400)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                width: double.infinity,
                child: Text(
                  "Contact Support".tr,
                  style: TextStyle(
                    color: MYcolors.whitecolor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FamilyMemberStatus extends StatelessWidget {
  const FamilyMemberStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Family member status"),);
  }
}

class CoOrdinatorDetails extends StatelessWidget {
  final ConfirmedQuery? data;
  const CoOrdinatorDetails(this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex:1,
            child: ListView(
          children: [
            Text(
              "Hotel Details".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "${data?.accommodation?.name} \n${data?.accommodation?.address}",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
            CustomSpacer.m(),
            Text(
              "Cab Details".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              data?.cab?.name == null
                  ? "Not Assigned".tr
                  : "${data?.cab?.name}\n${data?.cab?.type} \n${data?.cab?.number}",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
            CustomSpacer.m(),
            Text(
              "Coordinator details".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.15,
              width: MediaQuery.of(context).size.width *
                  0.4,
              child: Image.network(
                  data!.coordinator!.image!),
            ),
            Text(
              "${"Name".tr} : ${data?.coordinator?.name}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "${'Phone Number'.tr} : ${data?.coordinator?.phone}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        )),
        ElevatedButton(
          onPressed: () {
            Get.to(NoCoordinator(
              phoneNumber:
                  data?.coordinator?.phone,
            ));
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<
                  RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(100),
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color?>(
                      MYcolors.bluecolor)),
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: 16.0),
            width: double.infinity,
            child: Text(
              "Connect to Coordinator".tr,
              style: TextStyle(
                color: MYcolors.whitecolor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        CustomSpacer.xs(),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String event;
  final bool isFirst;
  final bool isLast;
  final int timestamp;
  final List<String>? file;

  const TimelineItem(
      {super.key, required this.event,
      required this.isFirst,
      required this.isLast,
      required this.timestamp,
      this.file});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(

            children: [
              Text(
                event,
                style: AppStyle.txtUrbanistRomanBold20,
              ),
              Text(
                  Utils.formatDateWithTime(DateTime.fromMillisecondsSinceEpoch(
                      timestamp * 1000,
                      isUtc: false)),
                  style: AppStyle.txtSourceSansProSemiBold18, textAlign: TextAlign.left,),
              if(file != null && file!.isNotEmpty)
                ElevatedButton(onPressed: (){
                  Get.defaultDialog(
                    title: "Uploaded Images".tr,
                    content: showImages(file)
                  );
                }, child: Text("Show Images".tr))
            ],
          ),
        ),
      ],
    );
  }
}

Widget showImages(List<String>? file){
  return Builder(builder: (context) {
    if (file != null && (file.isNotEmpty)) {
      return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: file.length, itemBuilder: (ctx, idx) {
        return Image.network(
          file[idx],
          height: 300,
          width: 200,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.low,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              height: 200,
              width: 200,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error);
          },
        );
      });
      return SizedBox();
    } else {
      return SizedBox();
    }
  });
}

