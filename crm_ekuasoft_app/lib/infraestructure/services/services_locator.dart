import 'package:get_it/get_it.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  //#Region Servicios 
  getIt.registerLazySingleton<LocalidadService>(() => LocalidadService());
  getIt.registerLazySingleton<ProspectoTypeService>(() => ProspectoTypeService());
  //#EndRegion

  //#Region Blocs 
  getIt.registerLazySingleton(() => VerificacionBloc());
  getIt.registerLazySingleton(() => GenericBloc());
  getIt.registerLazySingleton(() => AuthBloc());
  getIt.registerLazySingleton(() => SuscripcionBloc());
  
  getIt.registerLazySingleton(() => LocationBloc());
  getIt.registerLazySingleton(() => GpsBloc());
  
  getIt.registerLazySingleton(() => MapBloc(
    locationBloc: LocationBloc()
  ));
  
  getIt.registerLazySingleton(() => SearchBloc(
    trafficService: TrafficService()
  ));
  //#EndRegion
}
