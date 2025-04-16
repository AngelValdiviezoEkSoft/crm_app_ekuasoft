 
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class SimpleDialogCargando extends StatelessWidget {
  
  String mensajeMostrar = '';
  String mensajeMostrarDialogCargando = '';
  String varMensajeMostrar = '';
  String varMensajeMostrar2 = '';

  SimpleDialogCargando(Key? key, {required mensajeMostrar, required mensajeMostrarDialogCargando}) : super(key: key) {
    varMensajeMostrar = mensajeMostrar;
    varMensajeMostrar2 = mensajeMostrarDialogCargando;
  }
  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    
    return SimpleDialogOption(
      onPressed: (){},
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.3,
        color: Colors.transparent,
        child: Column(
          children: [
            Image.asset(
              "assets/gifs/gif_carga.gif",
              width: size.width * 0.69,
              height: size.height * 0.11,
            ),

            const SizedBox(height: 20,),
            const Text("Por favor espera.", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontFamily: 'Montserrat',fontSize: 14, fontWeight: FontWeight.bold),),

            Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    child: AutoSizeText(varMensajeMostrar, style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold), presetFontSizes: const [14,12,10,8],maxLines: 2,)
                  ),
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: AutoSizeText(varMensajeMostrar2, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold), presetFontSizes: const [14,12,10,8],maxLines: 2,)
                  ),
                ],
              ),
            ),              
                            
          ],
        )
      ),
    );
  }
}

