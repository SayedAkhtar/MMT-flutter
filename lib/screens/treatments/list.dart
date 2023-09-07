import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/CustomCardWithImage.dart';
import 'package:MyMedTrip/components/MarginBox.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Debouncer.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/models/treatment.dart';
import 'package:MyMedTrip/providers/hospital_provider.dart';
import 'package:MyMedTrip/screens/Home_screens/SearchScreen.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class TreatmentsList extends StatefulWidget {
  const TreatmentsList({super.key});

  @override
  State<TreatmentsList> createState() => _TreatmentsListState();
}

class _TreatmentsListState extends State<TreatmentsList> {
  late HospitalProvider provider;
  final scrollController = ScrollController();
  final treatmentSearchController = TextEditingController();
  int currentPage = 1;
  bool reachedEnd = false;
  bool searching = false;
  final debouncer = Debouncer(milliseconds: 1000);
  late Future<List<Treatment?>> future;
  late List<Treatment?>? allData = [];
  @override
  void initState() {
    provider = Get.put(HospitalProvider());
    fetchData();
    scrollController.addListener(onScroll);
    super.initState();
  }

  void onScroll() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // Reached the bottom of the scroll view, load more data
      if (reachedEnd) {
        return;
      }
      List<Treatment?>? temp = await provider.getAllTreatments(
          query: treatmentSearchController.text, page: currentPage);
      setState(() {
        if (temp.length == 25) {
          currentPage = currentPage + 1;
          reachedEnd = true;
        }
        allData!.addAll(temp);
      });
    }
  }

  void fetchData() async {
    setState(() {
      searching = true;
    });
    var temp = await provider.getAllTreatments(page: currentPage);
    setState(() {
      allData = temp;
      searching = false;
    });
  }

  void searchData(text) async {
    var temp = await provider.getAllTreatments(query: text, page: 1);
    setState(() {
      allData = temp;
      searching = false;
    });
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
              child: TextFormField(
                controller: treatmentSearchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for Treatments'.tr,
                  hintStyle: AppStyle.txtUrbanistRegular16,
                  suffixIcon: const Icon(Icons.search_rounded),
                  contentPadding: const EdgeInsets.all(CustomSpacer.S),
                  isDense: false,
                ),
                onChanged: (String text) {
                  setState(() {
                    searching = true;
                  });
                  debouncer.run(() {
                    searchData(text);
                  });
                },
              ),
            ),
            Expanded(
              child: Builder(builder: (_) {
                if(allData!.isEmpty){
                  return const Center(
                    child: Text("No Treatment to show"),
                  );
                }
                if(searching){
                  return const Center(
                        child: CircularProgressIndicator(),
                      );
                }
                return GridView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    controller: scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: allData!.length,
                    itemBuilder: (_, i) {
                      return CustomCardWithImage(
                        width: getHorizontalSize(160),
                        onTap: () {
                          Get.defaultDialog(
                            title: allData![i]!.name!,
                            content: Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.8
                              ),
                              child: SingleChildScrollView(
                                child: Table(
                                  // border: TableBorder.all(color: Colors.black12,width: 1),
                                  children : [
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Maximum Price (USD):"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("\$ ${allData![i]!.maxPrice}"),
                                        )
                                      ]
                                    ),
                                    TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Minimum Price (USD):"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("\$ ${allData![i]!.minPrice}"),
                                          )
                                        ]
                                    ),
                                    TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Days Required :"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(allData![i]!.daysRequired.toString()),
                                          )
                                        ]
                                    ),
                                    TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Recovery Time:"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(allData![i]!.recoveryTime.toString()),
                                          )
                                        ]
                                    ),
                                    TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Success Rate:"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(allData![i]!.successRate.toString()),
                                          )
                                        ]
                                    ),
                                    TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Covered:"),
                                          ),
                                          // Html(data: data)
                                          Text( Utils.stripHtmlIfNeeded(allData![i]!.covered!))
                                        ]
                                    ),
                                    TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Not Covered:"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(Utils.stripHtmlIfNeeded(allData![i]!.notCovered ?? "")),
                                          )
                                        ]
                                    ),

                                  ]
                                ),
                              ),
                            )
                          );
                        },
                        imageUri: allData![i]!.logo,
                        title: allData![i]!.name!,
                        titleStyle: AppStyle.txtUrbanistRomanBold10
                            .copyWith(fontSize: 11),
                        textLines: 2,
                        bgColor: MYcolors.bluecolor,
                        imageHeight: 40,
                        // bodyText: hospitals[i]!.address,
                      );
                    });
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return const Center(
                //     child: CircularProgressIndicator(),
                //   );
                // } else if (snapshot.connectionState ==
                //     ConnectionState.done) {
                //   if (snapshot.hasData &&
                //       snapshot.data != null &&
                //       snapshot.data!.isNotEmpty ) {
                //     List<Treatment?>? data = snapshot.data;
                //
                //   }
                // }
                // return const Center(
                //   child: Text("No Treatment to show"),
                // );
              }),
            )
          ],
        ),
      ),
    );
  }
}
