
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crm_ekuasoft_app/app/app.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:secure_application/secure_application.dart';
import 'package:provider/src/change_notifier_provider.dart' as np;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

String rutaActualGen = '';
final GlobalKey<ListaProspectosScreenState> listaProspectosKey = GlobalKey<ListaProspectosScreenState>();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupServiceLocator();

  await initializeDateFormatting();

  runApp( 
    MultiBlocProvider(
      providers: [//
      
        np.ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
        BlocProvider(create: (context) => getIt<AuthBloc>()..add(AppStarted())),
        BlocProvider(create: (context) => getIt<VerificacionBloc>()),
        BlocProvider(create: (context) => getIt<GenericBloc>()),
        BlocProvider(create: (context) => getIt<SuscripcionBloc>()),
        BlocProvider(create: (context) => getIt<LocationBloc>()),
        BlocProvider(create: (context) => getIt<GpsBloc>()),
        BlocProvider(create: (context) => getIt<MapBloc>()),
        BlocProvider(create: (context) => getIt<SearchBloc>()),
        BlocProvider(create: (context) => getIt<ActivitiesBloc>()),

      ],
      child: ProviderScope(
        child: SecureApplication(
          secureApplicationController: SecureApplicationController(
            SecureApplicationState(
              secured: true, 
              locked: true
            )
          ),
          child: const CrmEkuasoftApp(null)
        )
      ),
    )
  );
}