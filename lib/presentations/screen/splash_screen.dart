import 'dart:async';

import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/main.dart';
import 'package:pet_house/presentations/controllers/App/app_cubit.dart';
import 'package:pet_house/presentations/controllers/pet/pet_cubit.dart';
import 'package:pet_house/presentations/screen/auth/signin_screen.dart';
import 'package:pet_house/presentations/screen/home_screen.dart';
import 'package:pet_house/presentations/screen/loading_screen.dart';
import 'package:pet_house/presentations/widgets/splash_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constant/color_constant.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  int splashScreenIndex = 0;
  List<SplashWidget> splashes = [];
  void initList(List stateSplash) {
    for (var element in stateSplash) {
      splashes.add(SplashWidget(splash: element));
    }
  }
  bool loading = true;
  @override
  void initState() {
    timer();
    super.initState();
  }
  timer(){
    Timer(const Duration(seconds: 10),(){
      setState(() {
        loading=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if(loading){
          return const LoadingScreen();
        }
        if (state is LoadingSplachSharedValueState) {
          return   Center(
            child: CircularProgressIndicator(color: AppColors().circularProgressIndicatorColor,),
          );
        }
        if (state is LoadedSplachSharedValueState) {
          if (state.splashSharedValue == true &&
              state.activeSharedValue == true) {
            return const HomeScreen();
          }
          if (state.splashSharedValue == true &&
              state.activeSharedValue == false) {
            return const SignInScreen();
          }
        }
        if (state is LoadingState) {
          return   Center(child: CircularProgressIndicator(color: AppColors().circularProgressIndicatorColor,));
        }
        if (state is ErrorSplach) {
          return Center(
            child: Text(state.failuer.message),
          );
        }
        if (state is LoadedSplach) {
          initList(state.splashes);
          return Scaffold(
            floatingActionButton: GestureDetector(
              onTap: () {
                if (splashScreenIndex < state.splashes.length - 1) {
                  splashScreenIndex++;
                  setState(() {});
                } else {
                  BlocProvider.of<AppCubit>(context, listen: false)
                      .setSplashSharedValue()
                      .then((value) => Navigator.pushReplacementNamed(
                          context, SIGNIN_SCREEN));
                }
              },
              child: CircleAvatar(
                radius: Dimensions.radius30,
                backgroundColor: Colors.blueGrey,
                child: Center(
                    child: Icon(
                  splashScreenIndex == state.splashes.length - 1
                      ? Icons.home_outlined
                      : Icons.next_plan_outlined,
                  size: Dimensions.iconSize24 * 1.5,
                )),
              ),
            ),
            body: Container(
              width: Dimensions.screenWidth,
              height: Dimensions.screenHeight,
              color: Colors.white,
              padding: EdgeInsets.all(Dimensions.width10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    splashes[splashScreenIndex],
                    SizedBox(height: Dimensions.height45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: Dimensions.width15),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ListView.builder(
                              itemCount: state.splashes.length,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: Dimensions.radius10 / 2,
                                    backgroundColor: i == splashScreenIndex
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ]),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
