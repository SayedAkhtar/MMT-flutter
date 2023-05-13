import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mmt_/screens/Home_screens/home_page.dart';
import 'package:mmt_/screens/Hospitals/hospital_preview.dart';
import 'package:mmt_/screens/Query/query.dart';
import 'package:mmt_/constants/colors.dart';
import 'package:mmt_/screens/connects/connect_homepage.dart';
import 'package:mmt_/screens/update_screen/query_confirmed.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/api_constants.dart';

class Home_screen extends StatefulWidget {
  const Home_screen({super.key});

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (index == 2) {
      openWhatsapp(
          text: "Hello, I have query regarding MyMedTrip.",
          number: WHATSAPP_NUMBER);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void openWhatsapp({required String text, required String number}) async {
    var whatsapp = number; //+92xx enter like this
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$text";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(
          whatsappURLIos,
        ));
      } else {
        Get.snackbar("Whatsapp not installed",
            "Please install whatsapp on your device and try again.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        Get.snackbar("Whatsapp not installed",
            "Please install whatsapp on your device and try again.",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getHomeViewWidget(),
      bottomNavigationBar: BottomNavigationBar(
    showSelectedLabels: true,
    showUnselectedLabels: true,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: SvgPicture.asset('assets/icons/bottom-nav-home.svg'),
        activeIcon: SvgPicture.asset(
          'assets/icons/bottom-nav-home.svg',
          colorFilter:
              ColorFilter.mode(context.theme.primaryColor, BlendMode.srcIn),
        ),
        label: 'Home'.tr,
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset('assets/icons/bottom-nav-query.svg'),
        activeIcon: SvgPicture.asset(
          'assets/icons/bottom-nav-query.svg',
          colorFilter:
              ColorFilter.mode(context.theme.primaryColor, BlendMode.srcIn),
        ),
        label: 'Query'.tr,
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset('assets/icons/bottom-nav-whatsapp.svg'),
        activeIcon: SvgPicture.asset(
          'assets/icons/bottom-nav-whatsapp.svg',
          colorFilter:
              ColorFilter.mode(context.theme.primaryColor, BlendMode.srcIn),
        ),
        label: 'Whatsapp'.tr,
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset('assets/icons/bottom-nav-updates.svg'),
        activeIcon: SvgPicture.asset(
          'assets/icons/bottom-nav-updates.svg',
          colorFilter:
              ColorFilter.mode(context.theme.primaryColor, BlendMode.srcIn),
        ),
        label: 'Updates'.tr,
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset('assets/icons/bottom-nav-connect.svg'),
        activeIcon: SvgPicture.asset(
          'assets/icons/bottom-nav-connect.svg',
          colorFilter:
              ColorFilter.mode(context.theme.primaryColor, BlendMode.srcIn),
        ),
        label: 'Connect'.tr,
        // backgroundColor: MYcolors.blackcolor
      ),
    ],
    currentIndex: _selectedIndex,
    unselectedItemColor: MYcolors.blacklightcolors,
    selectedItemColor: MYcolors.bluecolor,
    onTap: _onItemTapped,
      ),
    );
  }

  Widget getHomeViewWidget(){
    switch(_selectedIndex){
      case 0:
        return const HomePage();
      case 1:
        return const Query_page();
      case 3:
        return QueryConfirmed();
      case 4:
        return const Connect_Home_page();
      default:
        return const HomePage();
    }
  }
}
