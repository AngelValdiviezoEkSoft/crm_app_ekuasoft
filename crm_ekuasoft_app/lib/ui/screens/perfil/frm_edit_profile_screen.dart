import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:provider/provider.dart';

String rutaFotoPerfilEdit = '';
String fechaCumpleAnios = '';
late TextEditingController nombreUserTxt;
late TextEditingController cedPrfTxt;
late TextEditingController cellPrfTxt;
late TextEditingController emailPrfTxt;
late TextEditingController direccionPrfTxt;

class FrmProfileEditScreen extends StatefulWidget {
  const FrmProfileEditScreen(Key? key) : super(key: key);

  @override
  FrmProfileEditScreenState createState() => FrmProfileEditScreenState();
}

class FrmProfileEditScreenState extends State<FrmProfileEditScreen> { 

  @override
  void initState() {
    super.initState();

    rutaFotoPerfilEdit = '';
    nombreUserTxt = TextEditingController();
    cedPrfTxt = TextEditingController();
    cellPrfTxt = TextEditingController();
    emailPrfTxt = TextEditingController();
    direccionPrfTxt = TextEditingController();

/*
    if(nombreUserTxt.text.isEmpty){
      nombreUserTxt.text = nameUserLbl;
    }

    if(cellPrfTxt.text.isEmpty){
      cellPrfTxt.text = cellProf;
    }

    if(emailPrfTxt.text.isEmpty){
      emailPrfTxt.text = emailProf;
    }

    if(emailPrfTxt.text.isEmpty){
      emailPrfTxt.text = emailProf;
    }

    if(direccionPrfTxt.text.isEmpty){
      direccionPrfTxt.text = streetProf;
    }

    if(cedPrfTxt.text.isEmpty){
      cedPrfTxt.text = identificacionProf;
    }
    */

    nombreUserTxt.text = nameUserLbl;
    cellPrfTxt.text = cellProf;
    emailPrfTxt.text = emailProf;
    direccionPrfTxt.text = streetProf;
    cedPrfTxt.text = identificacionProf;
  } 

  void openDatePickerProfile(BuildContext context) {
    picker.DatePicker.showDatePicker(context, showTitleActions: true, maxTime: DateTime.now(),
      onChanged: (date) {
      setState(() {
        fechaCumpleAnios = DateFormat('dd/MM/yyyy').format(date);
      });
    }, currentTime: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {

    final gnrBloc = Provider.of<GenericBloc>(context);
    final size = MediaQuery.of(context).size;
    contextPrincipalGen = context;
    //ColorsApp objColorsApp = ColorsApp();
    
    return BlocBuilder<GenericBloc, GenericState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.blue,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text("Perfil", style: TextStyle(color: Colors.white),),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                
                Column(
                  children: [
                    SizedBox(height: size.height * 0.06),
                
                    Stack(
                      children: [
                    
                        Container(
                          height: size.height * 0.8,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: size.height * 0.08),//20),
                                
                                //SizedBox(height: size.height * 0.025),//20),
                                Card(
                                  margin: const EdgeInsets.all(16),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: TextFormField(
                                            enabled: false,
                                            controller: nombreUserTxt,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              labelText: 'Nombres',
                                              border: const UnderlineInputBorder(),
                                              suffixIcon: GestureDetector(
                                                //onTap: funtionExe,
                                                child: const Icon(Icons.cancel, size: 15,)
                                              )
                                            ),
                                            keyboardType: TextInputType.text,
                                          ),                                            
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: TextFormField(
                                            enabled: false,
                                            controller: cedPrfTxt,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              labelText: 'Cédula',
                                              border: const UnderlineInputBorder(),
                                              suffixIcon: GestureDetector(
                                                //onTap: funtionExe,
                                                child: const Icon(Icons.cancel, size: 15,)
                                              )
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),                                            
                                        ),
                                        
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: TextFormField(
                                            enabled: true,
                                            maxLength: 10,
                                            controller: cellPrfTxt,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              labelText: 'Celular',
                                              border: const UnderlineInputBorder(),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  cellPrfTxt.text = '';
                                                },
                                                child: const Icon(Icons.cancel, size: 15,)
                                              )
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),                                            
                                        ),
                                        
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: TextFormField(
                                            enabled: true,
                                            controller: emailPrfTxt,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              labelText: 'Email',
                                              border: const UnderlineInputBorder(),
                                              suffixIcon: GestureDetector(
                                                //onTap: funtionExe,
                                                child: const Icon(Icons.cancel, size: 15,)
                                              )
                                            ),
                                            keyboardType: TextInputType.emailAddress,
                                          ),                                            
                                        ),
                                        
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: TextFormField(
                                            enabled: true,
                                            controller: direccionPrfTxt,
                                            maxLines: 2,
                                            decoration: InputDecoration(
                                              labelText: 'Dirección',
                                              border: const UnderlineInputBorder(),
                                              suffixIcon: GestureDetector(
                                                //onTap: funtionExe,
                                                child: const Icon(Icons.cancel, size: 15,)
                                              )
                                            ),
                                            keyboardType: TextInputType.text,
                                          ),                                            
                                        ),
                                        
