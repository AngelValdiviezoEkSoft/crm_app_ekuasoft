import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
//import 'package:marcacion_facial_ekuasoft_app/app/app.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';

import 'package:crm_ekuasoft_app/ui/ui.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

//class MarcacionScreen extends StatelessWidget {
class _DashBoardScreenState extends State<DashBoardScreen> {

  final LocalAuthentication auth = LocalAuthentication();
  //_SupportState _supportState = _SupportState.unknown;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    List<LocalidadType> lstLocalidades = [];
//-2.194379, -79.762934
    lstLocalidades.add(
      LocalidadType(
        codigo: '0123',
        descripcion: 'Test',
        esPrincipal: true,
        estado: '',
        fechaCreacion: DateTime.now(),
        id: '1',
        idEmpresa: '1',
        radio: 0.02,
        usuarioCreacion: '',
        usuarioModificacion: '',
        fechaModificacion: DateTime.now(),
        
        latitud: -2.194379,
        longitud: -79.762934
        
      )
    );

    //Color colorBtn = Colors.transparent;
    //bool localizacionValida = false;

    return Scaffold(
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {

          return MainBackgroundWidget(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    height: size.height * 0.165,
                    width: size.width * 0.33,
                    color: Colors.transparent,
                    child: Image.asset(
                            'assets/logos_app/ic_ekuasoft.png',
                            height: size.height * 0.35,
                          ),
                  ),

                  SizedBox(height: size.height * 0.04,),          
          
                  Container(
                    color: Colors.transparent,
                    width: size.width * 0.65,
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(AppStarted());

                        //context.push(Rutas().rutaDatosPersonalesOnBoarding);5
                        //context.push(Rutas().rutaDatosScanQrOnBoarding);
                      },
                      child: TextButtonMarcacion(
                        text: 'Registrate',
                        colorBoton: ColorsApp().naranja50PorcTrans,
                        colorTexto: Colors.white,
                        tamanioLetra: null,
                        tamanioBordes: null,
                        colorBordes: ColorsApp().naranja50PorcTrans,
                      ),
                    ),
                  )
                
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
