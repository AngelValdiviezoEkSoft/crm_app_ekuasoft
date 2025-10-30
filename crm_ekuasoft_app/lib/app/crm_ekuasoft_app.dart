import 'dart:async';

import 'package:crm_ekuasoft_app/config/routes/routes.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cron/cron.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    mostrarBoton = false;

    connectivityStream = Connectivity().onConnectivityChanged;
    connectivityStream.listen((_) => checkConnection());
    checkConnection();

    NotificationFirebaseService.messagesStream.listen((message) { 

      final snack = CustomSnackbar(null, message: message);
      ScaffoldMessenger.of(context).showSnackBar(snack);
    });
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

    return Consumer<ThemeProvider>( builder: (context, themeProvider, _) {
      return MaterialApp.router(
        title: 'Centro de viajes',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeProvider.themeMode,
      );
    });
        
  }
}
