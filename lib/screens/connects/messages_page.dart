import 'package:flutter/cupertino.dart';

import '../../constants/colors.dart';

class Messages_pages extends StatefulWidget {
  const Messages_pages({super.key});

  @override
  State<Messages_pages> createState() => _Messages_pagesState();
}

class _Messages_pagesState extends State<Messages_pages> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          // Get.to(Chat_page());
        },
        child: SizedBox(
          // color: MYcolors.bluecolor,
          height: MediaQuery.of(context).size.height * 0.07,
          // width: MediaQuery.of(context).size.width * 0.38,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: MYcolors.bluecolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Image.asset(
                  "Images/PR.png",
                  // fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Madhu",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.blacklightcolors),
                  ),
                  Text(
                    "Hi! can you please send me some....",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      // fontFamily: "Brandon",
                      fontSize: 12,
                      // color: MYcolors.greencolor
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.05,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("05:02 PM"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      GestureDetector(
        onTap: () {
          // Get.to(Chat_page());
        },
        child: SizedBox(
          // color: MYcolors.bluecolor,
          height: MediaQuery.of(context).size.height * 0.07,
          // width: MediaQuery.of(context).size.width * 0.38,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: MYcolors.bluecolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Image.asset(
                  "Images/PR.png",
                  // fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Madhu",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.blacklightcolors),
                  ),
                  Text(
                    "Hi! can you please send me some....",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      // fontFamily: "Brandon",
                      fontSize: 12,
                      // color: MYcolors.greencolor
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.05,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("05:02 PM"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      GestureDetector(
        onTap: () {
          // Get.to(Chat_page());
        },
        child: SizedBox(
          // color: MYcolors.bluecolor,
          height: MediaQuery.of(context).size.height * 0.07,
          // width: MediaQuery.of(context).size.width * 0.38,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: MYcolors.bluecolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Image.asset(
                  "Images/PR.png",
                  // fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Madhu",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.blacklightcolors),
                  ),
                  Text(
                    "Hi! can you please send me some....",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      // fontFamily: "Brandon",
                      fontSize: 12,
                      // color: MYcolors.greencolor
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.05,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("05:02 PM"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      GestureDetector(
        onTap: () {
          // Get.to(Chat_page());
        },
        child: SizedBox(
          // color: MYcolors.bluecolor,
          height: MediaQuery.of(context).size.height * 0.07,
          // width: MediaQuery.of(context).size.width * 0.38,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: MYcolors.bluecolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Image.asset(
                  "Images/PR.png",
                  // fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Madhu",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.blacklightcolors),
                  ),
                  Text(
                    "Hi! can you please send me some....",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      // fontFamily: "Brandon",
                      fontSize: 12,
                      // color: MYcolors.greencolor
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.05,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("05:02 PM"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      GestureDetector(
        onTap: () {
          // Get.to(Chat_page());
        },
        child: SizedBox(
          // color: MYcolors.bluecolor,
          height: MediaQuery.of(context).size.height * 0.07,
          // width: MediaQuery.of(context).size.width * 0.38,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: MYcolors.bluecolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Image.asset(
                  "Images/PR.png",
                  // fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Madhu",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.blacklightcolors),
                  ),
                  Text(
                    "Hi! can you please send me some....",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      // fontFamily: "Brandon",
                      fontSize: 12,
                      // color: MYcolors.greencolor
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.05,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("05:02 PM"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
