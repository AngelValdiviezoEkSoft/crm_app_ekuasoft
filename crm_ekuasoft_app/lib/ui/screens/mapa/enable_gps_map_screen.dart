
import 'package:animate_do/animate_do.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnableGpsMessage extends StatelessWidget {
  
  const EnableGpsMessage(Key? key) : super (key: key);    

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    //final gpsBloc = BlocProvider.of<GpsBloc>(context);

    return Scaffold(
      /*
      appBar: AppBar(
        //primary: false,
        backgroundColor: Colors.transparent,
        title: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              context.pop();
            },
          ),
        elevation: 0,
        actions: [              
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
      */
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.white, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
          
                    SizedBox(height: size.height * 0.04),
                    
                    const Text(
                      'Activar GPS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.02),
          
                    const Text(
                      'Para disfrutar plenamente de nuestra app, por favor activa tu GPS. ¡Esencial para brindarte la mejor experiencia!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    /*
                    SizedBox(height: size.height * 0.06),
                    
                    ElevatedButton(
                      onPressed: () async {
                        
                        final gpsBloc = BlocProvider.of<GpsBloc>(context);
                        gpsBloc.activaGps(true, true, true);
                        
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
                        'Activar Ubicación',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.03),
          
                    OutlinedButton(
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Saltar por ahora',
                        style: TextStyle(fontSize: 16, ),
                      ),
                    ),
                  */
                  ],
                ),
              ),
            ),
          ),
           Positioned(
            top: 25,
            left: 5,
            child:  Container(
              color: Colors.transparent,
              width: size.width * 0.99,
              height: size.height * 0.08,
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  context.pop();
                },
              ),
            ),    
          ),
        ]
      ),
    );

    /*
    return Scaffold(
      body: Stack(
        children: [
          //Se deshabilita para la suscripción
          
          const Positioned(
            top: 88,
            left: 20,
            child: BtnBackEnableGps()
          ),
          
          Center(
          child: BlocBuilder<GpsBloc, GpsState>(
            builder: (context, state) {
      
              return !state.isGpsEnabled ?
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text('Debe de habilitar el GPS',style: TextStyle( fontSize: 25, fontWeight: FontWeight.w300 ),),
                  
                ],
              )
              :  
              Container();
            }
          ),
        ),
        ]
      ),
    
    );
    */
  }
}


class BtnBackEnableGps extends StatelessWidget {
  //ProspectoType? objProspectoGps;
  const BtnBackEnableGps(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration( milliseconds: 300 ),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon( Icons.arrow_back_ios_new, color: Colors.black ),
          onPressed: () async {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            /* //Para cuando se quiera hacer uso del mapa como en uber
            BlocProvider.of<SearchBloc>(context).add(
              OnDeactivateManualMarkerEvent()
            );
            */
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("coordenadasIngreso",'');
            gpsBloc.vuelvePantallaFrm(false,false,false);
          },
        ),
      ),
    );
  }
}
