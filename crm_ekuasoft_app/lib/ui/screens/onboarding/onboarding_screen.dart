import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

TextEditingController nombresOnBrdTxt = TextEditingController();
TextEditingController correoOnBrdTxt = TextEditingController();
TextEditingController passWordOnBrdTxt = TextEditingController();
TextEditingController passWordOnBrdConfTxt = TextEditingController();

class OnBoardingScreen extends StatelessWidget {

  const OnBoardingScreen(Key? key) : super (key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
  
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade600, Colors.white, Colors.white, Colors.white],
              end: Alignment.topRight,
              begin: Alignment.bottomLeft,
            ),
          ),
          child: ChangeNotifierProvider(
                    create: (_) => AuthService(),
                    child: OnBoardScreen(key),
                  )
        ),
      ),
    );
  
  }
}

class OnBoardScreen extends StatelessWidget {
  
const OnBoardScreen(Key? key) : super (key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final authService = Provider.of<AuthService>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          SizedBox(height: size.height * 0.07),//50),
            
          const Icon(Icons.shopping_cart, size: 80, color: Colors.green),
          
          SizedBox(height: size.height * 0.04),
            
          const Text(
            'Para Comenzar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
            
          SizedBox(height: size.height * 0.007),
            
          Text(
            'Utilice el siguiente formulario para comenzar.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          
          SizedBox(height: size.height * 0.06),
            
          Container(
            padding: const EdgeInsets.all(1),  // Espaciado interno
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), // Bordes redondeados
              color: Colors.white
            ),
            child: TextField(
              controller: nombresOnBrdTxt,
              decoration: InputDecoration(                  
                labelText: 'Nombre y apellido',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        
          //SizedBox(height: 20),
          SizedBox(height: size.height * 0.025),
            
          Container(
            padding: const EdgeInsets.all(1),  // Espaciado interno
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), // Bordes redondeados
              color: Colors.white
            ),
            child: TextField(
              controller: correoOnBrdTxt,
              decoration: InputDecoration(                  
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          
          SizedBox(height: size.height * 0.025),
            
          Container(
            padding: const EdgeInsets.all(1),  // Espaciado interno
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), // Bordes redondeados
              color: Colors.white
            ),
            child: TextField(
              obscureText: authService.varIsOscured,
              controller: passWordOnBrdTxt,
              decoration: InputDecoration(                  
                labelText: 'Contraseña',
                suffixIcon: //const Icon(Icons.visibility_off),
                  !authService.varIsOscured
                    ? IconButton(
                        onPressed: () {
                          authService.varIsOscured = !authService.varIsOscured;
                        },
                        icon: Icon(Icons.visibility,
                          size: 24,
                          color: AppLightColors().gray900PrimaryText
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          authService.varIsOscured = !authService.varIsOscured;
                        },
                        icon: Icon(
                          size: 24,
                          Icons.visibility_off,
                          color: AppLightColors().gray900PrimaryText
                        ),
                      ),
                                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          
          SizedBox(height: size.height * 0.025),
        
          Container(
            padding: const EdgeInsets.all(1),  // Espaciado interno
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), // Bordes redondeados
              color: Colors.white
            ),
            child: TextField(
              obscureText: authService.varIsOscuredConf,
              controller: passWordOnBrdConfTxt,
              decoration: InputDecoration(                  
                labelText: 'Repita su contraseña',
                suffixIcon: 
                !authService.varIsOscuredConf
                  ? IconButton(
                      onPressed: () {
                        authService.varIsOscuredConf = !authService.varIsOscuredConf;
                      },
                      icon: Icon(Icons.visibility,
                        size: 24,
                        color: AppLightColors().gray900PrimaryText
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        authService.varIsOscuredConf = !authService.varIsOscuredConf;
                      },
                      icon: Icon(
                        size: 24,
                        Icons.visibility_off,
                        color: AppLightColors().gray900PrimaryText
                      ),
                    ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        
          SizedBox(height: size.height * 0.03),                  
        
          Container(
            color: Colors.transparent,
            width: size.width * 0.9,
            height: size.height * 0.07,
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if(nombresOnBrdTxt.text.isEmpty || correoOnBrdTxt.text.isEmpty 
                  || passWordOnBrdTxt.text.isEmpty 
                  || passWordOnBrdConfTxt.text.isEmpty){
                  
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return ContentAlertDialog(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        onPressedCont: () {
                          Navigator.of(context).pop();
                        },
                        tipoAlerta: TipoAlerta().alertAccion,
                        numLineasTitulo: 1,
                        numLineasMensaje: 1,
                        titulo: 'Error',
                        mensajeAlerta: 'Ingrese los datos solicitados.'
                      );
                    },
                  );

                  return;
                }

                if(passWordOnBrdTxt.text != passWordOnBrdConfTxt.text){
                  
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return ContentAlertDialog(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        onPressedCont: () {
                          Navigator.of(context).pop();
                        },
                        tipoAlerta: TipoAlerta().alertAccion,
                        numLineasTitulo: 1,
                        numLineasMensaje: 1,
                        titulo: 'Error',
                        mensajeAlerta: 'Las contraseñas no coinciden.'
                      );
                    },
                  );

                  return;
                }

                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return ContentAlertDialog(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        onPressedCont: () {
                          Navigator.of(context).pop();
                        },
                        tipoAlerta: TipoAlerta().alertAccion,
                        numLineasTitulo: 1,
                        numLineasMensaje: 1,
                        titulo: 'ÉXITO',
                        mensajeAlerta: 'Usuario creado correctamente.'
                      );
                    },
                  );

                  context.push(objRutasGen.rutaHome);

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25), // Bordes redondeados
                ),
                elevation: 5, // Sombra del botón
              ),
              child: const Text(
                'Crear cuenta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ),
            
          SizedBox(height: size.height * 0.015),
            
          Center(
            child: Text(
              'Usa una plataforma social para continuar',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          
          SizedBox(height: size.height * 0.025),
          
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: const Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.07),//20),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: const Center(
                  child: Icon(
                    Icons.apple,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
            
          SizedBox(height: size.height * 0.07),
        
          Center(
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                '¿Ya tienes una cuenta? Acceder',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          //SizedBox(height: 30),
          SizedBox(height: size.height * 0.01),
        ],
      ),
    );
    
  }
}

