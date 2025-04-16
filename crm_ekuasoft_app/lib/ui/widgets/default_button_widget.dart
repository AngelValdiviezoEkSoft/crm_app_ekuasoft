import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Color? colorBoton;
  final Color? colorTexto;
  final FontWeight? weight;

  const DefaultButton({
    super.key,
    required this.text,
    this.colorBoton,
    this.colorTexto,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.06,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.width * 0.4),
          color: colorBoton ?? ColorsApp().morado),
      child: Center(
        child: BaseText(        
          null,
          text,
          size: 0.055,
          weight: weight ?? FontWeight.w500,
          color: colorTexto ?? ColorsApp().blanco0Opacidad,
        )
      ),
    );
  }
}
