import 'dart:developer';
import 'dart:io';

import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/core/services/service_locator.dart';
import 'package:pet_house/core/utills/dimensions.dart';
import 'package:pet_house/presentations/controllers/user/user_cubit.dart';
import 'package:pet_house/presentations/widgets/pet_card_widget.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/show_custom_snackbar.dart';
import '../../data/models/parameters/user_parameters.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/foods/food_card_widget.dart';
import '../widgets/tools/tool_card_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ImagePicker picher = ImagePicker();
  File? imageFile;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController lastPassController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  TextEditingController passInSharedController = TextEditingController();

  @override
  void dispose() {
    imageFile = null;
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    newPassController.dispose();
    lastPassController.dispose();
    conPassController.dispose();
    passInSharedController.dispose();
    super.dispose();
  }

  Future<void> updateImage(BuildContext context) async {
    XFile? baseFile;
    baseFile = await picher.pickImage(source: ImageSource.gallery);
    if (baseFile != null) {
      File image = File(baseFile.path);
      setState(() {
        imageFile = image;
      });
    }
  }

  Future<String> getsharedPass() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getString("pass") ?? "";
  }

  editMyData(
      {required TextEditingController controller,
      required String label,
      TextInputType keytype = TextInputType.text}) async {
    String passInShared = "";
    if (passInShared.isEmpty) {
      //final shared = await SharedPreferences.getInstance();
      passInShared = await getsharedPass();
      passInSharedController.text = passInShared;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.enter_new_label(label)
              //"Enter New $label"
              ),
          content: label == "Password"
              ? SizedBox(
                  height: Dimensions.screenHeight / 5,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: keytype,
                        controller: lastPassController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.last_password,
                          //"Last password",
                          focusColor: AppColors().borderColor,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        keyboardType: keytype,
                        controller: newPassController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.new_Password,
                          //"New Password",
                          focusColor: AppColors().borderColor,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        keyboardType: keytype,
                        controller: conPassController,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.confirm_Password,
                          //"Confirm Password",
                          focusColor: AppColors().borderColor,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                )
              : TextFormField(
                  keyboardType: keytype,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .enter_your_Label_here(label),
                    //"Enter your $label here",
                    focusColor: AppColors().borderColor,
                    focusedBorder: InputBorder.none,
                  ),
                ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().primaryColorLight),
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().primaryColorLight),
              child: Text(AppLocalizations.of(context)!.ok),
              onPressed: () {
                String text = controller.text;
                // Do something with the text
                log(text);
                switch (label) {
                  case "Name":
                    if (nameController.text.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          MySnackBars.failureSnackBar(
                              AppLocalizations.of(context)!
                                  .the_name_must_not_be_less_than_three_letters
                              // "The name must not be less than three letters"
                              ));
                    } else {
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                    return;
                  case "Phone":
                    String f3c = phoneController.text.substring(0, 3);
                    if (phoneController.text.length != 10 ||
                        (f3c != "078" && f3c != "077" && f3c != "079")) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          MySnackBars.failureSnackBar(
                              AppLocalizations.of(context)!
                                  .the_phone_number_10_digits
                              //"The phone number must equal 10 digits starting with 078 or 077 or 079"
                              ));
                    } else {
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                    return;
                  case "Email":
                    String pattern =
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                        r"{0,253}[a-zA-Z0-9])?)*$";
                    RegExp regex = RegExp(pattern);
                    if (emailController.text.isEmpty ||
                        !regex.hasMatch(emailController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          MySnackBars.failureSnackBar(
                              AppLocalizations.of(context)!.invalid_email
                              //"invalid email"
                              ));
                    } else {
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                    return;
                  case "Address":
                    if (addressController.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          MySnackBars.failureSnackBar(
                              AppLocalizations.of(context)!
                                  .the_address_must_not_be_less_than_six_letters
                              //"The address must not be less than six letters"
                              ));
                    } else {
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                    return;
                  case "Password":
                    if (lastPassController.text != passInShared) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          MySnackBars.failureSnackBar(
                              AppLocalizations.of(context)!
                                  .invalid_last_password
                              // "Invalid last password"
                              ));
                    } else if (newPassController.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          MySnackBars.failureSnackBar(
                              AppLocalizations.of(context)!
                                  .the_password_must_not_be_less_than_six_letters
                              //"The password must not be less than six letters"
                              ));
                    } else if (newPassController.text !=
                        conPassController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          MySnackBars.failureSnackBar(
                              AppLocalizations.of(context)!
                                  .the_New_password_not_equal_confirm_password
                              // "The New password not equal confirm password"
                              ));
                    } else {
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                    return;
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext mcontext) {
    return BlocProvider(
      create: (mcontext) => getIt.get<UserCubit>()..getUserData(mcontext),
      child: Scaffold(
        backgroundColor: AppColors().backgroundColorScaffold,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(mcontext),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors().iconColor,
            ),
          ),
          backgroundColor: AppColors().backgroundColorScaffold,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
              AppLocalizations.of(context)!.profile
              // "Profile"
              ,
              style: TextStyles.titleTextStyle),
        ),
        body: BlocConsumer<UserCubit, UserState>(
            listener: (context, state) {},
            buildWhen: (previous, current) => previous != current,
            builder: (ccontext, state) {
              if (state is LoadingUserData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors().circularProgressIndicatorColor,
                  ),
                );
              }
              if (state is LoadedUserData) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.height15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                  radius: Dimensions.radius25 * 2.9,
                                  backgroundColor: AppColors().iconColor,
                                child: imageFile != null
                                  ? CircleAvatar(
                                  radius: Dimensions.radius30 * 2 + 5,
                                  backgroundImage: FileImage(imageFile!))
                                  : state.userModel.picture.isNotEmpty
                                  ? CircleAvatar(
                                  radius: Dimensions.radius30 * 2 + 5,
                                  backgroundImage:
                                  CachedNetworkImageProvider(
                                    state.userModel.picture,
                                  ))
                                  : CircleAvatar(
                                  radius: Dimensions.radius30 * 2 + 5,
                                  backgroundImage: const AssetImage(
                                    "assets/profile.png",)),
                              ),
                                  Positioned(
                                      bottom: 7,
                                      left: Dimensions.screenWidth / 3.9,
                                      child: GestureDetector(
                                        onTap: () {
                                          updateImage(context);
                                        },
                                        child: CircleAvatar(
                                            radius: Dimensions.radius15,
                                            backgroundColor: AppColors().iconColor,
                                            child: Icon(
                                              Icons.camera_alt_rounded,
                                              color: AppColors().reIconColor,
                                            )),
                                      )),
                            ],
                          ),
                        ),

                        SizedBox(height: Dimensions.height15),
                        Text(
                            nameController.text.isEmpty
                                ? state.userModel.name
                                : nameController.text,
                            style: TextStyles.nameTextStyle),
                        SizedBox(height: Dimensions.height15 / 2),
                        // Text(
                        //     AppLocalizations.of(context)!.seller
                        //     //'Seller'
                        //     ,
                        //     style: TextStyles.subNameTextStyle),
                        SizedBox(height: Dimensions.height15),
                        ListTile(
                          leading: Icon(Icons.text_fields_rounded,
                              color: AppColors().iconColor),
                          title: Text(
                              nameController.text.isEmpty
                                  ? state.userModel.name
                                  : nameController.text,
                              style: TextStyles.subNameTextStyle),
                          trailing:
                              Icon(Icons.edit, color: AppColors().iconColor),
                          onTap: () => editMyData(
                              controller: nameController, label: "Name"),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.email, color: AppColors().iconColor),
                          title: Text(
                              emailController.text.isEmpty
                                  ? state.userModel.email
                                  : emailController.text,
                              style: TextStyles.subNameTextStyle),
                          trailing:
                              Icon(Icons.edit, color: AppColors().iconColor),
                          onTap: () => editMyData(
                              controller: emailController, label: "Email"),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.phone, color: AppColors().iconColor),
                          title: Text(
                              phoneController.text.isEmpty
                                  ? state.userModel.phone
                                  : phoneController.text,
                              style: TextStyles.subNameTextStyle),
                          trailing:
                              Icon(Icons.edit, color: AppColors().iconColor),
                          onTap: () => editMyData(
                              controller: phoneController,
                              label: AppLocalizations.of(context)!.phone,
                              // "Phone",
                              keytype: TextInputType.number),
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on_outlined,
                              color: AppColors().iconColor),
                          title: Text(
                              addressController.text.isEmpty
                                  ? state.userModel.address
                                  : addressController.text,
                              style: TextStyles.subNameTextStyle),
                          trailing:
                              Icon(Icons.edit, color: AppColors().iconColor),
                          onTap: () => editMyData(
                              controller: addressController, label: "Address"),
                        ),
                        ListTile(
                          leading: Icon(Icons.password,
                              color: AppColors().iconColor),
                          title: Text(AppLocalizations.of(context)!.password,
                              // "Password",
                              style: TextStyles.subNameTextStyle),
                          trailing:
                              Icon(Icons.edit, color: AppColors().iconColor),
                          onTap: () => editMyData(
                              controller: newPassController, label: "Password"),
                        ),
                        SizedBox(height: Dimensions.height15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.my_pets,
                                //'My Pets',
                                style: TextStyles.sectionNameTextStyle),
                            if (nameController.text.isNotEmpty ||
                                emailController.text.isNotEmpty ||
                                phoneController.text.isNotEmpty ||
                                addressController.text.isNotEmpty ||
                                newPassController.text.isNotEmpty ||
                                imageFile != null)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors().primaryColorLight),
                                child: Text(
                                  AppLocalizations.of(context)!.save_edit,
                                  //"SAVE EDIT"
                                ),
                                onPressed: () async {
                                  if (passInSharedController.text.isEmpty) {
                                    passInSharedController.text =
                                        await getsharedPass();
                                  }
                                  var parameters = UserParameters(
                                      id: state.userModel.id,
                                      name: nameController.text.isEmpty
                                          ? state.userModel.name
                                          : nameController.text,
                                      email: emailController.text.isEmpty
                                          ? state.userModel.email
                                          : emailController.text,
                                      password: newPassController.text.isEmpty
                                          ? passInSharedController.text
                                          : newPassController.text,
                                      phone: phoneController.text.isEmpty
                                          ? state.userModel.phone
                                          : phoneController.text,
                                      address: addressController.text.isEmpty
                                          ? state.userModel.address
                                          : addressController.text,
                                      picture: imageFile,
                                      isAdmin: state.userModel.isAdmin);
                                  clearControllers();
                                  setState(() {
                                    BlocProvider.of<UserCubit>(ccontext,
                                            listen: false)
                                        .updateUserData(ccontext, parameters);
                                  });
                                },
                              ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height10),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Container(
                              padding: EdgeInsets.all(Dimensions.height10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  ListView.separated(
                                    itemCount: state.userModel.myPets.length,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          PetCardWidget(
                                            index: index,
                                            pet: state.userModel.myPets[index],
                                          ),
                                          Positioned(
                                              left: 15,
                                              top: 13,
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      width: Dimensions.width20,
                                                      height: Dimensions.width20,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey.shade300,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  Dimensions
                                                                      .radius10)),
                                                      child: Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        color: Colors.red[400],
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      log(state.userModel
                                                          .myPets[index].id
                                                          .toString());
                                                      setState(() {
                                                        BlocProvider.of<UserCubit>(
                                                                ccontext,
                                                                listen: false)
                                                            .removeUserItem(
                                                                ccontext,
                                                                state
                                                                    .userModel
                                                                    .myPets[index]
                                                                    .id,'pet',
                                                                state.userModel);
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  // GestureDetector(
                                                  //   onTap: () {},
                                                  //   child: Container(
                                                  //     width: Dimensions.width20,
                                                  //     height: Dimensions.width20,
                                                  //     decoration: BoxDecoration(
                                                  //         color:
                                                  //             Colors.grey.shade300,
                                                  //         borderRadius:
                                                  //             BorderRadius.circular(
                                                  //                 Dimensions
                                                  //                     .radius10)),
                                                  //     child: Icon(
                                                  //       Icons.edit,
                                                  //       color: Colors.red[400],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ))
                                        ],
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(height: 15),
                                  ),
                                  SizedBox(height: Dimensions.height15),
                                  ListView.separated(
                                    itemCount: state.userModel.myTools.length,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          ToolCardWidget(
                                            index: index,
                                            tool: state.userModel.myTools[index],
                                          ),
                                          Positioned(
                                              left: 15,
                                              top: 13,
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      width: Dimensions.width20,
                                                      height: Dimensions.width20,
                                                      decoration: BoxDecoration(
                                                          color:
                                                          Colors.grey.shade300,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              Dimensions
                                                                  .radius10)),
                                                      child: Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        color: Colors.red[400],
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      log(state.userModel
                                                          .myTools[index].id
                                                          .toString());
                                                      setState(() {
                                                        BlocProvider.of<UserCubit>(
                                                            ccontext,
                                                            listen: false)
                                                            .removeUserItem(
                                                            ccontext,
                                                            state
                                                                .userModel
                                                                .myTools[index]
                                                                .id,'tool',
                                                            state.userModel);
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  // GestureDetector(
                                                  //   onTap: () {},
                                                  //   child: Container(
                                                  //     width: Dimensions.width20,
                                                  //     height: Dimensions.width20,
                                                  //     decoration: BoxDecoration(
                                                  //         color:
                                                  //         Colors.grey.shade300,
                                                  //         borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             Dimensions
                                                  //                 .radius10)),
                                                  //     child: Icon(
                                                  //       Icons.edit,
                                                  //       color: Colors.red[400],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ))
                                        ],
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                    const SizedBox(height: 15),
                                  ),
                                  SizedBox(height: Dimensions.height15),
                                  ListView.separated(
                                    itemCount: state.userModel.myFoods.length,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          FoodCardWidget(
                                            index: index,
                                            food: state.userModel.myFoods[index],
                                          ),
                                          Positioned(
                                              left: 15,
                                              top: 13,
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      width: Dimensions.width20,
                                                      height: Dimensions.width20,
                                                      decoration: BoxDecoration(
                                                          color:
                                                          Colors.grey.shade300,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              Dimensions
                                                                  .radius10)),
                                                      child: Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        color: Colors.red[400],
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      log(state.userModel
                                                          .myFoods[index].id
                                                          .toString());
                                                      setState(() {
                                                        BlocProvider.of<UserCubit>(
                                                            ccontext,
                                                            listen: false)
                                                            .removeUserItem(
                                                            ccontext,
                                                            state
                                                                .userModel
                                                                .myFoods[index]
                                                                .id,'food',
                                                            state.userModel);
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  // GestureDetector(
                                                  //   onTap: () {},
                                                  //   child: Container(
                                                  //     width: Dimensions.width20,
                                                  //     height: Dimensions.width20,
                                                  //     decoration: BoxDecoration(
                                                  //         color:
                                                  //         Colors.grey.shade300,
                                                  //         borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             Dimensions
                                                  //                 .radius10)),
                                                  //     child: Icon(
                                                  //       Icons.edit,
                                                  //       color: Colors.red[400],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ))
                                        ],
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                    const SizedBox(height: 15),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is ErrorLoadingUserData) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.error_something_wrong,
                    style: TextStyles.cardSubTitleTextStyle2
                        .copyWith(color: Colors.black),
                  ),
                );
              }
              return const SizedBox();
            }),
      ),
    );
  }

  clearControllers() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    newPassController.clear();
    lastPassController.clear();
    passInSharedController.clear();
    conPassController.clear();
    imageFile = null;
  }
}
