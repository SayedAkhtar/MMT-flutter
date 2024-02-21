import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../connects/voice_call.dart';

class Doctor_call_chat_page extends StatefulWidget {
  const Doctor_call_chat_page({super.key});

  @override
  State<Doctor_call_chat_page> createState() => _Doctor_call_chat_pageState();
}

class _Doctor_call_chat_pageState extends State<Doctor_call_chat_page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                        color: MYcolors.greycolor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  Text(
                    "Doctor".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.36,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(const CoordinatorCallPage());
                    },
                    child: Container(
                        padding: const EdgeInsets.all(3),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: MYcolors.greycolor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          "Images/VD.png",
                          // height: 20,
                          // width: 20,
                          // fit: BoxFit.fill,
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                        color: MYcolors.greycolor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.call,
                        size: 20,
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Divider(
              thickness: 1,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: MYcolors.greycolor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: const Text(
                          "Enjoy 4GB data valid till your current pack validity.Also get EXTRA 2GB on your next ",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                const Text("05:08 PM"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: MYcolors.greenlightcolor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: const Text(
                          "Enjoy 4GB data valid till your current pack validity.Also get EXTRA 2GB on your next ",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("05:08 PM"),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: MYcolors.greycolor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.29,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: const Text(
                          "Image ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                const Text("05:08 PM"),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: MYcolors.greycolor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: const Text(
                          "Enjoy 4GB data valid till your current pack validity.Also get EXTRA 2GB on your next ",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                const Text("05:08 PM"),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                SizedBox(
                  // alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Type your messages..........",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                const Icon(Icons.image_outlined),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
