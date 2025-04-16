import 'package:flutter/material.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';

class BaseText extends StatelessWidget {
  final double size;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? align;
  final String text;
  final int? maxlines;

  const BaseText(
      Key? key,
      this.text,{
      this.color,
      required this.size,
      this.weight,
      this.align,
      this.maxlines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Text(
        text,
        textAlign: align ?? TextAlign.center,
        style: SafeGoogleFont(
          GoogleFontsApp().fontMulish,
          fontSize: width * size,
          fontWeight: weight ?? FontWeight.w500,
          color: color ?? ColorsApp().negro,
        ),
        maxLines: maxlines ?? 50,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
