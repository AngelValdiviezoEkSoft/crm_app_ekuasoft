
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

String dirProsp = '';
ProspectoType? varObjProspecUbicReg;

String apiKeyMapaUbic = '';

ColorsApp objColoresAppMapaUbicacionReg = ColorsApp();

LatLng? objLatLngRecibido;

//ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  ProspectoType? varObjProspMap;
  String? direccionProspecto;
  //String? apiKeyMapaUbic;

  MapScreen(Key? key,{varObjProspMap, direccionProspecto, apiKeyMapaUbic}) : super(key: key){
    if(varObjProspMap != null) {
      varObjProspecUbicReg = varObjProspMap;
    }

    if(direccionProspecto != null && direccionProspecto != '') {
      dirProsp = direccionProspecto;
    }

    if (Platform.isAndroid) {
      apiKeyMapaUbic = EnvironmentsProd().apiKeyGMapAndroid;
      //print(apiKeyMapaUbic);
    } else {
      apiKeyMapaUbic = EnvironmentsProd().apiKeyGMapIos;
    }
  }

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;
  ProspectoType? varObjProspect = varObjProspecUbicReg;
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
    generateMarkers();
  }

  generateMarkers() async {
    double latLlegada = 0;
    double lonLlegada = 0;
    List<LocalidadType> lstLocalidades = [];
    
    //-2.193906, -79.882928 //UNICENTRO
    //-2.194379, -79.762934 //DC

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
        latitud: -2.193906,
        longitud: -79.882928,
        /*
        latitud: -2.194379,
        longitud: -79.762934
        */        
        /*
        latitud: -2.1510772,
        longitud: -79.8887465         
        */
        /*
        latitud: -2.151117,
        longitud: -79.889141
          
        */
        /*
        latitud: -2.194837,
        longitud: -79.763805
        */
      )
    );

    for(int i = 0; i < lstLocalidades.length; i++) {
      //respDistancia = calculateDistance(locationState.lastKnownLocation!.latitude,locationState.lastKnownLocation!.longitude,lstLocalidadVerifica?[i].latitud ?? 0,lstLocalidadVerifica?[i].longitud ?? 0,);
      latLlegada = lstLocalidades[i].latitud;
      lonLlegada = lstLocalidades[i].longitud;
    }

    final marcadorDestino = Marker(
      markerId: const MarkerId('end'),
      position: LatLng(latLlegada,lonLlegada),
      //icon: 'Icons.map',//Para cambiar el ícono
    );

    //final Uint8List markerIcon = await getBytesFromAsset(data[i]['assetPath'], 125);

    _markers["1"] = Marker(
        markerId: const MarkerId("1"),
        position: marcadorDestino.position,
        icon: BitmapDescriptor.defaultMarker,//BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          showDialog(
            barrierColor: Colors.transparent.withOpacity(0.2),
            context: context,
            builder: (BuildContext context) {
              final size = MediaQuery.of(context).size;
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                alignment: Alignment.bottomCenter,
                content: Container(
                    color: Colors.transparent,
                    height: size.height * 0.25,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        /*
                        Container(
                          color: Colors.transparent,
                          child: Image.asset(
                            width: size.width * 0.12,
                            data[i]['assetPath'].toString(),
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        */
                        Container(
                          width: size.width * 0.5,
                          height: size.height * 0.25,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BaseText(                                
                                null,
                                'Guayaquil',
                                size: 0.035,
                                weight: FontWeight.w500,
                                color: ColorsApp().gris600EtiquetasCvs,
                                align: TextAlign.left,
                              ),
                              Container(
                                width: size.width * 0.55,
                                height: size.height * 0.12,
                                color: Colors.transparent,
                                alignment: Alignment.topLeft,
                                child: const BaseText(
                                  null,
                                  'EDIFICIO: UNICENTRO, Clemente Ballén 406 Y, Guayaquil 090313',                                  
                                  size: 0.04,
                                  maxlines: 3,
                                  align: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                actionsAlignment: MainAxisAlignment.center,
              );
            },
          );
        },
      );
    
    setState(() {});

    /*
    for (var i = 0; i < data.length; i++) {
      final Uint8List markerIcon =
          await getBytesFromAsset(data[i]['assetPath'], 125);
      _markers[i.toString()] = Marker(
        markerId: MarkerId(i.toString()),
        position: data[i]['position'],
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          showDialog(
            barrierColor: Colors.transparent.withOpacity(0.2),
            context: context,
            builder: (BuildContext context) {
              final size = MediaQuery.of(context).size;
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                alignment: Alignment.bottomCenter,
                content: Container(
                    color: Colors.transparent,
                    height: size.height * 0.12,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Container(
                          color: Colors.transparent,
                          child: Image.asset(
                            width: size.width * 0.12,
                            data[i]['assetPath'].toString(),
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: size.width * 0.5,
                          height: size.height * 0.12,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BaseText(
                                'Guayaquil',
                                null,
                                size: 0.035,
                                weight: FontWeight.w500,
                                color: CorpColors().gris600EtiquetasPlux,
                                align: TextAlign.left,
                              ),
                              Container(
                                width: size.width * 0.55,
                                height: size.height * 0.06,
                                color: Colors.transparent,
                                alignment: Alignment.topLeft,
                                child: const BaseText(
                                  'Dir 1',
                                  null,
                                  size: 0.04,
                                  maxlines: 2,
                                  align: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                actionsAlignment: MainAxisAlignment.center,
              );
            },
          );
        },
      );
      setState(() {});
    }
    */
  }

