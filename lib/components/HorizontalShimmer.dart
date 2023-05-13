import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalShimmer extends StatelessWidget {
  const HorizontalShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: 200.0,
                  constraints: const BoxConstraints(minHeight: 200.0),
                  color: Colors.white,
                ),
              );
            }
        )
    );
  }
}
