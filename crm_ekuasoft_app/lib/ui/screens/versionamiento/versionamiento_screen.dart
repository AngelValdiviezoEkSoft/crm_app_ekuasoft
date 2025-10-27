
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String nombreTienda = '';

class VersionamientoScreen extends StatefulWidget {
 
  const VersionamientoScreen({Key? key}) : super (key: key);

  @override
  VersionamientoScreenState createState() => VersionamientoScreenState();

}

class VersionamientoScreenState extends State<VersionamientoScreen>{

  @override
  void initState(){
    super.initState();
    if(Platform.isAndroid) {
      nombreTienda = 'PlayStore';
    }
    if(Platform.isIOS) {
      nombreTienda = 'AppStore';
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Container(
            width: sizeScreen.width,
            alignment: Alignment.center,
            //color: Colors.white,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/FondoActualizaApp.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>
              [
                Container(
                  color: Colors.transparent,
                  width: sizeScreen.width * 0.85,
                  height: sizeScreen.width * 0.35,
                  child: Image.asset('assets/Enrolito3DEstatico.png'),
                ),

                Container(
                  color: Colors.transparent,
                  width: sizeScreen.width * 0.85,
                  height: sizeScreen.width * 0.25,
                  child: Image.asset('assets/FlechaDescarga.gif'),
                ),
                
                Container(
                  color: Colors.transparent,
                  width: sizeScreen.width * 0.97,
                  height: sizeScreen.height * 0.09,//90,
                  child: const Center(
                    child: AutoSizeText (
                      'Tenemos una nueva versión de nuestro Ecosistema EnrolApp',
                      style: TextStyle(color: Colors.black, decorationStyle: TextDecorationStyle.solid, fontWeight: FontWeight.bold),
                      presetFontSizes: const [22,20,18,16,14,12,10],
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                ),

                Container(
                  color: Colors.transparent,
                  width: sizeScreen.width * 0.95,
                  height: sizeScreen.height * 0.07,//90,
                  alignment: Alignment.topCenter,
                  child: AutoSizeText (
                    'Tu App está desactualizada. Descarga la nueva versión de la $nombreTienda',
                    style: const TextStyle(color: Colors.black),
                    presetFontSizes: const [20,18,16,14,12,10],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),


                Center(
                  child: Container(
                    color: Colors.transparent,
                    width: sizeScreen.width * 0.91,
                    height: sizeScreen.height * 0.07,
                    alignment: Alignment.center,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      disabledColor: Colors.grey,
                      elevation: 10,
                      color: Colors.blueAccent,
                      onPressed: () async {
                        if(Platform.isAndroid) {
                          launchUrl(Uri.parse(CadenaConexion().linkDescargaAplicacionAndroid), mode: LaunchMode.externalApplication);
                        }

                        if(Platform.isIOS) {
                          launchUrl(Uri.parse(CadenaConexion().linkDescargaAplicacionIos), mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: const Center(
                          child: AutoSizeText('Descargar ahora', maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), presetFontSizes: [18,16,14,12,10,8,6,4],)
                        ),
                      ),
                    ),
                  ),
                ),
                


              ]
            ),
          ),
              
        ),
      );
     
  }
}