import 'package:pet_house/core/constant/text_style.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final double? opacity;
  final String title;
  final String subTitle;
  const CustomAppBar({super.key, this.opacity,required  this.title,required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Opacity(
        opacity: opacity!,
        child: Container(
            padding: const EdgeInsets.only(top: 10, right: 16, left: 16),
            child: Row(
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: title,
                    //Strings.appName,
                    style: TextStyles.appNameTextStyle,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: subTitle,
                    //Strings.tagName,
                    style: TextStyles.tageLineStyle,
                  ),
                ])),
                const Spacer(),
                //  PopupMenuButton(
                //    shape: RoundedRectangleBorder(
                //      borderRadius: BorderRadius.circular(10)
                //    ),
                //    itemBuilder: (context)=>[
                //    const PopupMenuItem(child: Text('About',))
                //  ],
                //  icon:const Icon(Icons.menu,color: Colors.white,),
                //  color: Colors.white,
                //  )
              ],
            )),
      ),
    );
  }
}
