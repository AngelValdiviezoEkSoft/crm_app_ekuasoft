
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';

class ContentAlertDialog extends StatelessWidget {
  const ContentAlertDialog(
      {super.key,
      required this.mensajeAlerta,
      required this.titulo,
      required this.tipoAlerta,
      this.numLineasTitulo,
      this.onPressed,
      this.onPressedCont,
      this.numLineasMensaje,
      this.msmConIcono,
      this.iconoAlerta,
      this.colorIconoAlerta,
      this.mensajeBoton});

  final String titulo;
  final String tipoAlerta;
  final String mensajeAlerta;
  final int? numLineasTitulo;
  final int? numLineasMensaje;
  final bool? msmConIcono;
  final IconData? iconoAlerta;
  final Color? colorIconoAlerta;
  final String? mensajeBoton;
  final VoidCallback? onPressed;
  final VoidCallback? onPressedCont;

  @override
  Widget build(BuildContext context) {
    ColorsApp oColors = ColorsApp();

    final size = MediaQuery.of(context).size;
    Color oColorTpAlert = Colors.transparent;
    Color oColorBackgroundTpAlert = Colors.transparent;
    Color oColorBordesTpAlert = Colors.transparent;
    Color oColorBotonAceptar = Colors.transparent;
    var oTipoAlerta = TipoAlerta();
    num heightTitle = numLineasTitulo ?? 1;
    num heightMessage = numLineasMensaje ?? 1;

    if (tipoAlerta == oTipoAlerta.alertInfo) {
      oColorTpAlert = oColors.naranjaIntenso;
      oColorBackgroundTpAlert = oColors.morado;
      oColorBordesTpAlert = oColors.naranja50PorcTrans;
      oColorBotonAceptar = oColors.naranjaIntenso;
    }
/*
    if (tipoAlerta == oTipoAlerta.alertError) {
      oColorTpAlert = oColors.rojoBordesAlertBackgroundPlux;
      oColorBackgroundTpAlert = oCorpColorsGen.rosadoAlertBackgroundPlux;
      oColorBordesTpAlert = oCorpColorsGen.rojoBordesAlertBackgroundPlux;
      oColorBotonAceptar = oCorpColorsGen.rojoBordesAlertBackgroundPlux;
    }
    */

    if (tipoAlerta == oTipoAlerta.alertAccion) {
      oColorTpAlert = oColors.azulCvs;
      oColorBackgroundTpAlert = oColors.blanco0Opacidad;
      oColorBordesTpAlert = oColors.blanco29Opacidad;
      oColorBotonAceptar = oColors.morado;
    }

    return AlertDialog(
      titlePadding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      backgroundColor: oColorBackgroundTpAlert,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: oColorBordesTpAlert, width: size.width * 0.004),
        borderRadius: BorderRadius.circular(size.width * 0.02)
      ),
      title: 
      msmConIcono == null || msmConIcono == false ?
      Container(
        color: Colors.transparent,
        height: tipoAlerta == oTipoAlerta.alertAccion
            ? heightTitle > 1
                ? size.height * 0.04 * heightTitle
                : size.height * 0.04
            : size.height * 0.03 * heightTitle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tipoAlerta != oTipoAlerta.alertAccion)
                  Icon(
                    Icons.info,
                    color: oColorTpAlert,
                  ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: size.width * 0.5,
                  child: BaseText(
                    null,
                    titulo,                    
                    size: 0.05,
                    color: oColors.negro,
                    weight: FontWeight.w700,
                    align: TextAlign.left,
                    maxlines: 3,
                  ),
                ),
              ],
            ),
            if (tipoAlerta != oTipoAlerta.alertAccion)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  color: oColors.negro,
                ),
              ),
            if (tipoAlerta == oTipoAlerta.alertAccion)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.cancel_outlined,
                  color: oColors.morado,
                ),
              ),
          ],
        ),
      )
      :
      Container(
        color: Colors.transparent,
        height: tipoAlerta == oTipoAlerta.alertAccion
            ? heightTitle > 1
                ? size.height * 0.04 * heightTitle
                : size.height * 0.04
            : size.height * 0.03 * heightTitle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tipoAlerta != oTipoAlerta.alertAccion)
                  Icon(
                    Icons.info,
                    color: oColorTpAlert,
                  ),
                const SizedBox(
                  width: 5,
                ),
                Icon(iconoAlerta!, color: colorIconoAlerta,),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: size.width * 0.5,
                  child: BaseText(
                    null,
                    titulo,                    
                    size: 0.05,
                    color: oColors.negro,
                    weight: FontWeight.w700,
                    align: TextAlign.left,
                    maxlines: 3,
                  ),
                ),
              ],
            ),
            if (tipoAlerta != oTipoAlerta.alertAccion)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  color: oColors.negro,
                ),
              ),
            if (tipoAlerta == oTipoAlerta.alertAccion)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.cancel_outlined,
                  color: oColors.morado,
                ),
              ),
          ],
        ),
      ),
      contentPadding: tipoAlerta == oTipoAlerta.alertAccion
          ? const EdgeInsets.symmetric(horizontal: 10, vertical: 0)
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      content: 
      msmConIcono == null || msmConIcono == false ?
      Container(
        color: Colors.transparent,
        width: tipoAlerta == oTipoAlerta.alertAccion
            ? size.width
            : size.width * 0.9,
        height: tipoAlerta == oTipoAlerta.alertAccion
            ? size.height * 0.055 * heightMessage
            : size.height * 0.06,
        child: BaseText(
          null,
          mensajeAlerta,          
          size: 0.04,
          color: oColors.negro,
          weight: FontWeight.w400,
          align: TextAlign.left,
        ),
      )
      :
      Container(
        color: Colors.transparent,
        width: tipoAlerta == oTipoAlerta.alertAccion
            ? size.width
            : size.width * 0.9,
        height: tipoAlerta == oTipoAlerta.alertAccion
            ? size.height * 0.055 * heightMessage
            : size.height * 0.06,
        child: BaseText(
              null,
              mensajeAlerta,          
              size: 0.04,
              color: oColors.negro,
              weight: FontWeight.w400,
              align: TextAlign.left,
            ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding:
          const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
      actions: [
        if (tipoAlerta != oTipoAlerta.alertAccion)
          TextButton(
            child: BaseText(              
              null,
              'Aceptar',
              size: 0.04,
              color: oColorBotonAceptar,
              align: TextAlign.center,
              weight: FontWeight.w700,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        if (tipoAlerta == oTipoAlerta.alertAccion)
          Container(
            color: Colors.transparent,
            width: size.width * 0.65,
            height: size.height * 0.045,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.transparent,
                  width: size.width * 0.3,
                  height: size.height * 0.15,
                  child: GestureDetector(
                    onTap: () async {
                      if (onPressed != null) {
                        // Si se proporciona onPressed, úsalo
                        onPressed!();
                      }
                    },
                    child: ButtonCvsWidget(
                      text: mensajeBoton != null && mensajeBoton!.isNotEmpty ? mensajeBoton! : 'Continuar',
                      colorBoton: null,
                      textStyle: TextStyle(color: oColors.blanco0Opacidad),
                      onPressed: () {
                        onPressedCont!();
                      },                      
                    ),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
