import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';

class ChangeLanguagePage extends StatelessWidget {
  const ChangeLanguagePage({Key? key}) : super(key: key);

  void selectLanguage(String lang, LocalStorageController str){
    Locale locale = Locale(lang);
    Get.updateLocale(locale);
    str.set(key: 'language', value: lang);
  }
  @override
  Widget build(BuildContext context) {
    final LocalStorageController _storage = Get.find<LocalStorageController>();
    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(pageName: "Change app language", showDivider: true,),
      body: ListView(
        children: [
          ListTile(
            leading: SvgPicture.asset("assets/icons/us.svg", width: 40,),
            title: Text("English".tr),
            trailing: _storage.get('language') == "en" ? Icon(Icons.check_box, color: context.theme.primaryColor,) : Icon(Icons.check_box_outline_blank),
            onTap: (){
              selectLanguage("en", _storage);
            },
          ),
          ListTile(
            leading: SvgPicture.asset("assets/icons/sa.svg", width: 40,),
            title: Text("Arabic".tr),
            trailing: _storage.get('language') == "ar" ? Icon(Icons.check_box, color: context.theme.primaryColor,) : Icon(Icons.check_box_outline_blank),
            onTap: (){
              selectLanguage("ar", _storage);
            },
          ),
          ListTile(
            leading: SvgPicture.asset("assets/icons/ru.svg", width: 40,),
            title: Text("Russian".tr),
            trailing: _storage.get('language') == "ru" ? Icon(Icons.check_box, color: context.theme.primaryColor,) : Icon(Icons.check_box_outline_blank),
            onTap: (){
              selectLanguage("ru", _storage);
            },
          ),
          ListTile(
            leading: SvgPicture.asset("assets/icons/in.svg", width: 40,),
            title: Text("Hindi".tr),
            trailing: _storage.get('language') == "bn" ? Icon(Icons.check_box, color: context.theme.primaryColor,) : Icon(Icons.check_box_outline_blank),
            onTap: (){
              selectLanguage("bn", _storage);
            },
          ),

        ],
      ),
    ),);
  }
}
