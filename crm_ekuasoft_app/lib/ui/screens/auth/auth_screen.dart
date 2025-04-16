import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/domain/models/models.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
//import 'package:crm_ekuasoft_app/gen_l10n/app_localizations.dart';

TextEditingController userTxt = TextEditingController();
TextEditingController passWordTxt = TextEditingController();

const storageAuth = FlutterSecureStorage();
BuildContext? contextAuth;
String tokenDevice = '';

//final _mobileDeviceIdentifierPlugin = MobileDeviceIdentifier();

//ignore: use_key_in_widget_constructors
class AuthScreen extends StatelessWidget {

  AuthScreen(Key? key) : super(key: key) {
    //getAcountType();
  }

  @override
  Widget build(BuildContext context) {
    contextAuth = context;
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppLightColors().gray100Background,
          body: Container(
            width: size.width,//double.infinity,
            height: size.height * 0.98,//* 1.3
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple.shade100, Colors.purple.shade300],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ChangeNotifierProvider(
                    create: (_) => AuthService(),
                    child: const LoginScreen(null),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  
  const LoginScreen(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final authService = Provider.of<AuthService>(context);

    return Container(
        width: size.width,//double.infinity,
        height: size.height * 0.98,//* 1.3
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.topRight,   // Inicia desde la parte superior derecha
            begin: Alignment.bottomLeft,
            colors: [Colors.blue.shade600, Colors.blue.shade600, Colors.white, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo en la parte superior
              Container(
                color: Colors.transparent,
                width: size.width * 0.9,
                alignment: Alignment.centerLeft,
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              // Texto de bienvenida
              Container(
                color: Colors.transparent,
                width: size.width * 0.9,
                alignment: Alignment.centerLeft,
                child: const Text(
                  '¡Bienvenido de nuevo!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              SizedBox(height: size.height * 0.01),
              
              // Subtítulo
              Container(
                color: Colors.transparent,
                width: size.width * 0.9,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Utilice el siguiente formulario para acceder a su cuenta.',                  
                  style: TextStyle(fontSize: 16),
                ),
              ),
              
              SizedBox(height: size.height * 0.04),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),              
                child: Container(
                  padding: const EdgeInsets.all(16),  // Espaciado interno
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Bordes redondeados
                    color: Colors.white
                  ),
                  child: TextField(
                    controller: userTxt,
                    decoration: InputDecoration(                  
                      labelText: 'Usuario',
                      suffixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: size.height * 0.02),
              
              // Campo de texto "Contraseña"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  padding: const EdgeInsets.all(16),  // Espaciado interno
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Bordes redondeados
                    color: Colors.white
                  ),
                  child: TextField(
                    obscureText: authService.varIsOscured,
                    controller: passWordTxt,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      suffixIcon: 
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
                  ),
                ),
              ),

              const SizedBox(height: 30),
              
              // Botón de Acceder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 115.0),
                child: ElevatedButton(
                  onPressed: () async {
                    
                    if(userTxt.text.isEmpty || passWordTxt.text.isEmpty){

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
                            mensajeAlerta: 'Ingrese sus credenciales.'
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
                            mensajeMostrar: 'Estamos validando',
                            mensajeMostrarDialogCargando: 'tus credenciales',
                          ),
                        ]
                      ),
                    );

                    const storage = FlutterSecureStorage();
                    final objStr = await storage.read(key: 'RespuestaRegistro') ?? '';
    
                    if(objStr.isNotEmpty){

                      var obj = RegisterDeviceResponseModel.fromJson(objStr);

                      AuthRequest objAuthRequest  = AuthRequest(
                        db: obj.result.database,
                        login: userTxt.text,
                        password: passWordTxt.text
                      );

                      try{
                        var resp = await AuthService().login(objAuthRequest);

                        if(resp == 'NI'){
                          //ignore: use_build_context_synchronously
                          context.pop();

                          showDialog(
                            //ignore: use_build_context_synchronously
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Container(
                                  color: Colors.transparent,
                                  height: size.height * 0.22,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      Container(
                                        color: Colors.transparent,
                                        height: size.height * 0.1,
                                        child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                      ),

                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.95,
                                        height: size.height * 0.11,
                                        alignment: Alignment.center,
                                        child: const AutoSizeText(
                                          'No tiene acceso a internet',
                                          maxLines: 2,
                                          minFontSize: 2,
                                        ),
                                      ),
                                      
                                    ],
                                  )
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
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
                      
                        final data = json.decode(resp);

                        final objError = data['error'];
                        
                        //ignore: use_build_context_synchronously
                        context.pop();

                        if(objError == null) {
                          //ignore: use_build_context_synchronously
                          context.push(objRutasGen.rutaHome);
                          //context.push(objRutasGen.rutaOnBoarding);
                        } else {
                          final msmError = data['error']['data']['name'];

                          showDialog(
                            //ignore: use_build_context_synchronously
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Container(
                                  color: Colors.transparent,
                                  height: size.height * 0.22,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      Container(
                                        color: Colors.transparent,
                                        height: size.height * 0.1,
                                        child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                      ),

                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.95,
                                        height: size.height * 0.11,
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          msmError,
                                          maxLines: 2,
                                          minFontSize: 4,
                                        ),
                                      ),
                                      
                                    ],
                                  )
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Acción para solicitar revisión
                                      Navigator.of(context).pop();
                                      //Navigator.of(context).pop();
                                    },
                                    child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                      catch(ex){
                        //ignore: use_build_context_synchronously
                        context.pop();

                        showDialog(
                          //ignore: use_build_context_synchronously
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Container(
                                color: Colors.transparent,
                                height: size.height * 0.22,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    
                                    Container(
                                      color: Colors.transparent,
                                      height: size.height * 0.1,
                                      child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                    ),

                                    Container(
                                      color: Colors.transparent,
                                      width: size.width * 0.95,
                                      height: size.height * 0.11,
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        ex.toString(),
                                        maxLines: 2,
                                        minFontSize: 4,
                                      ),
                                    ),
                                    
                                  ],
                                )
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                ),
                              ],
                            );
                          },
                        );                        
                      }
                    }
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Acceder',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            
              SizedBox(height: size.height * 0.05),
