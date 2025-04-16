import 'package:auto_size_text/auto_size_text.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

String imgBandejaVacia = '';
String msmCabeceraBandejaVacia = '';
String msmGeneralBandejaVacia = '';

class ConsultaVaciaScreen extends StatefulWidget {

  ConsultaVaciaScreen(
    Key? key,
    {    
    String? msmBand,
    String? msmCabBand,
    String? imgCabBand,
  }) : super(key: key) {
    msmGeneralBandejaVacia = msmBand ?? '';
    msmCabeceraBandejaVacia = msmCabBand ?? '';
    imgBandejaVacia = imgCabBand ?? '';
  }

  @override
  ConsultaVaciaScreenState createState() => ConsultaVaciaScreenState();

}

class ConsultaVaciaScreenState extends State<ConsultaVaciaScreen>{

  @override
  void initState(){
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return  MaterialApp(
        
      debugShowCheckedModeBanner: false,
      
      home: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.transparent,//const Color.fromARGB(254, 254, 254, 254),
          body: Center(
            child: Container(
              color: Colors.transparent, 
              width: size.width * 0.95,
              height: size.height * 0.65,
              alignment: Alignment.topCenter,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,                    
                    width: size.width * 0.95,
                    height: size.height * 0.45,
                    child: Image(width: size.width * 0.8, height: size.height * 0.6,
                      image: AssetImage('assets/$imgBandejaVacia'),
                    ),                    
                  ),
                  
                  Container(
                    color: Colors.transparent, 
                    width: size.width * 0.95,
                    height: size.height * 0.08,
                    alignment: Alignment.bottomCenter,//msmCabeceraBandejaVacia
                    //child: const AutoSizeText('Atención', maxLines: 1, presetFontSizes: [28,26,24,22,20,18,16,14,12,10], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontFamily: 'Montserrat'), textAlign: TextAlign.center,),
                    child: AutoSizeText('$msmCabeceraBandejaVacia ', maxLines: 1, presetFontSizes: const [40,38,36,34,32,30,28,26,24,22,20,18,16,14,12,10], style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 254, 90, 0),fontFamily: 'AristotelicaDisplayDemiBoldTrial'), textAlign: TextAlign.center,),
                  ),
                  
                  Container(
                    color: Colors.transparent, 
                    width: size.width * 0.95,
                    height: size.height * 0.1,
                    alignment: Alignment.topCenter,                    
                    child: AutoSizeText('$msmGeneralBandejaVacia ', maxLines: 2, presetFontSizes: const [24,22,20,18,16,14,12,10], style: const TextStyle( color: Colors.black,fontFamily: 'Montserrat'), textAlign: TextAlign.center,),
                  ),
                  
                ],
              ),
              
            ),
          ),
        
        ),
      )
    );
     
  }


}