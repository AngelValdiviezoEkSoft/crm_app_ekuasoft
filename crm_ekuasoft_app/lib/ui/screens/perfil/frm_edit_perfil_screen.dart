import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:crm_ekuasoft_app/infraestructure/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:provider/provider.dart';

int tabAccEdit = 0;
DateTime datRegPrs = DateTime.now();
String rutaNuevaFotoPerfil = '';
MemoryImage? nuevaFotoPerfilGen;
String primerNombre = "";
bool validandoFoto = false;
bool tieneMayuscula = false;
  bool tieneMinuscula = false;
  bool tieneNumero = false;
  bool tieneCaracterEspecial = false;
  bool tieneDiezCaracteres = false;
  bool hideIcon = false;
  bool nivelBajo = false;
  bool nivelIntermedioBajoMedioCuartaParte = false;
  bool nivelIntermedioBajoMedio = false;
  bool nivelMedio = false;
  bool nivelIntermedioMedioAlto = false;
  bool nivelAlto = false;
  bool verValidaciones = false;
  
Color coloresTextoRepuesta = Colors.transparent;
Color coloresFondoRepuesta = Colors.transparent;

late TextEditingController passwordAntTxt;
late TextEditingController passwordTxt;
late TextEditingController passwordConfTxt;

String emailUser = '';

class FrmEditPerfilScreen extends StatefulWidget {
  const FrmEditPerfilScreen({super.key});

  @override
  State<FrmEditPerfilScreen> createState() => _FrmEditPerfilScreenState();
}

class _FrmEditPerfilScreenState extends State<FrmEditPerfilScreen> {

  final LocalAuthentication auth = LocalAuthentication();  
  
