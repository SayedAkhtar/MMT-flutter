import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:get/get.dart';

class QuerySubmissionSuccess extends StatefulWidget {
  const QuerySubmissionSuccess({Key? key}) : super(key: key);

  @override
  State<QuerySubmissionSuccess> createState() => _QuerySubmissionSuccessState();
}

class _QuerySubmissionSuccessState extends State<QuerySubmissionSuccess>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            Expanded(
              child: Lottie.asset(
                'assets/lottie/form_submitted.json',
                fit: BoxFit.fill,
                controller: _animationController,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                animate: true,
                onLoaded: (composition) {
                  _animationController
                    ..duration = composition.duration
                    ..repeat();
                },
              ),
            ),
            CustomSpacer.l(),
            RichText(
              text: TextSpan(
                text: "Thank you for your query. ",
                children: [
                  const TextSpan(
                    text: "Your query has been received successfully and is currently under review. "
                  ),
                  const TextSpan(
                      text: "Please access the "
                  ),
                  TextSpan(
                      text: '"Query"',
                    style: AppStyle.txtRobotoRegular20.copyWith(fontWeight: FontWeight.w600)
                  ),
                  const TextSpan(
                      text: " tab to view the response once the review process is complete."
                  ),
                ],
                style: AppStyle.txtRobotoRegular20,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.home);
                // Get.to(Generate_New_Query());
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  )),
                  backgroundColor:
                      MaterialStateProperty.all<Color?>(MYcolors.bluecolor)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                width: double.infinity,
                child: const Text(
                  "Return back to Home",
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
}