                                        SizedBox(height: size.height * 0.05,),
            
                                        Container(
                                          width: size.width * 0.96,
                                          color: Colors.transparent,
                                          alignment: Alignment.center,
                                          child: ElevatedButton(                      
                                            onPressed:
                                            () async {

                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) => SimpleDialog(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SimpleDialogCargando(
                                                      null,
                                                      mensajeMostrar: 'Estamos actualizando',
                                                      mensajeMostrarDialogCargando: 'sus datos.',
                                                    ),
                                                  ]
                                                ),
                                              );

                                              String camposVacios = '';

                                              if(cellPrfTxt.text.isEmpty){
                                                camposVacios = 'Ingrese su número celular';
                                              }

                                              if(emailPrfTxt.text.isEmpty){
                                                camposVacios = 'Ingrese su email';
                                              }

                                              if(direccionPrfTxt.text.isEmpty){
                                                camposVacios = 'Ingrese su dirección';
                                              }

                                              if(camposVacios.isNotEmpty){
                                                Navigator.of(context).pop();

                                                showDialog(
                                                  //ignore:use_build_context_synchronously
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Container(
                                                        color: Colors.transparent,
                                                        height: size.height * 0.17,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            
                                                            Container(
                                                              color: Colors.transparent,
                                                              height: size.height * 0.09,
                                                              child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                                            ),
                                
                                                            Container(
                                                              color: Colors.transparent,
                                                              width: size.width * 0.95,
                                                              height: size.height * 0.08,
                                                              alignment: Alignment.center,
                                                              child: AutoSizeText(
                                                                camposVacios,
                                                                maxLines: 2,
                                                                minFontSize: 2,
                                                              ),
                                                            )
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

                                              const storage = FlutterSecureStorage();

                                              final rspLogin = await storage.read(key: 'DataUser') ?? '';

                                              final jsonLog = json.decode(rspLogin);
                                              var partnerId = jsonLog["result"]["data"][0]["partner_id"]["id"] ?? 0;

                                              String gifRespuesta = '';

                                              CierreActividadesResponseModel rsp = await ProfileService().editPerfil(partnerId, cellPrfTxt.text, emailPrfTxt.text, direccionPrfTxt.text);

                                              if(rsp.result.estado == 200){
                                                gifRespuesta = 'assets/gifs/exito.gif';
                                                await AuthService().saveMemoryDatosPerfil(cellPrfTxt.text, emailPrfTxt.text, direccionPrfTxt.text);
                                              } else {
                                                gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                              }

                                              //ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();

                                              showDialog(
                                                //ignore:use_build_context_synchronously
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Container(
                                                      color: Colors.transparent,
                                                      height: size.height * 0.17,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          
                                                          Container(
                                                            color: Colors.transparent,
                                                            height: size.height * 0.09,
                                                            child: Image.asset(gifRespuesta),
                                                          ),
                              
                                                          Container(
                                                            color: Colors.transparent,
                                                            width: size.width * 0.95,
                                                            height: size.height * 0.08,
                                                            alignment: Alignment.center,
                                                            child: AutoSizeText(
                                                              rsp.result.mensaje,
                                                              maxLines: 2,
                                                              minFontSize: 2,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          Navigator.of(context).pop();
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
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                //side: BorderSide(color: btnGuardar && btnGuardarFoto ? Colors.green : Colors.grey, width: 2),
                                              ),
                                              backgroundColor: Colors.blue,
                                              elevation: 0,
                                            ),
                                            child: const Text(
                                              "Guardar",
                                              style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        
                                        SizedBox(height: size.height * 0.02,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    
                      ],
                    ),
                  ],
                ),
              
                if (rutaFotoPerfilEdit.isEmpty&& !state.levantaModal)
                Positioned(
                  //top: -1,
                  left: 137,
                  //left: 80,
                  child: GestureDetector(
                    onTap: () {
                      gnrBloc.setLevantaModal(true);
                      mostrarOpciones(context, size);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4), // grosor del borde
                      decoration: const BoxDecoration(
                        color: Colors.white, // color del borde
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[350],
                        child: const Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.white,),
                      ),
                    ),
                  ),
                ),
            
                if (state.levantaModal)
                Positioned(
                  //top: -1,
                  left: 137,
                  child: Container(
                    padding: const EdgeInsets.all(4), // grosor del borde
                    decoration: const BoxDecoration(
                      color: Colors.white, // color del borde
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[350],
                      //child: const Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.white,),
                    ),
                  ),
                ),
            
                if (rutaFotoPerfilEdit.isNotEmpty && !state.levantaModal)
                Positioned(
                  //top: -1,
                  left: 137,
                  child: Container(
                    padding: const EdgeInsets.all(4), // grosor del borde
                    decoration: const BoxDecoration(
                      color: Colors.white, // color del borde
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[350],
                      backgroundImage: FileImage(File(rutaFotoPerfilEdit)),
                      child: GestureDetector(
                        onTap: () async {
                          gnrBloc.setLevantaModal(true);
                          mostrarOpciones(context, size);
                        },
                      )
                    ),
                  ),
                ),
                    
              ],
            ),
          )
        );
      }
    );
  }

  void mostrarOpciones(BuildContext context, Size size) {
    final gnrBloc = Provider.of<GenericBloc>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: true,      
      builder: (BuildContext context) {
        return Center(
          child: Dialog(        
            backgroundColor: Colors.transparent,    
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(rutaFotoPerfilEdit.isEmpty)
                Container(
                  width: size.width * 0.27,
                  height: size.height * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_a_photo_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                if(rutaFotoPerfilEdit.isNotEmpty)
                Container(
                  width: size.width * 0.68,
                  height: size.height * 0.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(rutaFotoPerfilEdit)),
                      fit: BoxFit.fill,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                
                Container(
                  //width: size.width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(rutaFotoPerfilEdit.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: Colors.white),
                        title: const Text('Eliminar foto', style: TextStyle(color: Colors.white)),
                        onTap: () async {
                          Navigator.pop(context);
                          rutaFotoPerfilEdit = '';
                        },
                      ),
                      if(rutaFotoPerfilEdit.isNotEmpty)
                      const Divider(color: Colors.white24, height: 1),
                      ListTile(
                        leading: const Icon(Icons.camera_alt, color: Colors.white),
                        title: const Text('Tomar foto', style: TextStyle(color: Colors.white)),
                        onTap: () async {
                          Navigator.pop(context);
                          
                          final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

                          gnrBloc.setCargando(true);

                          try {
                            if (pickedFile != null) {
                              rutaFotoPerfilEdit = pickedFile.path;

                              //validandoFoto = false;
                              
                              gnrBloc.setCargando(false);
                              gnrBloc.setLevantaModal(false);
                              
                              setState(() {});

                            }
                          } catch (_) {}
                        },
                      ),
                      const Divider(color: Colors.white24, height: 1),
                      ListTile(
                        leading: const Icon(Icons.photo_library, color: Colors.white),
                        title: const Text('Seleccionar foto', style: TextStyle(color: Colors.white)),
                        onTap: () async {
                          
                          Navigator.pop(context);

                          gnrBloc.setCargando(true);

                          final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                          try {
                            if (pickedFile != null) {
                              //File file = File(pickedFile.path);
                              //btnGuardarFoto = true;

                              rutaFotoPerfilEdit = pickedFile.path;

                              //validandoFoto = false;

                              setState(() {});
                            }
                          } catch (_) {}
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((result){      
      gnrBloc.setCargando(false);
      gnrBloc.setLevantaModal(false);      
    });

  }

}

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final TextInputType txtInpTp;
  final bool campoActivo;
  //final VoidCallback funtionExe;

  const CustomTextField({super.key, required this.label, required this.initialValue, required this.txtInpTp, required this.campoActivo});//required this.funtionExe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        enabled: campoActivo,
        initialValue: initialValue,
        maxLines: label != 'Dirección' ? 1 : 4,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
          suffixIcon: GestureDetector(
            //onTap: funtionExe,
            child: const Icon(Icons.cancel, size: 15,)
          )
        ),
        keyboardType: txtInpTp,
      ),
    
    );
  }
}
