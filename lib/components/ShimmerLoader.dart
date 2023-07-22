import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key, this.showNav = true});
  final bool showNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(pageName: '',showBack: showNav,),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            SizedBox(
              width: double.maxFinite,
              height: getHorizontalSize(200),
              child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Container(
                    color: Colors.black26,
                    width: double.maxFinite,
                    height: 100.0,
                    child: Text(''),
                  )),
            ),
            ...List<Widget>.generate(5, (int index) {
              return Container(
                margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 10,
                child: Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: Container(
                      color: Colors.black26,
                      width: double.maxFinite,
                      height: 100.0,
                    )),
              );
            })
                ],
              ),
          ),
        ));
  }
}