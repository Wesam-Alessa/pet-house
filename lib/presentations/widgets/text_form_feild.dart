import 'package:pet_house/core/constant/color_constant.dart';
import 'package:flutter/material.dart';

import '../../core/constant/text_style.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool number;
  const TextFormFieldWidget(
      {Key? key,
      required this.title,
      required this.controller,
      this.number = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      style: TextStyles.textFormFieldWidgetStyle,
      cursorColor: Colors.grey.shade700,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: title,
        labelStyle: TextStyles.textFormFieldWidgetStyle,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: AppColors().borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: AppColors().borderColor),
        ),
      ),
    );
  }
}
