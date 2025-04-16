import 'dart:io';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../infraestructure/services/services.dart';

import 'package:geolocator/geolocator.dart';

String rutaServerWelcome = '';
Rutas objRutasGen = Rutas();
TextEditingController serverTxt = TextEditingController();
TextEditingController keyTxt = TextEditingController();

class WelcomeScreen extends StatelessWidget {

  //final String rutaServerTmp;

  WelcomeScreen(Key? key) : super(key: key)
  {    
    serverTxt.text = rutaServerWelcome;
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
              height: size.height * 1.02,//0.99,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, // Punto de inicio del degradado
                  end: Alignment.bottomRight,
                colors: [Colors.blue.shade600, Colors.white, Colors.white],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChangeNotifierProvider(
                    create: (_) => AuthService(),
                    child: Welcome2Screen(key),
                  ),                  
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class Welcome2Screen extends StatelessWidget {

  const Welcome2Screen(Key? key) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final authService = Provider.of<AuthService>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * 0.007,
        ),
        
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.blue,
          ),
        ),
        
        SizedBox(
          height: size.height * 0.02,
        ),
        
        const Text(
          '¡Bienvenido!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
    
        SizedBox(
          height: size.height * 0.01,
        ),
        
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            '¡Gracias por unirte a la comunidad de D-One! ¡Acceda o cree su cuenta a continuación y comience su viaje!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
    
        SizedBox(height: size.height * 0.02),
    
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: GestureDetector(
          onTap: () {
            //context.push(Rutas().rutaScanQr);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white
            ),                
            child: TextField(
              //enabled: false,
              controller: serverTxt,
              decoration: InputDecoration(
                labelText: 'Servidor',
                suffixIcon: //const Icon(Icons.qr_code_scanner_outlined),
                IconButton(
                  onPressed: () {
                    context.push(Rutas().rutaScanQr);
                  },
                  icon: Icon(Icons.qr_code_scanner_outlined,
                      size: 24,
                      color: AppLightColors()
                          .gray900PrimaryText),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                
              ),
            ),
          ),
        ),
      ),
    
      SizedBox(height: size.height * 0.02),
    
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), // Bordes redondeados
            color: Colors.white                  
          ),                
          child: TextField(
            obscureText: authService.varIsKeyOscured,
            controller: keyTxt,
            decoration: InputDecoration(                  
              labelText: 'Key',
              suffixIcon: //const Icon(Icons.key),
              !authService.varIsKeyOscured
                ? IconButton(
                    onPressed: () {
                      authService.varIsKeyOscured =
                          !authService.varIsKeyOscured;
                    },
                    icon: Icon(Icons.key,
                        size: 24,
                        color: AppLightColors()
                            .gray900PrimaryText),
                  )
                : IconButton(
                    onPressed: () {
                      authService.varIsKeyOscured = !authService.varIsKeyOscured;
                    },
                    icon: Icon(
                        size: 24,
                        Icons.key_off,
                        color: AppLightColors().gray900PrimaryText
                      ),
                  ),                                
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            inputFormatters: [
              EmojiInputFormatter()
            ],
          ),
        ),
      ),
      
      //SizedBox(height: size.height * 0.02),
    
      //const Spacer(),
      SizedBox(
        height: size.height * 0.1,
      ),
    
      const Divider(color: Colors.red,),
        
      SizedBox(
        height: size.height * 0.04,
      ),
    
      // Botón de Comenzar
      Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: GestureDetector(
      onTap: () async {
    
        if(serverTxt.text.isEmpty || keyTxt.text.isEmpty){
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
                numLineasTitulo: 2,
                numLineasMensaje: 2,
                titulo: 'Error',
                mensajeAlerta: 'Ingrese los datos del formulario.'
              );
            },
          );
    
          return;
        }
    
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SimpleDialog(
            alignment: Alignment.center,
            children: [
              SimpleDialogCargando(
                null,
                mensajeMostrar: 'Estamos registrando',
                mensajeMostrarDialogCargando: 'tu dispositivo',
              ),
            ]
          ),
        );
    
        try{
          String imeiCod = '';
          var plataforma = '';
    
          final deviceInfo = DeviceInfoPlugin();
          
          if (Platform.isAndroid) {
            plataforma = 'Android';
            final androidInfo = await deviceInfo.androidInfo;
            imeiCod = androidInfo.id;
          } else if (Platform.isIOS) {
            plataforma = 'iOS';
            final iOSInfo = await deviceInfo.iosInfo;
            imeiCod = iOSInfo.identifierForVendor ?? '';                    
          } else {
            plataforma = 'Desconocido';
          }
    
          Position position = await getLocation();
    
          imeiCod = '823456040001'; //BORRAR LUEGO - PARA EMULADOR
          //imeiCod = '82345604000002Luis'; //BORRAR LUEGO - PARA CELULAR PRUEBAS
          //imeiCod = '82345604113'; //BORRAR LUEGO - PARA EMULADOR
    
          RegisterMobileRequestModel objRegisterMobileRequestModel = RegisterMobileRequestModel(
            server: serverTxt.text,
            key: keyTxt.text,
            imei: imeiCod,
            lat: position.latitude.toString(),//'-74.45445',
            lon: position.longitude.toString(),//'72.74548487',
            so: plataforma//'Android'
          );
    
          RegisterDeviceResponseModel respuesta = await AuthService().doneRegister(objRegisterMobileRequestModel);
          
          //ignore: use_build_context_synchronously
          context.pop();
    
          if(respuesta.result.estado == 200){
            rutaServerWelcome = '';
            //ignore: use_build_context_synchronously
            context.push(objRutasGen.rutaDefault);
          }
          else{
            showDialog(
              barrierDismissible: false,
              //ignore: use_build_context_synchronously
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
                  numLineasTitulo: 2,
                  numLineasMensaje: 4,
                  titulo: 'Error',
                  mensajeAlerta: respuesta.result.msmError
                );
              },
            );
          }
        }
        catch(ex){
          //ignore: use_build_context_synchronously
          context.pop();
        
          showDialog(
              barrierDismissible: false,
              //ignore: use_build_context_synchronously
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
                  numLineasTitulo: 2,
                  numLineasMensaje: 4,
                  titulo: 'Error',
                  mensajeAlerta: ex.toString()
                );
              },
            );
          
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF536DFE), // Color del botón
          borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // Sombra bajo el botón
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Espaciado interno del botón
          child: const Text(
            'Comenzar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
          ),
        ),
      
      ],
    );
  }

  
  Future<Position> getCurrentLocation() async 
   {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están desactivados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación fueron denegados');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Los permisos de ubicación están denegados permanentemente.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Si no está habilitado, puedes mostrar un mensaje o pedirle al usuario que lo active
      return Future.error('Los servicios de ubicación están desactivados.');
    }

    // Verifica si la aplicación tiene permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Si el usuario niega el permiso, muestra un mensaje
        return Future.error('Los permisos de ubicación fueron denegados');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados de forma permanente
      return Future.error('Los permisos de ubicación están denegados permanentemente.');
    }

    // Si tienes los permisos necesarios, obtiene la posición actual
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }



}