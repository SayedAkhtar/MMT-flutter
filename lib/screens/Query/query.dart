import 'package:MyMedTrip/constants/query_type.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/providers/query_provider.dart';
import 'package:MyMedTrip/screens/Query/query_form.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';

import '../../constants/colors.dart';
import '../../models/query_screen_model.dart';

class Query_page extends StatefulWidget {
  const Query_page({super.key});

  @override
  State<Query_page> createState() => _Query_pageState();
}

class _Query_pageState extends State<Query_page> {
  late QueryController _controller;
  late List<ActiveQuery> queries;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = Get.put(QueryController());
    // _controller.getQueryPageData();
    fetchQueries();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void fetchQueries() async{
    QueryScreen? data = await Get.put(QueryProvider()).getQueryScreenData();
    List<ActiveQuery> tempQueries = [];
    if(data  != null && data.activeQuery != null && data.activeQuery!.isNotEmpty){
      tempQueries = data.activeQuery!;
    }
    setState(() {
      queries = tempQueries;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(showBack: false, pageName: "Active query".tr),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Builder(builder: (_) {
              if (!loading) {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async{
                      setState(() {
                        loading = true;
                      });
                      fetchQueries();
                    },
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: queries.length,
                        itemBuilder: (_, index) {
                          return _activeQueryCard(context,
                              id: queries[index].id!,
                              queryHash: queries[index].queryHash,
                              date:
                                  "Date: ${queries[index].createdAt}",
                              response: queries[index].doctorResponse!,
                              selectedIndex: index,
                              stepName: queries[index].stepName!,
                              stepNote: queries[index].stepNote!,
                              query: queries[index]
                              );
                        }),
                  ),
                );
              }
              if (!loading && queries.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(
                      "No queries opened yet. \nStart with clicking on Generate Query button to begin creating a new query.".tr,
                      style: AppStyle.txtSourceSansProSemiBold18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return const Expanded(
                child: SizedBox(
                  height: 350,
                  width: 350,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }),
            CustomSpacer.s(),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.startQuery);
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color?>(
                  MYcolors.bluecolor
                )
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                width: double.infinity,
                child: Text(
                  "Generate new query".tr,
                  style: const TextStyle(
                    color: MYcolors.whitecolor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _activeQueryCard(BuildContext context,
      {required int id,
        required String? queryHash,
      required String date,
      required String response,
      required String stepName,
      required int selectedIndex,
      required String stepNote,
      required ActiveQuery query}) {
    ActiveQuery currQuery = query;
    // String stepTitle = controller.queryScreen.activeQuery![selectedIndex].type! == QueryType.medicalVisa ? "MMT Admin's ":"";
    List<Color> color =
        (currQuery.currentStep! > 1 || currQuery.type == QueryType.medicalVisa)
            ? [MYcolors.greenlightcolor, MYcolors.bluecolor]
            : [const Color(0xffe29578), const Color(0xffe26d5c)];
    return GestureDetector(
      onTap: () {
        if (currQuery.isConfirmed!) {
          Get.toNamed(Routes.confirmedQuery);
          return;
        }
        if(currQuery.type == QueryType.query && currQuery.currentStep == 1){
          Get.showSnackbar(GetSnackBar(
            message:
            "Please wait until we get the doctor's response for your query".tr,
            duration: const Duration(seconds: 2),
          ));
          return;
        }
        Get.to(() => QueryForm(
          currQuery.type!,
          queryId: currQuery.id!,
          queryStep: currQuery.currentStep!,
        ));
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: CustomSpacer.S),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: color,
            ),
            color: MYcolors.whitecolor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                // color: Color.fromARGB(255, 189, 181, 181),
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 2,
                spreadRadius: 0,
                offset: const Offset(0, 1),
              )
            ]),
        width: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(text: TextSpan(
              text: "#$queryHash",
              style: const TextStyle(
                  fontSize: 15,
                  color: MYcolors.whitecolor),
                children: [
                  const TextSpan(text: '\n'),
                  TextSpan(text: date)
                ]), ),
            CustomSpacer.xs(),
            Visibility(
              visible: response.isNotEmpty,
              replacement: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stepName,
                    style: const TextStyle(
                        fontSize: 15,
                        color: MYcolors.greycolor),
                  ),
                  SizedBox(
                    height: 150 - (16 * 2) - CustomSpacer.XS - 16,
                    child: Text(
                      stepNote,
                      maxLines: 4,
                      style: const TextStyle(
                          fontSize: 15,
                          color: MYcolors.whitecolor,
                          overflow: TextOverflow.ellipsis),
                    ),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stepName,
                    style: const TextStyle(
                        fontSize: 15,
                        color: MYcolors.greycolor),
                  ),
                  Text(
                    "Response :-".tr,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: MYcolors.whitecolor),
                  ),
                  SizedBox(
                    height: 150 - (16 * 2) - CustomSpacer.XS - 16,
                    child: Text(
                      Utils.stripHtmlIfNeeded(response),
                      maxLines: 4,
                      style: const TextStyle(
                          fontSize: 15,
                          color: MYcolors.whitecolor,
                          overflow: TextOverflow.ellipsis),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
