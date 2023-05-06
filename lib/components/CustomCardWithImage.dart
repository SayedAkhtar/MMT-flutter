import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCardWithImage extends StatelessWidget {
  const CustomCardWithImage(
      {Key? key,
      this.onTap,
      required this.imageUri,
      this.body,
      required this.title,
      this.bodyText,
      this.align,
      this.icon})
      : super(key: key);
  final onTap;
  final String imageUri, title;
  final String? bodyText;
  final IconData? icon;
  final Widget? body;
  final TextAlign? align;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          constraints: const BoxConstraints.expand(height: 310, width: 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Image.network(imageUri, fit: BoxFit.fill, width: 180,
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    );
                  }
                },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                  return const Center(child: Text('No image to display'));
                }),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 6),
                  constraints:
                      const BoxConstraints.expand( width: 180),
                  child: Column(
                    crossAxisAlignment: align == TextAlign.center
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16.0),
                        textAlign: align ?? TextAlign.start,
                      ),
                      bodyText != null ? buildCardBody(icon) : SizedBox(),
                      body ?? const SizedBox()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildCardBody(IconData? icon) {
    if (icon != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Row(
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
                style: const TextStyle(fontSize: 12),
                textAlign: align ?? TextAlign.start,
              ),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            bodyText!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
            textAlign: align ?? TextAlign.start,
          ),
        ),
      );
    }
  }
}
