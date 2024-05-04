import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/presentations/widgets/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarsouelSliderWidget extends StatelessWidget {
  final List pictures;
  const CarsouelSliderWidget({Key? key, required this.pictures})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (() => Navigator.pop(context)),
        ),
      ),
      body: Center(
        child: CarouselSlider.builder(
          itemCount: pictures.length,
          itemBuilder: (BuildContext context, int index, int pageViewIndex) {
            return SizedBox(
                height: Dimensions.screenHeight / 2,
                width: double.infinity,
                child: CachedImage(
                  imageUrl: pictures[index].webViewLink,
                ));
          },
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 0.99,
            aspectRatio: 1.0,
            initialPage: 2,
          ),
        ),
      ),
    );
  }
}
