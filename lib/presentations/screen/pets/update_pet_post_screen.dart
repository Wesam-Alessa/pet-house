import 'dart:developer';
import 'dart:io';
import 'package:pet_house/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePetPostScreen extends StatefulWidget {
  const UpdatePetPostScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdatePetPostScreen> createState() => _UpdatePetPostScreenState();
}

class _UpdatePetPostScreenState extends State<UpdatePetPostScreen> {
  ProductModel? product;
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController price = TextEditingController();

  int quantity = 0;
  int ageYears = 0;
  int ageMounth = 0;
  List<String> genderItems = ['male', 'female'];
  String genderValue = '';
  ImagePicker picker = ImagePicker();
  List<File> images = [];
  List<String> oldImages = [];
  List<dynamic> allImages = [];

  void pickImages() async {
    //images.clear();
    List<XFile> pImage = [];
    pImage = await picker.pickMultiImage();
    for (var image in pImage) {
      images.add(File(image.path));
      allImages.add(File(image.path));
      log(image.path);
    }
    setState(() {});
  }

  String categoryValue = '';
  List<String> categoryItems = [];

  @override
  void initState() {
    // product =
    //     Provider.of<ProductProvider>(context, listen: false).updateProductModel;
    genderValue = product!.gender;
    //genderItems[0];
    //getCategories();
    initValues();
    super.initState();
  }

  void initValues() {
    name.text = product!.name;
    description.text = product!.description;
    contact.text = product!.contact;
    address.text = product!.address;
    type.text = product!.type;
    price.text = product!.price.toString();
    quantity = int.parse(product!.quantity);
    ageYears = product!.ageYears;
    ageMounth = product!.ageMounth;
    oldImages = product!.pictures.cast();
    allImages.addAll(images);
    allImages.addAll(oldImages);
    log("oldImages : ");

    log(oldImages.length.toString());
    log("allImages : ");
    log(allImages.length.toString());

    // for (var item
    //     in Provider.of<ProductProvider>(context, listen: false).categories) {
    //   categoryItems.add(item.label);
    // }
    categoryValue = product!.category;

    setState(() {});
  }

  // void getCategories() {
  //   // await Provider.of<ProductProvider>(context, listen: false)
  //   //     .getCategories(context)
  //   //     .then((value) {
  //   for (var item
  //       in Provider.of<ProductProvider>(context, listen: false).categories) {
  //     categoryItems.add(item.name);
  //   }
  //   categoryValue = product.category;
  //   //categoryItems[0];
  //   initValues();
  //   setState(() {});
  //   // });
  // }

  @override
  void dispose() {
    categoryItems.clear();
    categoryValue = '';
    name.dispose();
    description.dispose();
    contact.dispose();
    address.dispose();
    type.dispose();
    images.clear();
    price.dispose();
    quantity = 0;
    ageYears = 0;
    ageMounth = 0;
    genderValue = '';
    oldImages.clear();
    allImages.clear();
    product = null;
    super.dispose();
  }

