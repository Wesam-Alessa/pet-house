import 'package:pet_house/data/models/splash_model.dart';
import 'package:pet_house/presentations/widgets/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constant/text_style.dart';
import '../../core/utills/dimensions.dart';

class SplashWidget extends StatelessWidget {
  final SplashModel splash;
  const SplashWidget({super.key, required this.splash});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.screenHeight / 2,
      width: Dimensions.screenWidth,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: Dimensions.screenHeight / 3,
              width: Dimensions.screenWidth,
              child: CachedImage(imageUrl: splash.imageUrl,)
              ),
          SizedBox(
            height: Dimensions.height30,
          ),
          Text(
            splash.title,
            style: TextStyles.titleTextStyle.copyWith(color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
