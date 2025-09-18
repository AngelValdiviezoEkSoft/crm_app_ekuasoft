import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsUserScreen extends StatefulWidget {
  const SettingsUserScreen({super.key});

  @override
  State<SettingsUserScreen> createState() => _SettingsUserScreenState();
}

class _SettingsUserScreenState extends State<SettingsUserScreen> {
  String selectedLanguage = 'Español';
  String selectedMode = 'Claro';

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    //final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      //appBar: AppBar(title: const Text('Configuración')), 
      appBar: AppBar(
        title: const Text('Configuraciones'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
/*
            Container(
              width: size.width,
              height: size.height * 0.08,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.45,
                    height: size.height * 0.08,
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: const Text('Idioma', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ),

                  Container(
                    width: size.width * 0.32,
                    height: size.height * 0.08,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: DropdownButtonFormField<String>(
                      //dropdownColor: const Color(0xFF53C9EC),
                      decoration: InputDecoration(
                        labelText: '',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0), // Bordes redondos
                        ),
                      ),
                      value: 'es',
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(color: Colors.black,  ),)),
                        DropdownMenuItem(value: 'es', child: Text('Español', style: TextStyle(color: Colors.black, ))),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          //languageProvider.changeLocale(value);
                        }
                      },
                    ),
                  ),
                  
                ],
              ),
            ),

            const SizedBox(height: 30),
            */

            const Text('Brillo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                brightnessOption('Modo claro', 'Claro', size, 'assets/images/modo_claro.png'),
                brightnessOption('Modo oscuro', 'Oscuro', size, 'assets/images/modo_oscuro.png'),
                brightnessOption('Automático', 'Automático', size, 'assets/images/modo_automatico.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget brightnessOption(String label, String mode, Size size, String image) {
    bool isSelected = selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMode = mode;
        });
      },
      child: Column(
        children: [
          Container(
            width: size.width * 0.25,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: isSelected ? Colors.blue : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              height: size.height * 0.13,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),                
                image: DecorationImage(
                  image: AssetImage(image), // Imagen local
                  fit: BoxFit.fill, // Ajusta la imagen al contenedor
                ),
              ),
              alignment: Alignment.center,
            ),
          ),

          SizedBox(height: size.height * 0.02),

          Text(label, style: TextStyle(color: isSelected ? Colors.blue : Colors.grey[400])),
        ],
      ),
    );
  }
}
