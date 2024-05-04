import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/utills/dimensions.dart';

import '../../main.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int itemCount = 5;

  // @override
  // void initState() {
  //   Timer(Duration(seconds: 5),(){
  //     Navigator.pushNamed(context, SPLASH_SCREEN);
  //   });
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    // return RefreshIndicator(
    //   displacement: 250,
    //   backgroundColor: Colors.yellow,
    //   color: Colors.red,
    //   strokeWidth: 3,
    //   triggerMode: RefreshIndicatorTriggerMode.onEdge,
    //   onRefresh: () async {
    //     await Future.delayed(Duration(milliseconds: 1500));
    //     setState(() {
    //       itemCount = itemCount + 1;
    //     });
    //   },
    //   child: Scaffold(
    //     backgroundColor: Color(0xff246df8),
    //     appBar: AppBar(
    //       title: Text('Refresh Indicator'),
    //       backgroundColor: Color(0xff246df8),
    //     ),
    //     body: _buildCardDesign(),
    //   ),
    // );
     return Scaffold(
      backgroundColor: AppColors().primaryGreen,
      //const Color(0x6607051C),
      body:
      Stack(
        children: [
          // Positioned(
          //   left: 32,
          //   bottom: Dimensions.height15,
          //   child: SizedBox(
          //     width: Dimensions.screenWidth-Dimensions.width30,
          //     child: Row(
          //       mainAxisSize: MainAxisSize.max,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         // SizedBox(
          //         //   width: 41,
          //         //   height: 4,
          //         //   child: Stack(
          //         //     children: [
          //         //       Positioned(
          //         //         left: 0,
          //         //         top: 1,
          //         //         child: Opacity(
          //         //           opacity: 0.30,
          //         //           child: Container(
          //         //             width: 4,
          //         //             height: 4,
          //         //             decoration: const ShapeDecoration(
          //         //               color: Colors.white,
          //         //               shape: CircleBorder(),
          //         //             ),
          //         //           ),
          //         //         ),
          //         //       ),
          //         //       Positioned(
          //         //         left: 8,
          //         //         top: 1,
          //         //         child: Opacity(
          //         //           opacity: 0.30,
          //         //           child: Container(
          //         //             width: 4,
          //         //             height: 4,
          //         //             decoration: const ShapeDecoration(
          //         //               color: Colors.white,
          //         //               shape: CircleBorder(),
          //         //             ),
          //         //           ),
          //         //         ),
          //         //       ),
          //         //       Positioned(
          //         //         left: 16,
          //         //         top: 1,
          //         //         child: Opacity(
          //         //           opacity: 0.30,
          //         //           child: Container(
          //         //             width: 4,
          //         //             height: 4,
          //         //             decoration: const ShapeDecoration(
          //         //               color: Colors.white,
          //         //               shape: CircleBorder(),
          //         //             ),
          //         //           ),
          //         //         ),
          //         //       ),
          //         //       Positioned(
          //         //         left: 24,
          //         //         top: 1,
          //         //         child: Container(
          //         //           width: 17,
          //         //           height: 4,
          //         //           decoration: ShapeDecoration(
          //         //             color: const Color(0xFFFCFCFF),
          //         //             shape: RoundedRectangleBorder(
          //         //                 borderRadius: BorderRadius.circular(5)),
          //         //           ),
          //         //         ),
          //         //       ),
          //         //     ],
          //         //   ),
          //         // ),
          //         // SizedBox(
          //         //   width: 62,
          //         //   height: 62,
          //         //   child: Stack(
          //         //     children: [
          //         //       Positioned(
          //         //         right: 0,
          //         //         top: 0,
          //         //         child: Container(
          //         //           width: 62,
          //         //           height: 62,
          //         //           decoration: const ShapeDecoration(
          //         //             color: Color(0xFFFDFDFF),
          //         //             shape: CircleBorder(),
          //         //           ),
          //         //           child:const Center(child: Icon(Icons.arrow_forward,color: Colors.black,),),
          //         //         ),
          //         //       ),
          //         //     ],
          //         //   ),
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),
          Positioned(
            left: (Dimensions.screenWidth / 100) *12,
            top: Dimensions.screenHeight * .71,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                const SizedBox(
                  width: 311,
                  height: 32,
                  child: Text(
                    'Pet House',
                    //'Book appointment\nwith us!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      //fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      //height: 0,
                      //letterSpacing: -0.12,
                    ),
                  ),
                ),
               const SizedBox( height: 15 ),
                SizedBox(
                  width: 90,
                  height: 2.5,
                  child: LinearProgressIndicator(
                          backgroundColor: AppColors().primaryGreen ,
                    color:  Colors.white,
                  ),
                ),
                //SizedBox(height: 8),
                // SizedBox(
                //   width: 311,
                //   height: 74,
                //   child: Opacity(
                //     opacity: 0.55,
                //     child: Text(
                //       'What do you think? book our \n veterinarians now',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 14,
                //        // fontFamily: 'SF Pro Display',
                //         fontWeight: FontWeight.w400,
                //         //height: 0.10,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
              left: (Dimensions.screenWidth / 100) *15,
              top: Dimensions.screenHeight * .18,
              child: SizedBox(
                width: 287,
                height: 346,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 256,
                        height: 374.33,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/splash_images/splash 6.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Positioned(
          //   right: Dimensions.width15,
          //   top: 76,
          //   child: const Text(
          //     'Skip',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 14,
          //       //fontFamily: 'SF Pro Display',
          //       fontWeight: FontWeight.w500,
          //       height: 0.10,
          //     ),
          //   ),
          // ),

        ],
      ),
    );
  }
  Widget _buildCardDesign() {
    return Container(
      margin: EdgeInsets.all(5),
      child: ListView.builder(
          itemCount: itemCount,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return _buildCardView();
          }),
    );
  }
  Widget _buildCardView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.all(10),
        height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Container(
          //color: Colors.pinkAccent,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  "https://s1.1zoom.me/big0/716/Brunette_girl_Hair_Glance_Model_Colored_background_593058_1365x1024.jpg",
                  height: 60.0,
                  width: 60.0,
                  fit: BoxFit.cover,
                ),
              ),
              //SizedBox(width: 20,),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Neelu Modanwal",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Your opinion matters!",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Dev, do you have a moment?We'd love",
                        style: TextStyle(color: Colors.black, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    "4:15 AM",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    // height: 20,
                    // width: 20,
                    margin: EdgeInsets.only(left: 10),
                    //color: Colors.pinkAccent,
                    child: Icon(
                      Icons.star,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
