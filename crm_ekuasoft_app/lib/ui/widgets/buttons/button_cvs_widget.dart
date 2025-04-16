import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/ui/theme/app_color_light.dart';
import 'package:flutter/material.dart';

class ButtonCvsWidget extends StatelessWidget {
  final TextStyle textStyle;
  final String text;
  final Color? colorBoton;
  final VoidCallback? onPressed;

  const ButtonCvsWidget({
    super.key,
    required this.textStyle,
    required this.text,
    this.colorBoton,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return onPressed == null
        ? Container(
            width: double.infinity,
            height: size.height * 0.06,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.4),
                color: colorBoton ?? AppLightColors().primary),
            child: Center(
                child: AutoSizeText(
              text,
              style: textStyle,
              maxLines: 1,
              minFontSize: 6,
            )),
          )
        : GestureDetector(
            onTap: () {
              if (onPressed != null) {
                onPressed!();
              }
            },
            child: Container(
              width: double.infinity,
              height: size.height * 0.06,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width * 0.4),
                  color: colorBoton ?? AppLightColors().primary),
              child: Center(
                  child: AutoSizeText(
                text,
                style: textStyle,
                maxLines: 1,
                minFontSize: 6,
              )),
            ),
          );
  }
}
