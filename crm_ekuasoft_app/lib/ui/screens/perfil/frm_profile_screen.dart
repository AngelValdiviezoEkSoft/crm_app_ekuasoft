import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String cellProf = '';
String streetProf = '';
String emailProf = '';
String identificacionProf = '';

class FrmProfileScreen extends StatelessWidget {
  
  FrmProfileScreen({super.key}) {
    cellProf = '';
    streetProf = '';
    emailProf = '';
    identificacionProf = '';
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

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
        actions: [
          if(isCve)
          IconButton(
            icon: const Icon(Icons.lightbulb_circle, color: Colors.white,),
            onPressed: () {
              showDialog(
                //ignore:use_build_context_synchronously
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Container(
                      color: Colors.transparent,
                      height: size.height * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          Container(
                            color: Colors.transparent,
                            width: size.width * 0.95,
                            height: size.height * 0.19,
                            alignment: Alignment.center,
                            child: const Center(
                              child: AutoSizeText(
                                "Si desea actualizar sus datos, envíenos un correo al balcon@centrodeviajesecuador.com solicitando esta acción y los datos que desea actualizar.",
                                maxLines: 7,
                                minFontSize: 12,
                              ),
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
                        child: Text("Aceptar", style: TextStyle(color: Colors.blue[200]),),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          if(!isCve)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white,),
            onPressed: () {
              context.push(objRutasGen.rutaEditProfile);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: AuthService().getDatosPerfil(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            
            if(!snapshot.hasData) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Image.asset(
                    "assets/gifs/gif_carga.gif",
                    height: size.width * 0.85,
                    width: size.width * 0.85,
                  ),
                ),
              );
            }
            else{

              String respuesta = '${snapshot.data}';

              List<String> arrayRsp = respuesta.split('%%%');

              var rsp = ResPartnerDatumAppModel.fromRawJson(arrayRsp[0]);
              
              cellProf = rsp.phone ?? '';
              streetProf = rsp.street ?? '';
              emailProf = rsp.email ?? '';
              identificacionProf = rsp.vat ?? '';

            }
            return Container(
              color: Colors.transparent,
              width: size.width,
              child: Stack(
              children: [
                        
                Container(
                  color: Colors.transparent,
                  width: size.width,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.06),
                          
                      Container(
                        width: size.width * 0.92,
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
                              
                              SizedBox(height: size.height * 0.07),
                              Container(
                                color: Colors.transparent,
                                width: size.width * 0.92,
                                height: size.height * 0.7,
                                child: Card(
                                  margin: const EdgeInsets.all(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        
                                        ProfileField(label: "Nombres", value: nameUserLbl),
                                        ProfileField(label: "Número de identificación", value: identificacionProf),
                                        ProfileField(label: "Celular", value: cellProf),
                                        ProfileField(label: "Email", value: emailProf),
                                        ProfileField(label: "Dirección", value: streetProf),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                        
                Positioned(
                  left: 143,
                  child: Container(
                    padding: const EdgeInsets.all(4), // grosor del borde
                    decoration: const BoxDecoration(
                      color: Colors.white, // color del borde
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[350],
                      child: const Icon(Icons.person_outline, size: 50, color: Colors.white,),
                    ),
                  ),
                ),
                        
              ],
                        ),
            );
        }
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        text: TextSpan(
          text: '$label\n',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
