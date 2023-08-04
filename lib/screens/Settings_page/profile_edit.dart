import 'package:MyMedTrip/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:pattern_formatter/date_formatter.dart';
import 'package:select_dialog/select_dialog.dart';

class Profile_edit_page extends StatefulWidget {
  const Profile_edit_page({super.key});

  @override
  State<Profile_edit_page> createState() => _Profile_edit_pageState();
}

class _Profile_edit_pageState extends State<Profile_edit_page> {
  final _personalInformationKey = GlobalKey<FormState>();
  late String name, date, gender, countryPreference, phone;
  final TextEditingController patientCountryController =
      TextEditingController();
  late int specializationId;
  List<String> countryName = [];
  List<int> countryId = [];
  @override
  void initState() {
    buildCountryOption();
    super.initState();
  }

  buildCountryOption() async {
    var t = await GetConnect().get('$api_uri/countries');
    List<String> temp = [];
    List<int> tempOne = [];
    Logger().d(t.statusText);
    if (t.statusCode == 200) {
      t.body['DATA'].forEach((element) {
        temp.add(element['name']);
        tempOne.add(element['id']);
      });
    }
    setState(() {
      countryName = temp;
      countryId = tempOne;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
    pageName: 'Personal Information',
    showDivider: false,
      ),
      body: GetBuilder<UserController>(
          builder: (controller) {
    // countryPreference = controller.user?.treatmentCountry ?? '';
    print(controller.user!.country);
    return Form(
      key: _personalInformationKey,
      child: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: ListView(
          children: [
            TextFormField(
              initialValue: controller.user?.name,
              onSaved: (value) {
                controller.user?.name = value!;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Name".tr,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TextFormField(
              initialValue: Utils.formatDate(controller.user?.dob),
              inputFormatters: [DateInputFormatter()],

              keyboardType: TextInputType.datetime,
              onSaved: (value) {
                controller.user?.dob = Utils.formatStringToDateTime(value!);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 15, bottom: 11, top: 11, right: 15),
                hintText: "dd/mm/yyyy".tr,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            DropdownButtonFormField(
              value: controller.user?.gender,
              items: const [
                DropdownMenuItem(
                  value: 'male',
                  enabled: true,
                  child: Text('Male'),
                ),
                DropdownMenuItem(
                  value: 'female',
                  child: Text('Female'),
                ),
                DropdownMenuItem(
                  value: 'other',
                  child: Text('Other'),
                ),
              ],
              onChanged: (String? value) {
                controller.user?.gender = value!;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Date of birth".tr,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TextFormField(
              initialValue: controller.user?.phoneNo,
              onSaved: (value) {
                controller.user?.phoneNo = value!;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Contact no.".tr,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            GestureDetector(
              onTap: (){
                SelectDialog.showModal<String>(
                    context,
                    label: "Select Country",
                    selectedValue: controller.user!.treatmentCountry,
                    items: List.generate(countryName.length, (index) => countryName[index]),
                    onChange: (String selected) {
                      controller.user!.treatmentCountry = countryPreference;
                    },
                  );
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 15, bottom: 11, top: 11, right: 15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(controller.user!.treatmentCountry!=null? controller.user!.treatmentCountry! : "Select Country", style: const TextStyle(fontSize: 16.0),),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            GestureDetector(
              onTap: () {
                _personalInformationKey.currentState?.save();
                controller.updateUser(controller.user?.id);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: MYcolors.bluecolor),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Done".tr,
                  style: const TextStyle(
                    color: MYcolors.whitecolor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
      }),
      // backgroundColor: MYcolors.blackcolor,
    );
  }
}
