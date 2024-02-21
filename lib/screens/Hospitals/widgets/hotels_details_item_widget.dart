import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:flutter/material.dart';

import '../../../components/CustomImageView.dart';
import '../../../constants/size_utils.dart';
import '../../../theme/app_decoration.dart';

// ignore: must_be_immutable
class HotelDetailsItemWidget extends StatelessWidget {
  const HotelDetailsItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Container(
        padding: getPadding(
          left: CustomSpacer.XS,
          top: CustomSpacer.XS,
          right: CustomSpacer.XS,
          bottom: CustomSpacer.XS,
        ),
        decoration: AppDecoration.outlineBlack9000c.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: getPadding(
                top: 1,
              ),
              child: Row(
                children: [
                  CustomImageView(
                    imagePath: "Images/P1.jpg",
                    height: getSize(
                      MediaQuery.of(context).size.width * 0.35,
                    ),
                    width: getSize(
                      MediaQuery.of(context).size.width * 0.35,
                    ),
                    radius: BorderRadius.circular(
                      getHorizontalSize(
                        16,
                      ),
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
