
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EnConstruccionScreen extends StatefulWidget {

  const EnConstruccionScreen(Key? key) : super (key: key);

  @override
  EnConstruccionScreenState createState() => EnConstruccionScreenState();

}

class EnConstruccionScreenState extends State<EnConstruccionScreen>{

  @override
  void initState(){
    super.initState();
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
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>
              [

                Container(
                  color: Colors.transparent,
                  width: sizeScreen.width * 0.85,
                  height: sizeScreen.height * 0.35,
                  child: Image.asset('assets/gifs/PaginaEnEspera.gif'),
                ),
                
                Container(
                  color: Colors.transparent,
                  width: sizeScreen.width,
                  height: 90,
                  child: const Center(
                    child: AutoSizeText (
                      'Lo sentimos',
                      style: TextStyle(color: Colors.orangeAccent, decorationStyle: TextDecorationStyle.solid, fontWeight: FontWeight.bold,),
                      presetFontSizes: [40,38,36,34,32,30,28,26,24,22,20,18],
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                ),

                Container(
                  color: Colors.transparent,
                  width: sizeScreen.width * 0.87,
                  height: sizeScreen.height * 0.22,
                  alignment: Alignment.center,
                  child: RichText(
                    maxLines: 15,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'Página en construcción',
                      style: TextStyle(color: Colors.black, fontSize: 22,),
                      ),
                    )
                  ),

                  Container(
                  color: Colors.transparent,
                  width: sizeScreen.width,
                  height: 90,
                  child: const Center(
                    child: AutoSizeText (
                      'Mantente atento.',
                      style: TextStyle(color: Colors.black, decorationStyle: TextDecorationStyle.solid, fontWeight: FontWeight.bold,),
                      presetFontSizes: [24,22,20,18],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ),

                Center(
                      child: OutlinedButton(
                        onPressed: () {
                          // Acción de cerrar sesión
                          context.pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Container(
                          color: Colors.transparent,
                          width: sizeScreen.width * 0.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.close, color: Colors.black,),
                              SizedBox(width: sizeScreen.width * 0.02,),
                              const Text(
                                'Salir',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
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