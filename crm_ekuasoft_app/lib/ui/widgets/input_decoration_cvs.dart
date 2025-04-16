import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';

class InputDecorationCvs {
  static InputDecoration checkPhoneInputhDecoration(
      {required String hintTetx,
      required String labelText,
      IconData? prefixIcon,
      required double size,
      Color? labelColor}) {
    return InputDecoration(
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      counterStyle: const TextStyle(color: Colors.transparent),
      contentPadding: const EdgeInsets.only(top: 5),
      hintText: hintTetx,
      labelText: labelText,
      labelStyle: AppTextStyles.h6SemiBold(
          width: size, color: ColorsApp().gris600EtiquetasCvs),
      border: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: ColorsApp().morado,
            )
          : null);
  }

  static InputDecoration authInputDecoration({
    required String hintTetx,
    required String labelText,
    required Size size,
    IconData? prefixIcon,
    IconButton? suffixIcon,
    final VoidCallback? onPressed,
  }) {
    return InputDecoration(
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      counterStyle: const TextStyle(color: Colors.transparent),
      contentPadding: const EdgeInsets.only(top: 10),
      hintText: hintTetx,
      labelText: labelText,
      labelStyle: AppTextStyles.h6SemiBold(
        width: size.width,
        color: AppLightColors().gray800SecondaryText,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: ColorsApp().morado,
            )
          : null,
      suffixIcon: suffixIcon != null
          ? IconButton(
              icon: suffixIcon,
              color: ColorsApp().morado,
              onPressed: () {
                onPressed;
              },
            )
          : null);
  }

  static InputDecoration registerInputhDecoration({
    required String hintTetx,
    required String labelText,
    IconData? prefixIcon,
    IconButton? suffixIcon,
    final VoidCallback? onPressed,
  }) {
    return InputDecoration(
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      counterStyle: const TextStyle(color: Colors.transparent),
      contentPadding: const EdgeInsets.only(top: 10, bottom: 0),
      hintText: hintTetx,
      labelText: labelText,
      labelStyle: TextStyle(
        color: ColorsApp().gris600EtiquetasCvs,
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: ColorsApp().morado,
            )
          : null,
      suffixIcon: suffixIcon != null
          ? IconButton(
              icon: suffixIcon,
              color: ColorsApp().morado,
              onPressed: () {
                onPressed;
              },
            )
          : null);
  }

  static InputDecoration formsDecoration({
    String? hintTetx,
    String? labelText,
    required Size size,
    String? prefixText,
    String? counterTex,
    Icon? prefixIcon
  }) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppLightColors().gray500)
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppLightColors().gray300Stroke)
      ),
      counterText: counterTex ?? '',
      contentPadding: const EdgeInsets.only(top: 10, bottom: 0),
      labelText: labelText ?? '',
      labelStyle: AppTextStyles.h4SemiBold(width: size.width, color: AppLightColors().gray800SecondaryText),
      hintText: hintTetx ?? '',
      hintStyle: AppTextStyles.bodyRegular(
        width: size.width, color: AppLightColors().gray800SecondaryText
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixText: prefixText ?? '',
      suffixIcon: prefixIcon,
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }
}
