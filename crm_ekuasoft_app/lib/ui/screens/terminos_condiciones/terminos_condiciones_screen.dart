import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class TermsAndConditionsScreen extends StatefulWidget {

  const TermsAndConditionsScreen(Key? key) : super(key: key);

  @override
  _TermsAndConditionsScreenState createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.72,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.13,
                      color: Colors.transparent,
                      child: const Text('Bienvenido a nuestra aplicación. Por favor, lee atentamente los siguientes términos y condiciones antes de utilizar nuestros servicios.',
                        style: TextStyle(fontSize: 16,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.11,
                      color: Colors.transparent,
                      child: const Text('1. Aceptación de los términos. Al acceder y utilizar esta aplicación, aceptas cumplir y estar sujeto a estos términos y condiciones.',
                        style: TextStyle(fontSize: 16,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    /*
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.2,
                      color: Colors.transparent,
                      child: const Text(
                        '''
                                        Bienvenido a nuestra aplicación. Por favor, lee atentamente los siguientes términos y condiciones antes de utilizar nuestros servicios.
                      
                                        1. Aceptación de los términos
                                        Al acceder y utilizar esta aplicación, aceptas cumplir y estar sujeto a estos términos y condiciones.
                      
                                        2. Uso permitido
                                        Esta aplicación está destinada únicamente para uso personal y no comercial.
                      
                                        3. Propiedad intelectual
                                        Todo el contenido de esta aplicación, incluyendo textos, imágenes y logotipos, es propiedad de la empresa.
                      
                                        4. Limitación de responsabilidad
                                        No nos hacemos responsables de posibles daños derivados del uso de esta aplicación.
                      
                                        5. Cambios en los términos
                                        Nos reservamos el derecho de modificar estos términos en cualquier momento.
                      
                                        Gracias por confiar en nosotros.
                                        ''',
                        style: TextStyle(fontSize: 16,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    */
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.11,
                      color: Colors.transparent,
                      child: const Text(
                        ' 2. Uso permitido. Esta aplicación está destinada únicamente para uso personal y no comercial.',
                        style: TextStyle(fontSize: 16,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.11,
                      color: Colors.transparent,
                      child: const Text(
                        '3. Propiedad intelectual. Todo el contenido de esta aplicación, incluyendo textos, imágenes y logotipos, es propiedad de la empresa.',
                        style: TextStyle(fontSize: 16,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.11,
                      color: Colors.transparent,
                      child: const Text(
                        '4. Limitación de responsabilidad. No nos hacemos responsables de posibles daños derivados del uso de esta aplicación.',
                        style: TextStyle(fontSize: 16,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.11,
                      color: Colors.transparent,
                      child: const Text(
                        '5. Cambios en los términos. Nos reservamos el derecho de modificar estos términos en cualquier momento.',
                        style: TextStyle(fontSize: 16,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.05,
                      color: Colors.transparent,
                      child: const Text(
                        'Gracias por confiar en nosotros.',
                        style: TextStyle(fontSize: 16,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.002,),
            CheckboxListTile(
              title: const Text("Acepto términos y condiciones"),
              value: _accepted,
              onChanged: (bool? value) async {
                const stgTermCond = FlutterSecureStorage();
                
                await stgTermCond.write(key: 'AceptaTermCond', value: "$value");
                
                setState(() {
                  _accepted = value ?? false;                  
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            SizedBox(height: size.height * 0.003),
            ElevatedButton(
              onPressed: _accepted
                  ? () {
                      context.push(objRutasGen.rutaDefault);
                    }
                  : null, // Desactivado si no se acepta
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
