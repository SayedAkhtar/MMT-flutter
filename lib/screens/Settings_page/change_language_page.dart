import 'package:MyMedTrip/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';

class ChangeLanguagePage extends StatelessWidget {
  const ChangeLanguagePage({super.key});

  void selectLanguage(String lang, LocalStorageController str){
    Locale locale = Locale(lang);
    Get.updateLocale(locale);
    str.set(key: 'language', value: lang);
  }
  @override
  Widget build(BuildContext context) {
    final LocalStorageController storage = Get.find<LocalStorageController>();
    final provider = Get.put(UserProvider());
    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(pageName: "Change app language".tr, showDivider: true,),
      body: ListView(
        children: [
          ListTile(
            leading: SvgPicture.asset("assets/icons/us.svg", width: 40,),
            title: Text("English".tr),
            trailing: storage.get('language') == "en" ? Icon(Icons.check_box, color: context.theme.primaryColor,) : const Icon(Icons.check_box_outline_blank),
            onTap: () async{
              selectLanguage("en", storage);
              await provider.updateUserLanguage(language: "en");
            },
          ),
          ListTile(
            leading: SvgPicture.asset("assets/icons/sa.svg", width: 40,),
            title: Text("Arabic".tr),
            trailing: storage.get('language') == "ar" ? Icon(Icons.check_box, color: context.theme.primaryColor,) : const Icon(Icons.check_box_outline_blank),
            onTap: () async {
              selectLanguage("ar", storage);
              await provider.updateUserLanguage(language: "ar");
            },
          ),
          ListTile(
            leading: SvgPicture.asset("assets/icons/ru.svg", width: 40,),
            title: Text("Russian".tr),
            trailing: storage.get('language') == "ru" ? Icon(Icons.check_box, color: context.theme.primaryColor,) : const Icon(Icons.check_box_outline_blank),
            onTap: () async {
              selectLanguage("ru", storage);
              await provider.updateUserLanguage(language: "ru");
            },
          ),
          ListTile(
            leading: SvgPicture.asset("assets/icons/bn.svg", width: 40,),
            title: Text("Bengali".tr),
            trailing: storage.get('language') == "bn" ? Icon(Icons.check_box, color: context.theme.primaryColor,) : const Icon(Icons.check_box_outline_blank),
            onTap: () async {
              selectLanguage("bn", storage);
              await provider.updateUserLanguage(language: "bn");
            },
          ),

        ],
      ),
    ),);
  }
}
