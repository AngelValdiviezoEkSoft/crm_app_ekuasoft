
import 'package:crm_ekuasoft_app/ui/bloc/bloc.dart';
import 'package:crm_ekuasoft_app/ui/screens/screens.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckAuthScreen extends StatelessWidget {

  const CheckAuthScreen(
    Key? key
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context,state) {
          return Center(
            child: FutureBuilder(
              future: state.readToken(), 
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                if(!snapshot.hasData) {
                  return Image.asset(
                    "assets/gifs/gif_carga.gif",
                    height: 150.0,
                    width: 150.0,
                  );
                } else {                  
                  if(snapshot.data != '') {
                    if(snapshot.data == 'NI') {                        
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.pop();
                        context.push(objRutasGen.rutaConexionInternet);
                        /*
                        setState(() {
                          // Llama a setState después de que se haya completado el ciclo de construcción.
                        });
                        */
                      });
                    }
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.pop();
                      context.push(objRutasGen.rutaBienvenida);
                      /*
                      setState(() {
                        // Llama a setState después de que se haya completado el ciclo de construcción.
                      });
                      */
                    });
                  }
                }

                return Container();
              },
            )
          
          );
        }
      )
      
   );
    
  }
}