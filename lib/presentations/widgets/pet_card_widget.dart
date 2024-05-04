import 'package:pet_house/core/constant/color_constant.dart';
import 'package:pet_house/data/models/pet_model.dart';
import 'package:pet_house/presentations/widgets/cached_network_image.dart';
import 'package:pet_house/core/constant/text_style.dart';
import 'package:pet_house/presentations/screen/pets/pet_details_screen.dart';
import 'package:flutter/material.dart';

class PetCardWidget extends StatelessWidget {
  final PetModel pet;
  final int index;
  const PetCardWidget({Key? key, required this.pet, required this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PetDetailsScreen(
                        pet: pet,
                      )));
        },
        child: Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: AppColors().backgroundColorCardContainer,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? Colors.blueGrey[300]
                        : Colors.orange[100],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppColors().shadowList,
                  ),
                  child:
                      pet.image.isNotEmpty && pet.image[0].webViewLink.isNotEmpty
                          ? CachedImage(imageUrl: pet.image[0].webViewLink)
                          : Container(),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: AppColors().backgroundColorCardContainer,
                      boxShadow: AppColors().shadowList,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          pet.name,
                          style: TextStyles.subscriptionTitleTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(pet.location,
                                style: TextStyles.cardSubTitleTextStyle3),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors().iconColor,
                            ),
                          ],
                        ),
                        Text(
                          pet.createdDate,
                          style: TextStyles.cardSubTitleTextStyle3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (pet.price == 0)
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Text("For Adoption",
                                    style: TextStyles.body3TextStyle
                                    //.copyWith(color: Colors.white),
                                    ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                pet.gender == "female"
                                    ? Icons.female
                                    : Icons.male,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        if (pet.price != 0)
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Text("${pet.price} JOD",
                                    style: TextStyles.body3TextStyle
                                    //.copyWith(color: Colors.white),
                                    ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                pet.gender == "female"
                                    ? Icons.female
                                    : Icons.male,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
