import 'dart:async';

import 'package:crm_ekuasoft_app/config/routes/routes.dart';
import 'package:crm_ekuasoft_app/ui/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cron/cron.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

bool mostrarBoton = false;

class CrmEkuasoftApp extends StatefulWidget {
  
  const CrmEkuasoftApp(Key? key,
  ) : super(key: key);

  @override
  CrmEkuasoftAppState createState() => CrmEkuasoftAppState();
}

class CrmEkuasoftAppState extends State<CrmEkuasoftApp> {
  final TokenManager tokenManager = TokenManager();
  final cron = Cron();
  late Stream<ConnectivityResult> connectivityStream;

  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _controller.stream;


  @override
  void initState() {
    super.initState();
    mostrarBoton = false;

    connectivityStream = Connectivity().onConnectivityChanged;
/*
    Connectivity().onConnectivityChanged.listen((_) async {
      final isConnected = await InternetConnectionChecker().hasConnection;
      _controller.sink.add(isConnected);
      

      setState(() {
        mostrarBoton = isConnected;
      });

    });
    */

    //!connectivityResult.contains(ConnectivityResult.mobile) && !connectivityResult.contains(ConnectivityResult.wifi)
    // Escuchar cambios de red
    connectivityStream.listen((_) => checkConnection());
    checkConnection(); // Verificar al inicio

    // Configura una tarea que se ejecuta cada minuto.
    // cron.schedule(Schedule.parse('*/6 * * * * *'), () {
    //   setState(() {
    //     //tokenManager.startTokenCheck(imei!);
    //     tokenManager.startTokenCheck();
    //   });
    // });
    
  }

  @override
  void dispose() {
    cron.close();
    tokenManager.stopTokenCheck();
    _controller.close();
    super.dispose();
  }

  Future<void> checkConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    setState(() {
      mostrarBoton = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return MaterialApp.router(
        title: 'Centro de viajes',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      );
  }
}

/*
class CentroViajesApp extends StatelessWidget {
  const CentroViajesApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return MaterialApp.router(
        title: 'Centro de viajes',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      );
  }
}
*/