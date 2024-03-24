
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/helper/Debouncer.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomCardWithImage.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/providers/base_provider.dart';

import '../../controller/controllers/local_storage_controller.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchFieldController;
  late FocusNode searchNode;
  late BaseProvider provider;
  List searchResults = [];
  bool isSearching = false;
  final Debouncer debouncer = Debouncer(milliseconds: 800);
  final _storage = Get.find<LocalStorageController>();

  @override
  void initState() {
    super.initState();
    searchFieldController = TextEditingController();
    provider = Get.put(BaseProvider());
    provider.httpClient.addRequestModifier((dynamic request) {
      request.headers['language'] = _storage.get("language") ?? "";
      return request;
    });

    searchNode = FocusNode();
    searchNode.requestFocus();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    searchFieldController.dispose();
    super.dispose();
  }

  void searchDoctorsAndHospitals() async {
      setState(() {
        isSearching = true;
      });
    if (searchFieldController.text.length > 2) {
      Response? res =
          await provider.get('/search?term=${searchFieldController.text}');
      if (res.isOk) {
        var jsonString = res.body['DATA'];
        setState(() {
          searchResults = jsonString;
          isSearching = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: CustomSpacer.S),
                  padding:
                      const EdgeInsets.symmetric(horizontal: CustomSpacer.S),
                  decoration: BoxDecoration(
                      color: MYcolors.whitecolor,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: const Offset(0, 1),
                        )
                      ]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_rounded),
                      CustomSpacer.s(),
                      Expanded(
                        child: TextField(
                          controller: searchFieldController,
                          onChanged: (term) {
                            debouncer.run(() {
                              searchDoctorsAndHospitals();
                            });
                          },
                          decoration: InputDecoration(
                              hintText: 'Search for doctors and hospitals'.tr,
                              border: InputBorder.none),
                          focusNode: searchNode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: Builder(
          builder: (_) {
            if (searchFieldController.text.length < 3) {
              return SizedBox(child: Center(child: Text("Please enter 3 or more character to begin search".tr)));
            }
            if (searchResults.isNotEmpty) {
              return searchSection(searchResults);
            }
            if (isSearching) {
              return const SizedBox(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Center(child: Text("No data to display".tr));
          },
        ),
      ),
    );
  }

  Widget searchSection(List data) {
    return GridView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.8)
            ),
        itemCount: data.length,
        itemBuilder: (_, i) {
          return CustomCardWithImage(
            imageAlign: Alignment.topCenter,
            fit: BoxFit.fitWidth,
            onTap: () {
              if (data[i]['type'] == 'doctor') {
                Get.toNamed(Routes.doctorPreviewNew,
                    arguments: {'id': data[i]['id']});
              }
              if (data[i]['type'] == 'hospital') {
                Get.toNamed(Routes.hospitalPreview,
                    arguments: {'id': data[i]['id']});
              }
            },
            imageUri: data[i]['logo'],
            title: data[i]['name'],
            bodyText: data[i]['description'],
            // bodyText: hospitals[i]!.address,
          );
        });
  }
}
