//import 'package:crm_ekuasoft_app/config/config.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FrmProfileScreen extends StatelessWidget {
  
  const FrmProfileScreen({super.key});

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
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white,),
            onPressed: () {
              context.push(objRutasGen.rutaEditProfile);
            },
          ),
        ],
      ),
      body: Stack(
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
                          
                          SizedBox(height: size.height * 0.07),
                          Card(
                            margin: const EdgeInsets.all(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfileField(label: "Nombres", value: nameUserLbl),
                                  const ProfileField(label: "Número de identificación", value: '0922219480'),
                                  const ProfileField(label: "Celular", value: '0988665834'),
                                  const ProfileField(label: "Email", value: 'angel_elias_valdiviezo_gonzalez@hotmail.com'),
                                  const ProfileField(label: "Email de respaldo", value: 'melanie.vilema@gmail.com'),
                                  const ProfileField(label: "Fecha de nacimiento", value: '20/04/1994'),
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
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
