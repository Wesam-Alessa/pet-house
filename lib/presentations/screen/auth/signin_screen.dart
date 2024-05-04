import 'dart:developer';

import 'package:pet_house/core/constant/app_constant.dart';
import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/data/models/reports/objection_report_model.dart';
import 'package:pet_house/main.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:pet_house/presentations/widgets/hero_image.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/show_custom_snackbar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController text = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool diasabel = false;

  @override
  void initState() {
    diasabel = getIt.get<SharedPreferences>().getBool('disable') ?? false;
    log(diasabel.toString());
    super.initState();
  }

  @override
  void dispose() {
    text.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

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
                child: const HeroImage(
                    welcomeImage: AppConst.loginImage, signin: true),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 18, right: 18, top: Dimensions.screenHeight * 0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcome_back,
                      //'Welcome back',
                      style: TextStyles.signinTextStyle,
                    ),
                    Text(
                      AppLocalizations.of(context)!.login_to_manage,
                      //'Login to manage your account.',
                      style: TextStyles.signinTageLineStyle,
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.email,
                            //'Email',
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
                        const SizedBox(height: 24),
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
                            //'Password',
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
                              //"invalid password";
                            }
                            return null;
                          },
                        ),
                      ]),
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            });
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<UserCubit>(context, listen: false)
                                  .signin(
                                context,
                                emailController.text,
                                passwordController.text,
                              );
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
                                  AppLocalizations.of(context)!.signin,
                                  // 'SIGNIN',
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
                          Navigator.pushNamed(context, SIGNUP_SCREEN);
                        },
                        child: Text(
                            AppLocalizations.of(context)!.dont_Have_an_Account,
                            //"Don't Have an Account? Sign up",
                            style: TextStyles.signinTageLineStyle),
                      ),
                    ),
                    if (diasabel)
                      Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            checkObjectionRequest(context);
                          },
                          child: Text(
                              AppLocalizations.of(context)!
                                  .submit_an_objection_request,
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

  checkObjectionRequest(mcontext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, localSetState) {
            return AlertDialog(
              scrollable: true,
              title: Text(
                  AppLocalizations.of(mcontext)!.submit_an_objection_request),
              content: TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.enter_your_email_here,
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.close),
                  onPressed: () {
                    text.clear();
                    emailController.clear();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.send),
                  onPressed: () {
                    if (emailController.text.isEmpty) {
                      showError(context,
                          AppLocalizations.of(context)!.error_write_your_email);
                    } else if (emailController.text.isNotEmpty) {
                      String pattern =
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?)*$";
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(emailController.text)) {
                        showError(context,
                            AppLocalizations.of(context)!.invalid_email);
                      } else {
                        getIt
                            .get<UserCubit>()
                            .checkObjectionReport(
                                mcontext, emailController.text)
                            .then((value) {
                          if (value != null) {
                            submitAnObjectionRequest(mcontext, value);
                          } else {
                            text.clear();
                            emailController.clear();
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    }
                  },
                ),
              ],
            );
          }),
        );
      },
    );
  }

  submitAnObjectionRequest(mcontext, ObjectionReportModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection:
              initLanguageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: StatefulBuilder(builder: (context, localSetState) {
            return AlertDialog(
              scrollable: true,
              title: Text(
                  AppLocalizations.of(mcontext)!.submit_an_objection_request),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: model.id.isEmpty
                    ? [
                        Text(AppLocalizations.of(mcontext)!.your_email_is),
                        const SizedBox(height: 10),
                        Text(emailController.text),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: text,
                          maxLines: null,
                          minLines: 1,
                          decoration: InputDecoration(
                              hintText: AppLocalizations.of(mcontext)!
                                  .write_your_objection_here),
                        ),
                      ]
                    : [
                        Text(AppLocalizations.of(mcontext)!
                            .a_report_has_already_been_sent_before),
                        const SizedBox(height: 10),
                        Text(AppLocalizations.of(mcontext)!.report_content_is,
                            style: TextStyles.sectionNameTextStyle),
                        const SizedBox(height: 10),
                        Text(model.content),
                        const SizedBox(height: 10),
                        Text(AppLocalizations.of(mcontext)!.report_answer_is,
                            style: TextStyles.sectionNameTextStyle),
                        const SizedBox(height: 10),
                        Text(model.answer),
                      ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primaryColorLight),
                  child: Text(AppLocalizations.of(mcontext)!.close),
                  onPressed: () {
                    text.clear();
                    emailController.clear();
                    Navigator.of(context).pop();
                  },
                ),
                if (model.id.isEmpty)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().primaryColorLight),
                    child: Text(AppLocalizations.of(mcontext)!.send),
                    onPressed: () {
                      if (text.text.isEmpty || emailController.text.isEmpty) {
                        showError(
                            context,
                            AppLocalizations.of(context)!
                                .error_write_your_objection_and_email);
                      }
                      if (emailController.text.isNotEmpty) {
                        String pattern =
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                            r"{0,253}[a-zA-Z0-9])?)*$";
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(emailController.text)) {
                          showError(context,
                              AppLocalizations.of(context)!.invalid_email);
                        }
                      }
                      globalUserCubit.sendObjectionReport(
                          mcontext, text.text, emailController.text);
                      text.clear();
                      emailController.clear();
                      Navigator.pushReplacementNamed(context, SIGNIN_SCREEN);
                    },
                  ),
              ],
            );
          }),
        );
      },
    );
  }

  showError(context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBars.failureSnackBar(message));
  }
}
