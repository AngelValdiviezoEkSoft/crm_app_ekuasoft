import 'package:bloc/bloc.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

part 'search_event.dart';
part 'search_state.dart';

final DireccionesService direccionesService = DireccionesService();

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;
  

  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: true)));
    on<OnDeactivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: false)));

    /*
    on<OnNewPlacesFoundEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));
        */

    on<OnNewPlacesFoundEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));

    on<AddToHistoryEvent>((event, emit) =>
        emit(state.copyWith(history: [event.place, ...state.history])));
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

    // Información del destino
    final endPlace = await trafficService.getInformationByCoors(end);

    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;

    // Decodificar
    final points = decodePolyline(geometry, accuracyExponent: 6);

    final latLngList = points
        .map((coor) => LatLng(coor[0].toDouble(), coor[1].toDouble()))
        .toList();

    return RouteDestination(
      points: latLngList,
      duration: duration,
      distance: distance,
      endPlace: endPlace,
    );
  }

  Future getPlacesByQuery(LatLng? proximity, String query, String apiKey, String nombreDireccion) async {    
    /*
    final newPlaces = await direccionesService.getResultsByGoogle(query, apiKey, nombreDireccion);
    //newPlaces[0].
    add(OnNewPlacesFoundEvent(newPlaces));
    */
    final newPlaces = await direccionesService.getResultsByGoogle(query);
    add(OnNewPlacesFoundEvent(newPlaces));
    //print('Test: $newPlaces');
  }

  Future<List<Location>?> searchAddress(String query) async {
    List<Location>? locations;
    try {
      locations = await locationFromAddress(query);
      
    } catch (e) {
      
      locations = [];
    }

    return locations;
  }

  Future getPlacesByQueryGoogle(String coordenadas) async {
    /*
    final newPlaces = await trafficService.getResultsByQueryGoogleMap(coordenadas);
    add(OnNewPlacesFoundEvent(newPlaces));
    */
  }

  Future getPlacesByQueryDireccion(LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultsByQuery(proximity, query);
    LatLng objRsp = const LatLng(-79.85266614975556, -2.2151049777572496);
    objRsp = LatLng(
      double.parse(newPlaces[0].geometry!.coordinates![0].toString()),
      double.parse(newPlaces[0].geometry!.coordinates![1].toString())
    );
    
    return objRsp;
  }
}
