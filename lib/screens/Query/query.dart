import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/controller/controllers/query_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Query/generate_new_query.dart';

import '../../constants/colors.dart';

class Query_page extends StatefulWidget {
  const Query_page({super.key});

  @override
  State<Query_page> createState() => _Query_pageState();
}

class _Query_pageState extends State<Query_page> {
  late QueryController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = Get.put(QueryController());
    _controller.getQueryPageData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(showBack: false, pageName: "Active query"),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            GetBuilder<QueryController>(builder: (_) {
              if (_controller.isLoaded.isTrue) {
                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _controller.queryScreen.activeQuery!.length,
                      itemBuilder: (_, index) {
                        return _activeQueryCard(context,
                            id: _controller.queryScreen.activeQuery![index].id!,
                            date:
                                "Date: ${_controller.queryScreen.activeQuery![index].createdAt}",
                            response: _controller.queryScreen
                                .activeQuery![index].doctorResponse!,
                            stepName: _controller
                                .queryScreen.activeQuery![index].stepName!,
                            stepNote: _controller
                                .queryScreen.activeQuery![index].stepNote!,
                            controller: _controller);
                      }),
                );
              }
              if(_controller.emptyScreen){
                return const Center(
                  child: Text("No queries opened yet. \nStart with clicking on Generate Query button to begin creating a new query."),
                );
              }
              return const SizedBox(
                height: 350,
                width: 350,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }),
            CustomSpacer.s(),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.startQuery);
                // Get.to(Generate_New_Query());
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ))),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                width: double.infinity,
                child: const Text(
                  "Generate new query",
                  style: TextStyle(
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
      required String date,
      required String response,
      required String stepName,
      required String stepNote,
      required QueryController controller}) {
    List<Color> color = response.isNotEmpty
        ? [MYcolors.greenlightcolor, MYcolors.bluecolor]
        : [Colors.deepOrangeAccent, Colors.redAccent];
    return GestureDetector(
      onTap: () {
        if (response.isNotEmpty) {
          controller.navigateToDoctorsPage(id, response);
        } else {
          Get.showSnackbar(const GetSnackBar(
            message:
                "Please wait untill we get the doctor's response for your query",
          ));
        }
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
                offset: Offset(0, 1),
              )
            ]),
        width: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(
                  fontFamily: "Brandon",
                  fontSize: 15,
                  color: MYcolors.whitecolor),
            ),
            CustomSpacer.xs(),
            Visibility(
              visible: response.isNotEmpty,
              replacement: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stepName,
                    style: const TextStyle(
                        fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.greycolor),
                  ),
                  SizedBox(
                    height: 150 - (16 * 2) - CustomSpacer.XS - 16,
                    child: Text(
                      stepNote,
                      maxLines: 4,
                      style: const TextStyle(
                          fontFamily: "Brandon",
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
                    style: TextStyle(
                        fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.greycolor),
                  ),
                  const Text(
                    "Doctor's Response :-",
                    style: TextStyle(
                        fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.whitecolor),
                  ),
                  SizedBox(
                    height: 150 - (16 * 2) - CustomSpacer.XS - 16,
                    child: Text(
                      response,
                      maxLines: 4,
                      style: const TextStyle(
                          fontFamily: "Brandon",
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