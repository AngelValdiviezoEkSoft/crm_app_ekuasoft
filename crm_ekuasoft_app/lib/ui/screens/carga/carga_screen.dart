import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CargaScreen extends StatelessWidget {
  
  const CargaScreen(Key? key) : super (key: key);
  
  @override
  Widget build(BuildContext context) {

    return Center(
      child: FrmCargaScreen(null),
    );
  }
}

//ignore: must_be_immutable
class FrmCargaScreen extends StatelessWidget {

  int varPosicionMostrar = 0;
  //List<NotificacionesModels> varLstNotificaciones = [];

  FrmCargaScreen(Key? key) : super (key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context,state) { 
              return Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(
                      child: Image.asset(
                        "assets/gifs/gif_carga.gif",
                        height: size.width * 0.85,//150.0,
                        width: size.width * 0.85,//150.0,
                      ),
                    )
                  ),
                )
                
              );
            
              
            }
        )
      ),
    );
  }
}
