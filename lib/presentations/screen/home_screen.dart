import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/presentations/controllers/pet/pet_cubit.dart';
import 'package:pet_house/presentations/screen/drawer_screen.dart';
import 'package:pet_house/presentations/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => getIt.get<PetCubit>(),
        child: Scaffold(
            backgroundColor: AppColors().backgroundColorScaffold,
            body: Stack(
              children: const [DrawerScreen(), MainScreen()],
            )
            //  BlocBuilder<PetCubit, PetState>(
            //   builder: (context, state) {
            //     if (state is LoadingState) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     if (state is LoadedState) {
            //       return Stack(
            //         children: const [DrawerScreen(), MainScreen()],
            //       );
            //     }
            //     if (state is ErrorState) {
            //       return const Center(child: Text("ERROR"));
            //     } else {
            //       log("HOME SCREEN");
            //       return const Center(child: Text("Under Mantanance"));
            //     }
            //   },
            // ),
            ));
  }
}