/*
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
  */

  @override
  void dispose() {
    super.dispose();
    locationBloc.stopFollowingUser();
  }
  
  @override
  Widget build(BuildContext context) {
    final searchBloc   = BlocProvider.of<SearchBloc>(context); 
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final size = MediaQuery.of(context).size;
    
    return WillPopScope(
      onWillPop: () async => false,
      child: 
      BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return state.isGpsEnabled ?
          Scaffold(
            
            body: BlocBuilder<GpsBloc, GpsState>(
              builder: (context, state) {
                return 
                  BlocBuilder<LocationBloc, LocationState>(
                    builder: (context, locationState) {
                      
                      if (locationState.lastKnownLocation == null) {
                        return const Center(child: Text('Espere por favor...')); 
                      }
              
                      return BlocBuilder<MapBloc, MapState>(
                        builder: (context, mapState) {
              
                          Map<String, Polyline> polylines = Map.from( mapState.polylines );
                          
                          if ( !mapState.showMyRoute ) {
                            polylines.removeWhere((key, value) => key == 'myRoute');
                          }
          
                          return BlocBuilder<SearchBloc, SearchState>(
                            builder: (context, stateSearch) {
                              return BlocBuilder<SuscripcionBloc, SuscripcionState>(
                                builder: (context, stateSuscripcion) {
          
                                if(stateSuscripcion.direccionUser.isNotEmpty && stateSearch.places.length - 1 >= 0) {
                                  locationBloc.stopFollowingUser();
                                  //List<Feature> nuevaLista = [];
                                  List<Candidate> nuevaLista = [];
                                  
                                  for(int i = 0; i < stateSearch.places.length; i++) {
                                    if(stateSearch.places[i].text != '' && stateSearch.places[i].text!.toLowerCase().contains(dirProsp) && nuevaLista.length - 1 < 0) {
                                      nuevaLista.add(stateSearch.places[i]);
                                      break;
                                    }
                                  }
          
                                  /*
                                  if(stateSearch.places.length - 1 >= 1) {
                                    nuevaLista.add(stateSearch.places[1]);
                                  }
          
                                  if(stateSearch.places.length - 1 == 0) {
                                    nuevaLista.add(stateSearch.places[0]);
                                  }
          */
                                  
                                  if(nuevaLista.length - 1 < 0) {
                                    objLatLngRecibido = null;
                                  } else {
                                    final result = SearchResult(
                                      cancel: false,
                                      manual: false,
                                      //position: LatLng(nuevaLista[0].center![1], nuevaLista[0].center![0]),
                                      position: LatLng(nuevaLista[0].geometry.location.lat, nuevaLista[0].geometry.location.lng),
                                      name: nuevaLista[0].text,
                                      description: nuevaLista[0].direccion
                                    );
          
                                    if(stateSuscripcion.direccionUser.isEmpty && stateSearch.places.length - 1 < 0) {
                                      searchBloc.add(AddToHistoryEvent(stateSearch.places[0]));
                                    }
          
                                    final userLocation = result.position;
                                    objLatLngRecibido = userLocation;
                                    mapBloc.moveCamera(userLocation!);
                                  }
                                }
          
                                  return SingleChildScrollView(
                                  child: Stack(
                                    children: [
          
                                      MapView(
                                        null,
                                        markers: _markers.values.toSet(),
                                        //initialLocation: stateSuscripcion.direccionUser.isNotEmpty && objLatLngRecibido != null ? objLatLngRecibido! : locationState.lastKnownLocation!,
                                        initialLocation: locationState.lastKnownLocation!,
                                        //markers: mapState.markers.values.toSet(),//con este vale
                                        circleLlegada: const {},
                                        llegadaLocation: const LatLng(0, 0),
                                      ),
          
                                      SearchBarWidgetMap(null, varFiltroBusqueda: dirProsp, varApiKey: apiKeyMapaUbic),
                                  
                                      ManualMarker(null, varObjProspEnt: varObjProspect),
          
                                      const Positioned(
                                        top: 90,
                                        left: 20,
                                        child: BtnBackMapaUbicacionReg(null)
                                      ),
          
                                      Positioned(
                                        bottom: size.height * 0.04,//70
                                        left: size.width * 0.05,//37,
                                        child: FadeInUp(
                                          duration: const Duration( milliseconds: 300 ),
                                          child: MaterialButton(
                                            minWidth: size.width * 0.9,
                                            color: objColoresAppMapaUbicacionReg.naranjaIntenso,
                                            elevation: 0,
                                            height: 50,
                                            shape: const StadiumBorder(),
                                            onPressed: () async {
                                              final gpsBloc = BlocProvider.of<GpsBloc>(context);
                                            
                                              // Todo: loading
                                              final start = locationBloc.state.lastKnownLocation;
                                              if ( start == null ) return;
          
                                              final end = mapBloc.mapCenter;
                                              if ( end == null ) return;
          
                                              searchBloc.add(OnDeactivateManualMarkerEvent());
          
                                              //bool varTieneUbicacion = true;
          
                                              var latFin = end.latitude;
                                              var lonFin = end.longitude;
          
                                              List<Placemark> placemarks = await placemarkFromCoordinates(latFin, lonFin);
                                              final direccion = '${placemarks[0].country},${placemarks[0].locality},${placemarks[0].street}';
          
                                              gpsBloc.vuelvePantallaFrm(true,true,true); 
                                              
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setString("coordenadasIngreso",'${end.latitude},${end.longitude}');
                                              prefs.setString("direccionEscogida",'$direccion ');
          
                                              const storage = FlutterSecureStorage();
                                              String esEdicion = await storage.read(key: 'esEdicionData') ?? '';
          
                                              //ignore: use_build_context_synchronously
                                              context.pop();
          
                                              if(esEdicion.isNotEmpty && esEdicion == 'S') {
                                                /*
                                                Color coloresTextoRepuesta = Colors.transparent;
                                                Color coloresFondoRepuesta = Colors.transparent;                                            
          
                                                String cedulaTmp = await storage.read(key: 'cedula') ?? '';
                                                              
                                                ClientTypeResponse objRps = await UserFormService().editaDataPerfil(objDataPersonalGen!);
                                                
                                                if(objRps.succeeded) {
                                                  coloresTextoRepuesta = Colors.white;
                                                  coloresFondoRepuesta = Colors.green;
                                                } else {
                                                  coloresTextoRepuesta = Colors.white;
                                                  coloresFondoRepuesta = Colors.red;
                                                }
          
                                                Fluttertoast.showToast(
                                                  msg: objRps.message,
                                                  toastLength: Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 5,
                                                  backgroundColor: coloresFondoRepuesta,//Colors.red,
                                                  textColor: coloresTextoRepuesta,//Colors.white,
                                                  fontSize: 16.0
                                                );
          
                                                Future.microtask(() => Navigator.pushReplacement(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (_, __, ___) => ActualizacionDatosScreen(varObjUserEnter: objUserActualizacionDatos),
                                                    transitionDuration: const Duration(seconds: 0),
                                                  ))
                                                );
                                                */
                                              }
                                              
                                            },
                                            child: const Text('Confirma tu ubicación', style: TextStyle( color: Colors.white, fontSize: 15 )),
                                          ),
                                        )
                                      ),
                                    
                                    ],
                                  ),
                                );
                                }
                              );
                            }
                          );
                        },
                      );
                    },
                  );
                  
              }
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BtnCurrentLocation(null),
              ],
            ),
          )
          :
          const EnableGpsMessage(null);
        }
      )
    
    );
  }


}

class BtnBackMapaUbicacionReg extends StatelessWidget {
  
  const BtnBackMapaUbicacionReg(
    Key? key
  ) : super(key: key);

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
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("coordenadasIngreso",'');
            gpsBloc.vuelvePantallaFrm(false,true,true);

            // ignore: use_build_context_synchronously
            BlocProvider.of<SearchBloc>(context).add(
              OnDeactivateManualMarkerEvent()
            );

            //ignore: use_build_context_synchronously
            context.pop();

          },
        ),
      ),
    );
  }
}
