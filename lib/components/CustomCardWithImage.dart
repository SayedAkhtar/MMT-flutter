import 'package:MyMedTrip/components/CustomImageView.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';

class CustomCardWithImage extends StatelessWidget {
  const CustomCardWithImage(
      {super.key,
      this.onTap,
      required this.imageUri,
      this.body,
      required this.title,
      this.bodyText,
      this.align,
      this.imageAlign,
      this.width,
      this.icon,
      this.imagePadding,
      this.titleStyle,
      this.bodyStyle,
      this.bgColor,
      this.imageHeight,
      this.fit,
      this.textLines});
  final onTap;
  final String? imageUri;
  final double? imageHeight;
  final String title;
  final String? bodyText;
  final double? width;
  final IconData? icon;
  final Widget? body;
  final TextAlign? align;
  final Alignment? imageAlign;
  final EdgeInsetsGeometry? imagePadding;
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;
  final Color? bgColor;
  final int? textLines;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CustomImageView(
                  url: imageUri,
                  fit: fit??BoxFit.cover,
                  imageAlign: imageAlign ?? Alignment.center,
                  height: getVerticalSize(imageHeight ?? 100),
                  width: double.maxFinite,
                  margin: imagePadding ?? const EdgeInsets.all(0)
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8.0, 6, 8, 2),
                  child: Text(
                    title,
                    style: titleStyle ?? AppStyle.txtUrbanistRomanBold18,
                    textAlign: align ?? TextAlign.start,
                    maxLines: textLines ?? 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          bodyText != null ?Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 6, 8, 2),
                  child:
                       buildCardBody(icon) ,
                ),
              ): const SizedBox(),
              body ?? const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  buildCardBody(IconData? icon) {
    TextStyle bstyle =
        bodyStyle ?? AppStyle.txtUrbanistSemiBold14.copyWith(fontSize: 12);
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            size: 16,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              bodyText!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: bstyle,
              textAlign: align ?? TextAlign.start,
            ),
          ),
        ],
      );
    } else {
      return Text(
        bodyText!,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: bstyle,
        textAlign: align ?? TextAlign.start,
      );
    }
  }
}
