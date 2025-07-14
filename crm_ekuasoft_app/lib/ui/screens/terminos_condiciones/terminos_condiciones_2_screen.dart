
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsAndConditions2Screen extends StatefulWidget {

  const TermsAndConditions2Screen(Key? key) : super(key: key);

  @override
  TermsAndConditionsScreen2State createState() => TermsAndConditionsScreen2State();
}

class TermsAndConditionsScreen2State extends State<TermsAndConditions2Screen> {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Términos y condiciones"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            Container(
              width: size.width,
              height: size.height * 0.82,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(height: size.height * 0.06,),

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
            
          ],
        ),
      ),
    );
  }
}
