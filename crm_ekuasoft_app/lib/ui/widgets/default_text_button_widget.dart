import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';

class DefaultTextButtonCvs extends StatelessWidget {
  final String text;
  final Color? colorBoton;
  final Color? colorTexto;
  final FontWeight? weight;
  final VoidCallback? onPress;
  final double? sizeText;
  const DefaultTextButtonCvs({
    super.key,
    required this.text,
    this.colorBoton,
    this.colorTexto,
    this.weight,
    this.onPress,
    this.sizeText,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPress,
        style: TextButton.styleFrom(
          backgroundColor: colorBoton,
        ),
        child: BaseText(          
          null,
          text,
          size: sizeText ?? 0.045,
          weight: weight ?? FontWeight.w500,
          color: colorTexto ?? ColorsApp().morado,
        ));
  }
}
