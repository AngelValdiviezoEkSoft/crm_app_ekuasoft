import 'dart:io';

import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:provider/provider.dart';

String rutaFotoPerfilEdit = '';
String fechaCumpleAnios = '';

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
    fechaCumpleAnios = '20/04/1994';

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
                                SizedBox(height: size.height * 0.1),//20),
                                
                                //SizedBox(height: size.height * 0.025),//20),
                                Card(
                                  margin: const EdgeInsets.all(16),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        
                                        CustomTextField(label: "Nombres", initialValue: nameUserLbl, txtInpTp: TextInputType.text, campoActivo: false,),                                      
                                        const CustomTextField(label: "Celular", initialValue: '0988665834', txtInpTp: TextInputType.number, campoActivo: true),
                                        const CustomTextField(label: "Email", initialValue: 'angel_elias_valdiviezo_gonzalez@hotmail.com', txtInpTp: TextInputType.emailAddress, campoActivo: true),
                                        const CustomTextField(label: "Email extra", initialValue: 'melanie.vilema@gmail.com', txtInpTp: TextInputType.emailAddress, campoActivo: true),
            
                                        SizedBox(height: size.height * 0.008,),
            
                                        GestureDetector(
                                          onTap: () {
                                            //openDatePickerProfile(context);
                                          },
                                          child: Container(
                                            width: size.width * 0.92,
                                            height: size.height * 0.08,
                                            color: Colors.transparent,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: size.width * 0.92,
                                                  height: size.height * 0.02,
                                                  color: Colors.transparent,
                                                  child: Text("Fecha de cumpleaños", style: TextStyle(color: Colors.grey[300]),),
                                                ),
                                                SizedBox(height: size.height * 0.007,),
                                                Container(
                                                  width: size.width * 0.92,
                                                  height: size.height * 0.02,
                                                  color: Colors.transparent,
                                                  child: Text(fechaCumpleAnios, style: const TextStyle(color: Colors.black),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
            
                                        SizedBox(height: size.height * 0.05,),
            
                                        Container(
                                          width: size.width * 0.96,
                                          color: Colors.transparent,
                                          alignment: Alignment.center,
                                          child: ElevatedButton(                      
                                            onPressed:
                                            () {
            
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
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
          suffixIcon: GestureDetector(
            //onTap: funtionExe,
            child: const Icon(Icons.cancel, size: 12,)
          )
        ),
        keyboardType: txtInpTp,
      ),
    );
  }
}