/*
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 115.0),
                child: ElevatedButton(
                  onPressed: () async {
                    context.push(Rutas().rutaInformative);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[200],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Información',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

            SizedBox(height: AppSpacing.space01()),
            */
            ],
          ),
        ),
      );
    
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final authSerrviceTemp = AuthService();
  //final datosUsuarioServicesTemp = DatosUsuarioService();
  
  @override
  void initState() {
    //InternetConnectivity().initialize(context);
    super.initState();
  }

  @override
  void dispose() {
    getTokenDevice();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;
    final regularExp = CvsRegExp();
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: size.height * 1.15,
          color: Colors.transparent,
          child: Form(
            key: authService.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!authService.areInputsView)
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                Column(
                  children: [
                    Image.asset(
                      'assets/ilustraciones_medium_figma/img_20.png',
                      width: size.height * 0.25,
                      height: size.height * 0.25,
                    ),
                    Text(
                      'Bienvenido',//AppLocalizations.of(context)!.bienvenidaPlux,
                      style: AppTextStyles.h2Bold(width: size.width),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                /*
                authService.areInputsView
                    ? 
                    */
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /*
                          Preferences.isUserLogin
                              ? 
                              */
                              Text(
                                  'Ingrese sus credenciales',//AppLocalizations.of(context)!.ingreseSuClave,
                                  style: AppTextStyles.bodySemiBold(
                                      width: size.width),
                                ),
                            /*
                              : _InputAuth(
                                  child: TextFormField(
                                    cursorColor: AppLightColors().primary,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    autocorrect: false,
                                    keyboardType: TextInputType.emailAddress,
                                    style: AppTextStyles.bodyRegular(
                                        width: size.width),
                                    decoration:
                                        InputDecorationPlux.authInputDecoration(
                                      size: size,
                                      hintTetx: AppLocalizations.of(context)!
                                          .hintTextEmail,
                                      labelText:
                                          AppLocalizations.of(context)!.email,
                                    ),
                                    onChanged: (value) =>
                                        authService.email = value,
                                    validator: (value) {
                                      if (!Preferences.isUserLogin) {
                                        String pattern =
                                            regularExp.regexToEmail;
                                        RegExp regExp = RegExp(pattern);
                                        return regExp.hasMatch(value ?? '')
                                            ? null
                                            : AppLocalizations.of(context)!
                                                .validatorEmail;
                                      }
                                      return '';
                                    },
                                  ),
                                ),
                          */
                          SizedBox(height: AppSpacing.space02()),
                          TextFormField(
                            inputFormatters: [
                              EmojiInputFormatter()
                            ],
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: '',
                labelText: 'Usuario',
              ),
              //onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern = regularExp.regexToEmail;
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
            ),
            
                          SizedBox(height: AppSpacing.space04()),
                          _InputAuth(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: AppLightColors().primary,
                              autocorrect: false,
                              obscureText: authService.varIsOscured,
                              keyboardType: TextInputType.text,
                              style:
                                  AppTextStyles.bodyRegular(width: size.width),
                              decoration:
                                  InputDecorationCvs.authInputDecoration(
                                size: size,
                                hintTetx: '',
                                labelText: 'Clave',//AppLocalizations.of(context)!.clave,
                                suffixIcon: !authService.varIsOscured
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
                              ),
                              onChanged: (value) async {
                                authService.passWord = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  /*
                                  return AppLocalizations.of(context)!
                                      .validatorCampoVacio;
                                      */
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: AppSpacing.space03()),
                          
                          GestureDetector(
                              onTap: () async {
                                context.push(Rutas().rutaHome);
                              },
                              child: ButtonCvsWidget(
                                text: 'Iniciar sesión',
                                    //AppLocalizations.of(context)!.iniciarSesion,
                                textStyle: AppTextStyles.h3Bold(
                                    width: size.width,
                                    color: AppLightColors().white),
                              )),
                          SizedBox(height: AppSpacing.space01()),

                          Column(
                            children: [
                              SizedBox(
                                height: AppSpacing.space02(),
                              ),
                              GestureDetector(
                                onTap: () {
                                },
                                child: Text(
                                  'Olvidé mi clave',//AppLocalizations.of(context)!.olvideClave,
                                  style:
                                      AppTextStyles.bodyBold(width: size.width),
                                ),
                              ),
                              /*
                              Preferences.isUserLogin
                                  ? 
                                  */
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: AppSpacing.space02(),
                                        ),
                                        /*
                                        GestureDetector(
                                          onTap: () {
                                            _cambiarUsuario(context);
                                          },
                                          child: Text(
                                          
                                            AppLocalizations.of(context)!
                                                .noSoyUser(
                                                    Preferences.userNames),
                                                    
                                            style: AppTextStyles.bodyBold(
                                                width: size.width),
                                          ),
                                        ),
                                        SizedBox(
                                          height: AppSpacing.space02(),
                                        ),
                                        */
                                        /*
                                        GestureDetector(
                                          onTap: () {
                                          },
                                          child: Text(                                            
                                            AppLocalizations.of(context)!
                                                .cambieNumero,                                                
                                            style: AppTextStyles.bodyBold(
                                                width: size.width),
                                          ),
                                        ),
                                        */
                                      ],
                                    )
                                  
                            ],
                          ),
                        ],
                      ),
                      /*
                    : authService.inputPin
                        ? Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.ingreseSuPin,
                                style: AppTextStyles.bodySemiBold(
                                    width: size.width),
                              ),
                              SizedBox(
                                height: AppSpacing.space04(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Pinput(
                                  closeKeyboardWhenCompleted: true,
                                  autofocus: true,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                  length: 6,
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: defaultPinTheme.copyWith(
                                      height: 70,
                                      width: 85,
                                      decoration: defaultPinTheme.decoration!
                                          .copyWith(
                                              border: Border.all(
                                                  color: AppLightColors()
                                                      .primary))),
                                  showCursor: false,
                                  submittedPinTheme: defaultPinTheme.copyWith(
                                      decoration: defaultPinTheme.decoration!
                                          .copyWith()),
                                  onCompleted: (pin) async {
                                    String pinEncode =
                                        base64.encode(utf8.encode(pin));
                                    if (pinEncode == Preferences.pin) {
                                      String username = Preferences.maiEemail;
                                      LoginModel loginModel = LoginModel(
                                          username: authService.email,
                                          userCode:
                                              base64.encode(utf8.encode(pin)));
                                      performLogin(context, loginModel);
                                      Preferences.maiEemail = username;
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogPlux(
                                            title: AppLocalizations.of(context)!
                                                .pinIncorrecto,
                                            message:
                                                AppLocalizations.of(context)!
                                                    .reingresarPin,
                                            numMessageLines: 3,
                                            onPressedPrimaryButton: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                        */
                _LoginOptions(),
                if (!authService.areInputsView)
                  SizedBox(
                    height: size.height * 0.2,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginOptions extends StatefulWidget {
  @override
  State<_LoginOptions> createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<_LoginOptions> {
  bool areInputsView = false;
  @override
  void initState() {
    getTokenDevice();
    super.initState();
    //_getImei();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);

    return SizedBox(
      width: size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //* FaceId
          /*
          if (Preferences.isUserLogin &&
              !Preferences.isFirstLogin &&
              Preferences.biometricPrefered == true)
              */
              /*
            GestureDetector(
              onTap: () async {
                
              },
              child: _CardOptionLogin(
                icon: Icons.fingerprint,
                text: 'Biométricos'//AppLocalizations.of(context)!.biometricos,
              ),
            ),
            */

          //* Usuario y contraseña
          if (!authService.areInputsView)
            GestureDetector(
              onTap: () {
                authService.inputPin = false;
                authService.areInputsView = true;
              },
              child: const _CardOptionLogin(
                icon: Icons.verified_user_outlined,
                text: 'Clave'
              ),
            ),

          //* Ingreso por pin
            /*
            if (!authService.inputPin)
              GestureDetector(
                onTap: () {
                  authService.inputPin = true;
                  authService.areInputsView = false;
                },
                child: const _CardOptionLogin(
                  icon: Icons.security,
                  text: 'PIN',
                ),
              ),
        */
        ],
      ),
    );
  }
}

