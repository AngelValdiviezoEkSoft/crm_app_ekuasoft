
import 'package:flutter/material.dart';

class GpsErrorScreen extends StatefulWidget {

  const GpsErrorScreen(Key? key) : super (key: key);

  @override
  State<GpsErrorScreen> createState() => _GpsErrorScreenState();
}

class _GpsErrorScreenState extends State<GpsErrorScreen> {
  

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8A2BE2), Color(0xFFDAA6F5)], // Degradado similar
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: size.height * 0.04),//20),
                const Text(
                  'Activar GPS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                //SizedBox(height: 10),
                SizedBox(height: size.height * 0.02),
                const Text(
                  'Para disfrutar plenamente de nuestra app, por favor activa tu GPS. ¡Esencial para brindarte la mejor experiencia!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                //SizedBox(height: 40),
                SizedBox(height: size.height * 0.06),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para activar GPS
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A2FC3),
                    //primary: Color(0xFF5A2FC3), // Color similar al botón
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Activar Ubicación',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                //SizedBox(height: 15),
                SizedBox(height: size.height * 0.03),
                OutlinedButton(
                  onPressed: () {
                    // Lógica para omitir
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Saltar por ahora',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    /*
    return Container(
      color: Colors.red,
      width: size.width,
      height: size.height * 0.2,
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Text('Debe habilitar el GPS',style: TextStyle( fontSize: 25, fontWeight: FontWeight.w300 ),),
        
        ],
      )
    
    );
    */
  }
}