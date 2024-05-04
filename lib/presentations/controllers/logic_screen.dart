// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screen/home_screen.dart';
import 'pet/pet_cubit.dart';

class LogicScreen extends StatefulWidget {
  const LogicScreen({super.key});

  @override
  State<LogicScreen> createState() => _LogicScreenState();
}

class _LogicScreenState extends State<LogicScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PetCubit, PetState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LoadedState) {
            return const HomeScreen();
          }
          if (state is ErrorState) {
            return const Center(child: Text("ERROR"));
          } else {
            return const Center(child: Text("Under Maintenance"));
          }
        },
      ),
    );
  }
}

class TT extends StatefulWidget {
  const TT({super.key});

  @override
  State<TT> createState() => _TTState();
}

class _TTState extends State<TT> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        if (state is LoadedState) {
          return Center(child: Text(state.pets.length.toString()));
        } else {
          return const Center(child: Text("Empty TT"));
        }
      },
    );
  }
}