void getTokenDevice() {
  try {
    tokenDevice = '02:00:00:00:00:00';
  } catch (e) {
    tokenDevice = '02:00:00:00:00:00';
  }
}

limpiarStorage() async {
  await storageAuth.delete(key: 'dataMeth');
  await storageAuth.delete(key: 'logoMeth');
  await storageAuth.delete(key: 'respMeths');
}

String encodeBase64(String value) {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String encodedValue = stringToBase64.encode(value);
  return encodedValue;
}

void accesoBiometricos(context) {
  final size = MediaQuery.of(context).size;
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
          height: size.height * 0.35,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.15,
                  child: Image.asset(
                    'assets/ic_horizontalLine.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: AppSpacing.space03(),
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Biométricos',//AppLocalizations.of(context)!.biometricos,
                        style: AppTextStyles.h3Bold(width: size.width),
                      ),
                      SizedBox(height: AppSpacing.space01()),
                      Text(
                        '¿Desea usar biométricos?',
                        /*
                        AppLocalizations.of(context)!
                            .quiereUsarBiometricosLogin,
                            */
                        style: AppTextStyles.bodyRegular(
                            width: size.width,
                            color: AppLightColors().gray800SecondaryText),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.space01()),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      //Preferences.biometricPrefered = true;
                    },
                    child: ButtonCvsWidget(
                      text: 'Sí',//AppLocalizations.of(context)!.siUsarBiometricos,
                      textStyle: AppTextStyles.h3Bold(
                        width: size.width,
                        color: AppLightColors().white,
                      ),
                    )),
                TextButtonCvs(
                  null,
                  onPress: () {
                    Navigator.pop(context);
                  },
                  text: 'No, usaré mi clave',//AppLocalizations.of(context)!.noUsareClave,
                  textStyle: AppTextStyles.h3Bold(
                    width: size.width,
                    color: AppLightColors().textButtonPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void cambiarUsuario(context) {
  final size = MediaQuery.of(context).size;
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
          height: size.height * 0.3,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.15,
                  child: Image.asset(
                    'assets/ic_horizontalLine.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BaseText(
                      null,
                      'NO usado',                      
                      size: 0.05,
                      weight: FontWeight.w700,
                      align: TextAlign.start,
                    ),
                    SizedBox(height: AppSpacing.space01()),
                    const BaseText(
                      null,
                      'Se cerrará sesión',//AppLocalizations.of(context)!.seCerraraSesion,                      
                      size: 0.045,
                      weight: FontWeight.w400,
                      align: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.space01()),
                Column(
                  children: [
                    GestureDetector(
                        onTap: () async {
                        },
                        child: const DefaultButton(
                          text: 'Continuar',//AppLocalizations.of(context)!.continuar,
                          weight: FontWeight.w700,
                        )),
                    DefaultTextButtonCvs(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      text: 'Cancelar',//AppLocalizations.of(context)!.cancelar,
                      sizeText: 0.05,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

class _CardOptionLogin extends StatelessWidget {
  const _CardOptionLogin({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.25,
      width: size.width * 0.27,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 12, bottom: 12, left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size.height * 0.05,
            ),
            SizedBox(height: AppSpacing.space01()),
            Center(
              child: Text(
                text,
                style: AppTextStyles.h5Medium(width: size.width),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputAuth extends StatelessWidget {
  const _InputAuth({
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        color: Colors.transparent,
        height: 70,
        width: size.width * 0.85,
        child: child);
  }
}

class MyCustomBox extends StatelessWidget {

  const MyCustomBox(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          padding: const EdgeInsets.all(16),  // Espaciado interno
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), // Bordes redondeados
            gradient: LinearGradient(
              colors: [Colors.purple.shade100, Colors.white], // Degradado
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Sombra de la caja
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Desplazamiento de la sombra
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Texto
              Expanded(
                child: Text(
                  '[If/Then/Else (2 Conditions)]',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(Icons.copy, color: Colors.grey),
              SizedBox(width: 8),
              Icon(Icons.paste, color: Colors.grey),
            ],
          ),
        ),
      );
  }
}