  void updatePost() async {
    ProductModel updateProduct = ProductModel(
        name: name.text,
        id: product!.id,
        userId:'',
           // Provider.of<UserProvider>(context, listen: false).getUserModel.id,
        category: categoryValue,
        quantity: quantity.toString(),
        price: double.parse(price.text),
        ageYears: ageYears,
        ageMounth: ageMounth,
        pictures: images.isEmpty ? oldImages : images,
        description: description.text,
        address: address.text,
        dateTime: DateTime.now().toString(),
        contact: contact.text,
        gender: genderValue,
        type: type.text);
    // log("images: " + images.length.toString());
    // log("oldImages: " + oldImages.length.toString());
    // log("allImages: " + allImages.length.toString());
    // log("product image: " + updateProduct.pictures.length.toString());
    // await Provider.of<ProductProvider>(context, listen: false).updateProduct(
    //     product: updateProduct,
    //     context: context,
    //     oldImages: oldImages,
    //     newImages: images);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     leading: Consumer<ProductProvider>(builder: (context, state, _) {
    //       return state.loading
    //           ? const SizedBox()
    //           : IconButton(
    //               onPressed: () => Navigator.pop(context),
    //               icon: const Icon(
    //                 Icons.arrow_back_ios,
    //                 color: Colors.black,
    //               ),
    //             );
    //     }),
    //     backgroundColor: Colors.white,
    //     elevation: 0.0,
    //     centerTitle: true,
    //     title: Text(
    //       "update your pet post",
    //       style: TextStyles.titleTextStyle.copyWith(color: Colors.black),
    //     ),
    //     actions: [
    //       Consumer<ProductProvider>(builder: (context, state, _) {
    //         return state.loading
    //             ? SizedBox(
    //                 width: Dimensions.height20 * 2,
    //                 child:   Center(child: CircularProgressIndicator(color: AppColors().circularProgressIndicatorColor,)))
    //             : IconButton(
    //                 onPressed: updatePost,
    //                 icon: const Icon(
    //                   Icons.file_upload_outlined,
    //                   color: Colors.black,
    //                 ),
    //               );
    //       }),
    //     ],
    //   ),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.all(10.0),
    //       child: Column(
    //         children: [
    //           Container(
    //             height: Dimensions.screenHeight / 5,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.all(
    //                 Radius.circular(Dimensions.radius10 / 2),
    //               ),
    //               border: Border.all(width: 1, color: Colors.grey),
    //             ),
    //             child: allImages.isEmpty
    //                 ? Center(
    //                     child: IconButton(
    //                         onPressed: pickImages,
    //                         icon: Icon(
    //                           Icons.add,
    //                           size: Dimensions.iconSize24,
    //                         )))
    //                 : Stack(
    //                     children: [
    //                       ListView.builder(
    //                           itemCount: allImages.length,
    //                           scrollDirection: Axis.horizontal,
    //                           padding: const EdgeInsets.symmetric(
    //                               horizontal: 5, vertical: 5),
    //                           itemBuilder: ((context, index) => Padding(
    //                                 padding: const EdgeInsets.all(4.0),
    //                                 child: Stack(
    //                                   children: [
    //                                     if (allImages[index] is String)
    //                                       Image.network(
    //                                         allImages[index],
    //                                         fit: BoxFit.cover,
    //                                       ),
    //                                     if (allImages[index] is File)
    //                                       Image.file(
    //                                         allImages[index],
    //                                         fit: BoxFit.cover,
    //                                       ),
    //                                     InkWell(
    //                                       onTap: () {
    //                                         setState(() {
    //                                           if (allImages[index] is File) {
    //                                             images.removeWhere((element) =>
    //                                                 element.path ==
    //                                                 allImages[index].path);
    //                                           }
    //                                           if (allImages[index] is String) {
    //                                             oldImages.removeWhere(
    //                                                 (element) =>
    //                                                     element ==
    //                                                     allImages[index]);
    //                                           }
    //                                           allImages.removeAt(index);
    //                                         });
    //                                       },
    //                                       child: CircleAvatar(
    //                                         radius: Dimensions.radius25 / 2,
    //                                         backgroundColor: Colors.white,
    //                                         child: Center(
    //                                             child: Icon(
    //                                           Icons.close,
    //                                           size: Dimensions.iconSize18,
    //                                           color: Colors.black,
    //                                         )),
    //                                       ),
    //                                     )
    //                                   ],
    //                                 ),
    //                               ))),
    //                       Positioned(
    //                           right: 0,
    //                           child: GestureDetector(
    //                             onTap: pickImages,
    //                             child: Container(
    //                               height: Dimensions.screenHeight / 5,
    //                               width: Dimensions.width20,
    //                               color: Colors.grey.shade300,
    //                               child: Icon(
    //                                 Icons.add,
    //                                 color: Colors.black,
    //                                 size: Dimensions.iconSize24,
    //                               ),
    //                             ),
    //                           )),
    //                     ],
    //                   ),
    //           ),
    //           const SizedBox(height: 10),
    //           TextFormFieldWidget(title: 'Name', controller: name),
    //           const SizedBox(height: 10),
    //           TextFormFieldWidget(
    //               title: 'Description', controller: description),
    //           const SizedBox(height: 10),
    //           TextFormFieldWidget(title: 'Type', controller: type),
    //           const SizedBox(height: 10),
    //           TextFormFieldWidget(title: 'Address', controller: address),
    //           const SizedBox(height: 10),
    //           TextFormFieldWidget(title: 'Contact', controller: contact),
    //           const SizedBox(height: 10),
    //           TextFormFieldWidget(
    //               title: 'Price', controller: price, number: true),
    //           const SizedBox(height: 10),
    //           if (categoryItems.isNotEmpty)
    //             Container(
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(Dimensions.radius10 / 2),
    //                 ),
    //                 border: Border.all(width: 2, color: Colors.grey),
    //               ),
    //               padding: const EdgeInsets.symmetric(horizontal: 5),
    //               child: DropdownButton(
    //                 underline: Container(),
    //                 isExpanded: true,
    //                 value: categoryValue,
    //                 icon: const Icon(Icons.keyboard_arrow_down),
    //                 items: categoryItems.map((String items) {
    //                   return DropdownMenuItem(
    //                     value: items,
    //                     child: Text(items),
    //                   );
    //                 }).toList(),
    //                 onChanged: (String? newValue) {
    //                   setState(() {
    //                     categoryValue = newValue!;
    //                   });
    //                 },
    //               ),
    //             ),
    //           const SizedBox(height: 10),
    //           Container(
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.all(
    //                 Radius.circular(Dimensions.radius10 / 2),
    //               ),
    //               border: Border.all(width: 2, color: Colors.grey),
    //             ),
    //             padding: const EdgeInsets.symmetric(horizontal: 5),
    //             child: DropdownButton(
    //               underline: Container(),
    //               isExpanded: true,
    //               value: genderValue,
    //               icon: const Icon(Icons.keyboard_arrow_down),
    //               items: genderItems.map((String items) {
    //                 return DropdownMenuItem(
    //                   value: items,
    //                   child: Text(items),
    //                 );
    //               }).toList(),
    //               onChanged: (String? newValue) {
    //                 setState(() {
    //                   genderValue = newValue!;
    //                 });
    //               },
    //             ),
    //           ),
    //           const SizedBox(height: 10),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             children: [
    //               Column(
    //                 children: [
    //                   Text(
    //                     "Age years",
    //                     style: TextStyles.cardSubTitleTextStyle2
    //                         .copyWith(color: Colors.grey.shade700),
    //                   ),
    //                   const SizedBox(height: 5),
    //                   Container(
    //                     height: Dimensions.height45,
    //                     width: Dimensions.screenWidth / 3,
    //                     decoration: BoxDecoration(
    //                       borderRadius:
    //                           BorderRadius.circular(Dimensions.radius10),
    //                       border:
    //                           Border.all(color: Colors.grey.shade700, width: 1),
    //                     ),
    //                     child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         children: [
    //                           GestureDetector(
    //                               onTap: () {
    //                                 if (ageYears > 0) {
    //                                   setState(() {
    //                                     ageYears--;
    //                                   });
    //                                 }
    //                               },
    //                               child: const Icon(Icons.remove)),
    //                           Text("$ageYears"),
    //                           GestureDetector(
    //                               onTap: () {
    //                                 setState(() {
    //                                   ageYears++;
    //                                 });
    //                               },
    //                               child: const Icon(Icons.add)),
    //                         ]),
    //                   ),
    //                 ],
    //               ),
    //               Column(
    //                 children: [
    //                   Text(
    //                     "Age mounths",
    //                     style: TextStyles.cardSubTitleTextStyle2
    //                         .copyWith(color: Colors.grey.shade700),
    //                   ),
    //                   const SizedBox(height: 5),
    //                   Container(
    //                     height: Dimensions.height45,
    //                     width: Dimensions.screenWidth / 3,
    //                     decoration: BoxDecoration(
    //                       borderRadius:
    //                           BorderRadius.circular(Dimensions.radius10),
    //                       border:
    //                           Border.all(color: Colors.grey.shade700, width: 1),
    //                     ),
    //                     child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         children: [
    //                           GestureDetector(
    //                               onTap: () {
    //                                 if (ageMounth > 0) {
    //                                   setState(() {
    //                                     ageMounth--;
    //                                   });
    //                                 }
    //                               },
    //                               child: const Icon(Icons.remove)),
    //                           Text("$ageMounth"),
    //                           GestureDetector(
    //                               onTap: () {
    //                                 setState(() {
    //                                   ageMounth++;
    //                                 });
    //                               },
    //                               child: const Icon(Icons.add)),
    //                         ]),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 10),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             children: [
    //               Column(
    //                 children: [
    //                   Text(
    //                     "Quantity",
    //                     style: TextStyles.cardSubTitleTextStyle2
    //                         .copyWith(color: Colors.grey.shade700),
    //                   ),
    //                   const SizedBox(height: 5),
    //                   Container(
    //                     height: Dimensions.height45,
    //                     width: Dimensions.screenWidth / 3,
    //                     decoration: BoxDecoration(
    //                       borderRadius:
    //                           BorderRadius.circular(Dimensions.radius10),
    //                       border:
    //                           Border.all(color: Colors.grey.shade700, width: 1),
    //                     ),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                       children: [
    //                         GestureDetector(
    //                             onTap: () {
    //                               if (quantity > 0) {
    //                                 setState(() {
    //                                   quantity--;
    //                                 });
    //                               }
    //                             },
    //                             child: const Icon(Icons.remove)),
    //                         Text("$quantity"),
    //                         GestureDetector(
    //                             onTap: () {
    //                               setState(() {
    //                                 quantity++;
    //                               });
    //                             },
    //                             child: const Icon(Icons.add)),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
