import 'package:pet_house/core/constant/app_constant.dart';
import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:pet_house/presentations/widgets/hero_image.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool conObscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<UserCubit>(),
      child: Scaffold(
        backgroundColor: AppColors().backgroundColorScaffold,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const HeroImage(welcomeImage: AppConst.loginImage,signin: false,),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 18, right: 18, top: Dimensions.screenHeight * 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcome_back,
                      style: TextStyles.signinTextStyle,
                    ),
                    Text(
                      AppLocalizations.of(context)!.login_to_manage,
                      style: TextStyles.signinTageLineStyle,
                    ),
                    const SizedBox(height: 15),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.name,
                            //'Name',
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.white),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.white),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.length < 3) {
                              return AppLocalizations.of(context)!.invalid_name;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.email,
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.white),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.white),
                            ),
                          ),
                          validator: (String? value) {
                            String pattern =
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                r"{0,253}[a-zA-Z0-9])?)*$";
                            RegExp regex = RegExp(pattern);
                            if (value!.isEmpty || !regex.hasMatch(value)) {
                              return AppLocalizations.of(context)!
                                  .invalid_email;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye,
                                color: Colors.white,
                              ),
                            ),
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.password,
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.white),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.white),
                            ),
                          ),
                          obscureText: obscureText,
                          validator: (String? value) {
                            if (value!.isEmpty || value.length < 6) {
                              return AppLocalizations.of(context)!
                                  .invalid_password;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: conPasswordController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  conObscureText = !conObscureText;
                                });
                              },
                              icon: Icon(
                                conObscureText
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye,
                                color: Colors.white,
                              ),
                            ),
                            border: const OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context)!.confirm_Password,
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.white),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.white),
                            ),
                          ),
                          obscureText: conObscureText,
                          validator: (String? value) {
                            if (value != passwordController.text) {
                              return AppLocalizations.of(context)!
                                  .invalid_confirm_password;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.phone,
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.white),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.white),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty || value.length != 10) {
                              return AppLocalizations.of(context)!
                                  .invalid_phone_Number;
                              //"invalid phone Number";
                            }
                            return null;
                          },
                        ),
                      ]),
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            });
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<UserCubit>(context, listen: false)
                                  .signup(
                                      context,
                                      nameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      phoneController.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              minimumSize: const Size(1024, 60),
                              backgroundColor:
                                  const Color.fromRGBO(99, 139, 156, 1)),
                          child: state is LoadingUserData
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors()
                                      .circularProgressIndicatorColor,
                                ))
                              : Text(
                                  AppLocalizations.of(context)!.signup,
                                  style: const TextStyle(fontSize: 16),
                                ),
                        );
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                            AppLocalizations.of(context)!
                                .already_Have_an_Account,
                            style: TextStyles.signinTageLineStyle),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