  @override
  void initState() {
    super.initState();

    passwordAntTxt = TextEditingController();
    passwordTxt = TextEditingController();
    passwordConfTxt = TextEditingController();

  }

  
  Future<void> llenaFotoPerfil() async {
    if(nuevaFotoPerfilGen != null) {
      Uint8List bodyBytes = nuevaFotoPerfilGen!.bytes;
      final objFoto = await File(rutaFotoPerfil).writeAsBytes(bodyBytes);

      //print('Bytes vista: $bodyBytes');
      
      //final bytes = File(objFoto.path).readAsBytesSync();
      //String fotoTmp = base64Encode(bytes);

      //print('Base 64 de la foto: $fotoTmp');

      primerNombre = "Angel";//objPrspValido?.nombres.split(' ')[0] ?? '';
      
      rutaNuevaFotoPerfil = objFoto.path;
      /*
      FotoPerfilModel objFotoPerfilNueva = FotoPerfilModel(
        base64: fotoTmp,
        extension: rutaFotoPerfil.split('.')[rutaFotoPerfil.split('.').length - 1],//'png',
        nombre: 'foto_perfil_$primerNombre'
      );
      */
      
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {

    final planAct = BlocProvider.of<GenericBloc>(context);

    ColorsApp objColorsApp = ColorsApp();

    //ScrollController scrollListaClt = ScrollController();

    final size = MediaQuery.of(context).size;

    onPassWordChanged(String password) {
      final numericRegex = RegExp(r'[0-9]');
      final mayusculaRegex = RegExp(r'[A-Z]');
      final minusculaRegex = RegExp(r'[a-z]');
      final caracterEspecialRegex = RegExp(r'[\u0021-\u002b\u003c-\u0040]');

      if (numericRegex.hasMatch(password)) {
        tieneNumero = true;
      } else {
        tieneNumero = false;
      }

      if (mayusculaRegex.hasMatch(password)) {
        tieneMayuscula = true;
      } else {
        tieneMayuscula = false;
      }

      if (minusculaRegex.hasMatch(password)) {
        tieneMinuscula = true;
      } else {
        tieneMinuscula = false;
      }

      if (caracterEspecialRegex.hasMatch(password)) {
        tieneCaracterEspecial = true;
      } else {
        tieneCaracterEspecial = false;
      }

      if (password == '') {
        tieneNumero = false;
        tieneMayuscula = false;
        tieneMinuscula = false;
        tieneCaracterEspecial = false;
        nivelBajo = false;
        nivelMedio = false;
        nivelAlto = false;
        nivelIntermedioBajoMedio = false;
        nivelIntermedioMedioAlto = false;
        tieneDiezCaracteres = false;
      } else {
        if (password.length <= 8) {
          tieneDiezCaracteres = false;
          if (password.length >= 7 && password.length < 9) {
            nivelIntermedioBajoMedio = true;
          } else {
            nivelIntermedioBajoMedio = false;
          }
          nivelBajo = true;
          nivelMedio = false;
          nivelAlto = false;
        } else {
          if (password.length >= 9 && password.length <= 13) {
            tieneDiezCaracteres = false;
            if (password.length >= 10 && password.length < 14) {
              nivelIntermedioMedioAlto = true;
              tieneDiezCaracteres = true;
            } else {
              nivelIntermedioMedioAlto = false;
            }
            nivelMedio = true;
            nivelAlto = false;
          } else {
            if (password.length >= 14 && password.length <= 20) {
              nivelAlto = true;
            }
          }
        }
      }

      setState(() {});
    }

    final authService = Provider.of<AuthService>(context);

    final regularExp = CvsRegExp();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('Editar Perfil'),
      ),
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {
 
          return FutureBuilder(
          future: state.readDatosPerfil(),
          builder: (context, snapshot) {

            String nombresCompletos = '';
            String user = '';
            String uid = '';

            if(!snapshot.hasData) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Image.asset(
                    "assets/gifs/gif_carga.gif",
                    height: size.width * 0.85,//150.0,
                    width: size.width * 0.85,//150.0,
                  ),
                ),
              );
            } 

            if(snapshot.hasData) {
              
              String rspData = snapshot.data as String;

              final data = json.decode(rspData);

              nombresCompletos = data["result"]["name"];
              user = data["result"]["username"];
              uid = data["result"]["uid"].toString();
              //emailUser = data["result"]["uid"].toString();
            }

              return Container(
                color: Colors.transparent,
                width: size.width,
                //height: size.height * 1.5,
                height: tabAccEdit == 0 ? size.height * 1.5 : size.height * 1.85,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
              
                      Container(
                        color: Colors.blue.shade800,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    color: tabAccEdit == 0
                                        ? Colors.white
                                        : Colors.blue.shade800,
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {
                                          tabAccEdit = 0;
                                          setState(() {});
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: tabAccEdit == 0
                                                  ? Colors.blue.shade800
                                                  : Colors.white,
                                            ),
                                            Text(
                                              'Datos Personales',
                                              style: TextStyle(
                                                color: tabAccEdit == 0
                                                    ? Colors.blue.shade800
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: tabAccEdit == 1
                                        ? Colors.white
                                        : Colors.blue.shade800,
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {
                                          tabAccEdit = 1;
                                          setState(() {});
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.grid_on_outlined,
                                              color: tabAccEdit == 1
                                                  ? Colors.blue.shade800
                                                  : Colors.white,
                                            ),
                                            Text(
                                              'Contraseña',
                                              style: TextStyle(
                                                //color: Colors.purple.shade700,
                                                color: tabAccEdit == 1
                                                    ? Colors.blue.shade800
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              
                              ],
                            ),
                          ],
                        ),
                      ),
              
                      Container(
                        color: Colors.transparent,
                        //height: size.height * 0.95,
                        height: tabAccEdit == 0 ? size.height * 0.84 : size.height * 0.83,
                        child: Column(
                          children: [
                                        
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                                        
                            if(rutaNuevaFotoPerfil == '' && tabAccEdit == 0)
                            Container(
                              color: Colors.transparent,
                              height: size.height * 0.18,
                              width: size.width * 0.33,
                              child: GestureDetector(
                                onTap: () async {
                                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                                        
                                  try {
                                    if (pickedFile != null) {
                                      final croppedFile = await ImageCropper().cropImage(
                                        sourcePath: pickedFile.path,
                                        compressFormat: ImageCompressFormat.png,
                                        compressQuality: 100,
                                        /*
                                        uiSettings: [
                                          AndroidUiSettings(
                                            hideBottomControls: true,
                                            toolbarTitle: 'Recortando',
                                            toolbarColor: Colors.deepOrange,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio: CropAspectRatioPreset.square,
                                            lockAspectRatio: false
                                          ),
                                          IOSUiSettings(
                                            title: 'Recortando',
                                          ),
                                          //ignore: use_build_context_synchronously
                                          WebUiSettings(
                                            context: context,
                                          ),
                                        ],
                                        */
                                      );
                                      if (croppedFile != null) {
                                        /*
                                        final bytes = File(croppedFile.path).readAsBytesSync();
                                        String img64 = base64Encode(bytes);
                                        
                                        FotoPerfilModel objFotoPerfilNueva = FotoPerfilModel(
                                          base64: img64,
                                          extension: 'png',
                                          nombre: 'foto_perfil_$primerNombre'
                                        );
                                        */
                        
                                        rutaNuevaFotoPerfil = croppedFile.path;
                                        
                                        validandoFoto = false;
                                        
                                        setState(() {});
                                      
                                      }
                                    }
                                  } catch(_) {
                                    
                                  }
                                },
                                child: AvatarGlow(
                                  animate: true,
                                  repeat: true,
                                  //glow
                                  //showTwoGlows: false,
                                  glowColor: Colors.orangeAccent,
                                  glowRadiusFactor: size.width * 0.16,
                                  //endRadius: size.width * 0.16,
                                  child: !validandoFoto ? 
                                    Image.asset(
                                      'assets/images/btnAgregarFotoPerfil.png',
                                      height: size.height * 0.35,
                                    )
                                    :
                                    SpinKitFadingCircle(
                                      size: 35,
                                      itemBuilder: (BuildContext context, int index) {
                                        return DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: index.isEven
                                              ? Colors.black12
                                              : Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                ),
                              ),
                            ),
                                          
                            if(rutaNuevaFotoPerfil != '' && tabAccEdit == 0)
                            Container(
                              height: size.height * 0.165,
                              width: size.width * 0.33,
                              decoration: !validandoFoto ? 
                              BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(rutaNuevaFotoPerfil)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(size.width * 0.2),
                                border: Border.all(
                                  width: 3,
                                  color: objColorsApp.naranja50PorcTrans,
                                  style: BorderStyle.solid,
                                ),
                              )
                              :
                              BoxDecoration(
                                borderRadius: BorderRadius.circular(size.width * 0.2),
                                border: Border.all(
                                  width: 3,
                                  color: objColorsApp.naranja50PorcTrans,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                              
                                  try {
                                    if (pickedFile != null) {
                                      final croppedFile = await ImageCropper().cropImage(
                                        
                                        sourcePath: pickedFile.path,
                                        compressFormat: ImageCompressFormat.png,
                                        compressQuality: 100,
                                        /*
                                        uiSettings: [
                                          AndroidUiSettings(
                                            hideBottomControls: true,
                                            toolbarTitle: 'Recortando',
                                            toolbarColor: Colors.deepOrange,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio: CropAspectRatioPreset.square,
                                            lockAspectRatio: false
                                          ),
                                          IOSUiSettings(
                                            title: 'Recortando',
                                          ),
                                          //ignore: use_build_context_synchronously
                                          WebUiSettings(
                                            context: context,
                                          ),
                                        ],
                                        */
                                      );
                                      if (croppedFile != null) {
                                        /*
                                        final bytes = File(croppedFile.path).readAsBytesSync();
                                        String img64 = base64Encode(bytes);
                                        
                              
                                        FotoPerfilModel objFotoPerfilNueva = FotoPerfilModel(
                                          base64: img64,
                                          extension: 'png',
                                          nombre: 'foto_perfil_$primerNombre'
                                        );
                                        */
                              
                                        validandoFoto = false;
                        
                                        rutaNuevaFotoPerfil = croppedFile.path;
                              
                                        setState(() {});
                                        /*
                              
                                        ClientTypeResponse objRspValidacionFoto = await UserFormService().verificacionFotoPerfil(null,objFotoPerfilNueva);
                              
                                        if(objRspValidacionFoto.succeeded) {
                                          coloresTextoRepuesta = Colors.white;
                                          coloresFondoRepuesta = Colors.green;
                                        } else {
                                          coloresTextoRepuesta = Colors.white;
                                          coloresFondoRepuesta = Colors.red;
                                        }
                              
                                        Fluttertoast.showToast(
                                          msg: !objRspValidacionFoto.succeeded ? 'Debe colocar su rostro para la foto de perfil.' : objRspValidacionFoto.message,
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: coloresFondoRepuesta,
                                          textColor: coloresTextoRepuesta,
                                          fontSize: 16.0
                                        );
                              
                                        if(!objRspValidacionFoto.succeeded) {
                                          validandoFoto = false;
                                          setState(() {});
                                          return;
                                        }
                                        
                                        rutaNuevaFotoPerfil = croppedFile.path;
                              
                                        //varObjetoProspectoFunc!.imagenPerfil = objFotoPerfilNueva;
                                        //varObjProspecto!.imagenPerfil = objFotoPerfilNueva;
                                        
                                        validandoFoto = false;
                                        setState(() {});
                                        */
                                      }
                                    }
                                  } catch(_) {
                                    
                                  }
                                },
                                child: validandoFoto ? SpinKitFadingCircle(
                                  size: 35,
                                  itemBuilder: (BuildContext context, int index) {
                                    return DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: index.isEven
                                          ? Colors.black12
                                          : Colors.white,
                                      ),
                                    );
                                  },
                                )
                                :
                                null
                              )
                            ),
                                  
                            if(tabAccEdit == 0)
                            Container(
                              color: Colors.transparent,
                              width: size.width,
                              height: size.height * 0.65,
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                      
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: const AutoSizeText(
                                      'Nombres',
                                      presetFontSizes: [18,16,14,12,10,8,6],
                                      maxLines: 2,
                                      minFontSize: 4,
                                    ),
                                  ),

                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: AutoSizeText(
                                      nombresCompletos,
                                      maxLines: 2,
                                      minFontSize: 4,
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),

                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: const AutoSizeText(
                                      'Usuario',
                                      presetFontSizes: [18,16,14,12,10,8,6],
                                      maxLines: 2,
                                      minFontSize: 4,
                                    ),
                                  ),

                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: AutoSizeText(
                                      user,
                                      maxLines: 2,
                                      minFontSize: 4,
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),

                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: const AutoSizeText(
                                      'UID',
                                      presetFontSizes: [18,16,14,12,10,8,6],
                                      maxLines: 2,
                                      minFontSize: 4,
                                    ),
                                  ),

                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: AutoSizeText(
                                      uid,
                                      maxLines: 2,
                                      minFontSize: 4,
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                              
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                    
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: TextFormField(
                                      initialValue: emailUser,
                                      //initialValue: '',
                                      //enabled: false,
                                      cursorColor: AppLightColors().primary,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      inputFormatters: [
                                        EmojiInputFormatter()
                                      ],
                                      style: AppTextStyles.bodyRegular(width: size.width),
                                      decoration: InputDecorationCvs.formsDecoration(
                                        labelText: 'Correo electrónico',
                                        hintTetx: 'ejemplo@gmail.com',
                                        size: size
                                      ),
                                      //controller: emailAkiTxt,
                                      autocorrect: false,
                                      keyboardType: TextInputType.emailAddress,
                                      minLines: 1,
                                      maxLines: 2,
                                      autofocus: false,
                                      maxLength: 50,
                                      textAlign: TextAlign.left,
                                      onTap: () {
                                        planAct.setHeightModalPlanAct(0.65);
                                      },
                                      onEditingComplete: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      onChanged: (value) {
                                        
                                      },
                                      onTapOutside: (event) {
                                        planAct.setHeightModalPlanAct(0.11);
                                        FocusScope.of(context).unfocus();
                                      },
                                      validator: (value) {                                              
                                        String pattern = regularExp.regexToEmail;
                                        RegExp regExp = RegExp(pattern);
                                        return regExp.hasMatch(value ?? '')
                                            ? null
                                            : '¡El valor ingresado no luce como un correo!';                                                  
                                      },
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: size.height * 0.17,//0.11,
                                  ),
                              
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: size.width * 0.45,
                                          color: Colors.transparent,
                                          child: GestureDetector(
                                          onTap: () async {
                                            //context.push(Rutas().rutaHome);
                                            context.pop();
                                          },
                                          child: ButtonCvsWidget(
                                            text: 'Cancelar',
                                            textStyle: AppTextStyles.h3Bold(
                                              width: size.width,
                                              color: AppLightColors().white
                                            ),
                                          )
                                        ),
                                      ),

                                        Container(
                                          width: size.width * 0.45,
                                          color: Colors.transparent,
                                          child: GestureDetector(
                                          onTap: () async {
                                    
                                            if(tabAccEdit == 1){
                                              if(passwordAntTxt.text.isEmpty){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Ingrese su contraseña actual'),
                                                      
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            // Acción para solicitar revisión
                                                            //Navigator.of(context).pop();
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                      
                                                return;
                                              }
                                      
                                              if(passwordTxt.text != passwordConfTxt.text){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Las contraseñas deben coincidir'),
                                                      
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            // Acción para solicitar revisión
                                                            //Navigator.of(context).pop();
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                      
                                                return;
                                              }
                                            }

                                            Navigator.of(context).pop();
                                            
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Datos actualizados correctamente'),
                                                  
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        // Acción para solicitar revisión
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: ButtonCvsWidget(                            
                                            //text: 'Guardar Cambios',
                                            text: 'Actualizar',
                                            textStyle: AppTextStyles.h3Bold(
                                                width: size.width,
                                                color: AppLightColors().white),
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: size.height * 0.02,//0.11,
                                  ),
                                                            
                                ],
                              ),
                                  
                            ),

                            if(tabAccEdit == 1)
                            Container(
                              color: Colors.transparent,
                              width: size.width,
                              height: size.height * 0.82,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  
                                  Container(
                                    width: size.width * 0.97,
                                    padding: const EdgeInsets.all(10),  // Espaciado interno
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50), // Bordes redondeados
                                      color: Colors.white
                                    ),
                                    child: TextField(
                                      controller: passwordAntTxt,
                                      obscureText: authService.varIsOscured,
                                      inputFormatters: [
                                        EmojiInputFormatter()
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña Actual',
                                        suffixIcon: //Icon(Icons.visibility),
                                        !authService.varIsOscured
                                          ? IconButton(
                                              onPressed: () {
                                                authService.varIsOscured =
                                                    !authService.varIsOscured;
                                              },
                                              icon: Icon(Icons.visibility,
                                                  size: 24,
                                                  color: AppLightColors()
                                                      .gray900PrimaryText),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                authService.varIsOscured =
                                                    !authService.varIsOscured;
                                              },
                                              icon: Icon(
                                                  size: 24,
                                                  Icons.visibility_off,
                                                  color: AppLightColors()
                                                      .gray900PrimaryText),
                                            ),
                                                  
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        /*
                                        setState(() {
                                            verValidaciones = true;
                                            
                                          });
                                        onPassWordChanged(value.toString());
                                        */
                                      },
                                      onTap: () {
                                        
                                      },
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                                  
                                        setState(() {
                                            //verValidaciones = true;
                                            
                                          });
                                      },
                                    ),
                                  ),
                                                  
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                                  
                                  Container(
                                    width: size.width * 0.97,
                                    padding: const EdgeInsets.all(16),  // Espaciado interno
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50), // Bordes redondeados
                                      color: Colors.white
                                    ),
                                    child: TextField(
                                      controller: passwordTxt,
                                      obscureText: authService.varIsOscuredConfNew,
                                      inputFormatters: [
                                        EmojiInputFormatter()
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña Nueva',
                                        suffixIcon: //Icon(Icons.visibility),
                                        !authService.varIsOscuredConfNew
                                          ? IconButton(
                                              onPressed: () {
                                                authService.varIsOscuredConfNew =
                                                    !authService.varIsOscuredConfNew;
                                              },
                                              icon: Icon(Icons.visibility,
                                                  size: 24,
                                                  color: AppLightColors()
                                                      .gray900PrimaryText),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                authService.varIsOscuredConfNew =
                                                    !authService.varIsOscuredConfNew;
                                              },
                                              icon: Icon(
                                                  size: 24,
                                                  Icons.visibility_off,
                                                  color: AppLightColors()
                                                      .gray900PrimaryText),
                                            ),
                                                  
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                            verValidaciones = true;
                                            
                                          });
                                        onPassWordChanged(value.toString());
                                      },
                                      onTap: () {
                                        setState(() {
                                            verValidaciones = true;
                                            
                                          });
                                      },
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                                  
                                        setState(() {
                                            verValidaciones = true;
                                            
                                          });
                                      },
                                    ),
                                  ),
                                                  
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                                  
                                  if (verValidaciones)
                                  Container(
                                      color: Colors.transparent,
                                      width: size.width * 0.8,
                                      //height: size.height * 0.21,
                                      height: size.height * 0.27,
                                      child: Column(
                                        children: [
                                          const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Tu contraseña debe contener mínimo',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                                
                                          Container(
                                            color: Colors.transparent,
                                            width: size.width * 0.8, //- 75,
                                            height: size.height * 0.2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  children: [
                                                    AnimatedContainer(
                                                      duration: const Duration(milliseconds: 500),
                                                      width: 16,
                                                      height: 16,
                                                      decoration:
                                                          BoxDecoration(
                                                        color:
                                                            tieneMayuscula
                                                                ? Colors.green
                                                                : Colors.red,
                                                        border: tieneMayuscula
                                                            ? Border.all(
                                                                color: Colors
                                                                    .transparent)
                                                            : Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    40),
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                        tieneMayuscula
                                                            ? Icons.check
                                                            : Icons.close,
                                                        color: Colors.white,
                                                        size: 12,
                                                      )),
                                                    ),
                                                    Text(
                                                      '  Una mayúscula',
                                                      style: TextStyle(
                                                          color:
                                                              !tieneMayuscula
                                                                  ? Colors.red
                                                                  : Colors.green,
                                                          //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                          fontSize: 11
                                                        ),
                                                    ),
                                                  ],
                                                ),
                                                /*
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                */
                                                Row(
                                                  children: [
                                                    AnimatedContainer(
                                                      duration: const Duration(milliseconds: 500),
                                                      width: 16,
                                                      height: 16,
                                                      decoration:
                                                          BoxDecoration(
                                                        color:
                                                            tieneMinuscula
                                                                ? Colors
                                                                    .green
                                                                : Colors
                                                                    .red,
                                                        border: tieneMinuscula
                                                            ? Border.all(
                                                                color: Colors
                                                                    .transparent)
                                                            : Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    40),
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                        tieneMinuscula
                                                            ? Icons.check
                                                            : Icons.close,
                                                        color: Colors.white,
                                                        size: 12,
                                                      )),
                                                    ),
                                                    Text(
                                                      '  Una minúscula',
                                                      style: TextStyle(
                                                          color:
                                                              !tieneMinuscula
                                                                  ? Colors
                                                                      .red
                                                                  : Colors
                                                                      .green,
                                                          //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                                /*
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                */
                                                Row(
                                                  children: [
                                                    AnimatedContainer(
                                                      duration:
                                                          const Duration(
                                                              milliseconds:
                                                                  500),
                                                      width: 16,
                                                      height: 16,
                                                      decoration:
                                                          BoxDecoration(
                                                        color: tieneNumero
                                                            ? Colors.green
                                                            : Colors.red,
                                                        border: tieneNumero
                                                            ? Border.all(
                                                                color: Colors
                                                                    .transparent)
                                                            : Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    40),
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                        tieneNumero
                                                            ? Icons.check
                                                            : Icons.close,
                                                        color: Colors.white,
                                                        size: 12,
                                                      )),
                                                    ),
                                                    Text(
                                                      '  Un número',
                                                      style: TextStyle(
                                                          color: !tieneNumero
                                                              ? Colors.red
                                                              : Colors
                                                                  .green,
                                                          //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                                /*
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                */
                                                Row(
                                                  children: [
                                                    AnimatedContainer(
                                                      duration:
                                                          const Duration(
                                                              milliseconds:
                                                                  500),
                                                      width: 16,
                                                      height: 16,
                                                      decoration:
                                                          BoxDecoration(
                                                        color:
                                                            tieneCaracterEspecial
                                                                ? Colors
                                                                    .green
                                                                : Colors
                                                                    .red,
                                                        border: tieneCaracterEspecial
                                                            ? Border.all(
                                                                color: Colors
                                                                    .transparent)
                                                            : Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    40),
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                        tieneCaracterEspecial
                                                            ? Icons.check
                                                            : Icons.close,
                                                        color: Colors.white,
                                                        size: 12,
                                                      )),
                                                    ),
                                                    Text(
                                                      '  Un caracter especial',
                                                      style: TextStyle(
                                                          color:
                                                              !tieneCaracterEspecial
                                                                  ? Colors
                                                                      .red
                                                                  : Colors
                                                                      .green,
                                                          //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                                
                                                Row(
                                                  children: [
                                                    AnimatedContainer(
                                                      duration: const Duration(milliseconds: 500),
                                                      width: 16,
                                                      height: 16,
                                                      decoration:
                                                          BoxDecoration(
                                                        color: tieneDiezCaracteres
                                                                ? Colors
                                                                    .green
                                                                : Colors
                                                                    .red,
                                                        border: tieneDiezCaracteres
                                                            ? Border.all(
                                                                color: Colors
                                                                    .transparent)
                                                            : Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    40),
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                        tieneDiezCaracteres
                                                            ? Icons.check
                                                            : Icons.close,
                                                        color: Colors.white,
                                                        size: 12,
                                                      )),
                                                    ),
                                                    Text(
                                                      '  Mínimo 10 caracteres',
                                                      style: TextStyle(
                                                          color:
                                                              !tieneDiezCaracteres
                                                                  ? Colors.red
                                                                  : Colors.green,
                                                          //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        
                                        ],
                                      ),
                                    ),
                                  
                                  if (verValidaciones)
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                            
                                  Container(
                                      width: size.width * 0.97,
                                    padding: const EdgeInsets.all(16),  // Espaciado interno
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50), // Bordes redondeados
                                      color: Colors.white
                                    ),
                                    child: TextField(
                                      controller: passwordConfTxt,
                                      obscureText: authService.isOscuredConf,
                                      inputFormatters: [
                                        EmojiInputFormatter()
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Confirme su Contraseña',
                                        suffixIcon: //Icon(Icons.visibility),
                                        !authService.isOscuredConf
                                          ? IconButton(
                                              onPressed: () {
                                                authService.isOscuredConf =
                                                    !authService.isOscuredConf;
                                              },
                                              icon: Icon(Icons.visibility,
                                                  size: 24,
                                                  color: AppLightColors()
                                                      .gray900PrimaryText),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                authService.isOscuredConf =
                                                    !authService.isOscuredConf;
                                              },
                                              icon: Icon(
                                                  size: 24,
                                                  Icons.visibility_off,
                                                  color: AppLightColors()
                                                      .gray900PrimaryText),
                                            ),
                                                  
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        /*
                                        setState(() {
                                            verValidaciones = true;
                                            
                                          });
                                        onPassWordChanged(value.toString());
                                        */
                                      },
                                      onTap: () {
                              
                                      },
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                                  
                                        setState(() {
                                            //verValidaciones = true;
                                            
                                          });
                                      },
                                    ),
                                  ),
                                     
                                  SizedBox(
                                    height: size.height * 0.06,
                                  ),
                              
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: size.width * 0.45,
                                          color: Colors.transparent,
                                          child: GestureDetector(
                                          onTap: () async {
                                            //context.push(Rutas().rutaHome);
                                            context.pop();
                                          },
                                          child: ButtonCvsWidget(
                                            text: 'Cancelar',
                                            textStyle: AppTextStyles.h3Bold(
                                              width: size.width,
                                              color: AppLightColors().white
                                            ),
                                          )
                                        ),
                                      ),

                                        Container(
                                          width: size.width * 0.45,
                                          color: Colors.transparent,
                                          child: GestureDetector(
                                          onTap: () async {
                                    
                                            if(tabAccEdit == 1){
                                              if(passwordAntTxt.text.isEmpty){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Ingrese su contraseña actual'),
                                                      
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            // Acción para solicitar revisión
                                                            //Navigator.of(context).pop();
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                      
                                                return;
                                              }
                                      
                                              if(passwordTxt.text != passwordConfTxt.text){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Las contraseñas deben coincidir'),
                                                      
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            // Acción para solicitar revisión
                                                            //Navigator.of(context).pop();
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                      
                                                return;
                                              }
                                            }

                                            Navigator.of(context).pop();
                                            
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Datos actualizados correctamente'),
                                                  
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        // Acción para solicitar revisión
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: ButtonCvsWidget(                            
                                            //text: 'Guardar Cambios',
                                            text: 'Actualizar',
                                            textStyle: AppTextStyles.h3Bold(
                                                width: size.width,
                                                color: AppLightColors().white),
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: size.height * 0.02,//0.11,
                                  ),
                                                            
                                ],
                              ),
                                  
                            ),
                          
                          ],
                        ),
                      ),
              
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
        
    );
  }
}
