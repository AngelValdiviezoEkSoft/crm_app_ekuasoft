import 'dart:convert';
import 'dart:io';
import 'package:crm_ekuasoft_app/config/config.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class DireccionesService {
  /*
  Future<List<Feature>> getResultsByGoogle(String query, String apiKey, String nombreDireccion) async {
    try {
      List<Feature> lstFeatures = [];
      if (query.isEmpty) return [];
      
      List<PlaceField> placeFields = [
        PlaceField.Address,
        PlaceField.AddressComponents,
        PlaceField.BusinessStatus,
        PlaceField.Id,
        PlaceField.Location,
        PlaceField.Name,
        PlaceField.OpeningHours,
        PlaceField.PhoneNumber,
        PlaceField.PhotoMetadatas,
        PlaceField.PlusCode,
        PlaceField.PriceLevel,
        PlaceField.Rating,
        PlaceField.Types,
        PlaceField.UserRatingsTotal,
        PlaceField.UTCOffset,
        PlaceField.Viewport,
        PlaceField.WebsiteUri,
      ];

      if (Platform.isAndroid) {
        apiKey = EnvironmentsProd().apiKeyGMapAndroid;        
      } 
      
      if(Platform.isIOS) {
        apiKey = EnvironmentsProd().apiKeyGMapIos;
      }

      final places = FlutterGooglePlacesSdk(apiKey);
      final predictions = await places.findAutocompletePredictions(query.trim());
            
      if(predictions.predictions.length - 1 > 0) {
        for(int i = 0; i < predictions.predictions.length; i++) { 
          if(predictions.predictions[i].fullText.toLowerCase().contains('ecuador')) {
            final predictions2 = await places.fetchPlace(predictions.predictions[i].placeId,fields: placeFields);
            
            final ubicacionLatLong = predictions2.place!.latLng!;
              
            double latitud = double.parse(ubicacionLatLong.toString().split(',')[0].split(':')[1]);
            double longitud = double.parse(ubicacionLatLong.toString().split(',')[1].split(':')[1].split('}')[0]);

            Feature objFeatures = Feature();

            List<double> lstCoordenadas = [];
            lstCoordenadas.add(longitud);
            lstCoordenadas.add(latitud);
            
            objFeatures = Feature(
              text: predictions.predictions[i].primaryText,
              placeName: predictions.predictions[i].secondaryText,
              center: lstCoordenadas,
              geometry: Geometry(coordinates: lstCoordenadas)
            );
            lstFeatures.add(objFeatures);
          }
        }
      }

      return lstFeatures;
    } catch (e) {
      //print('Error en la búsqueda de direcciones en los mapas: $e');
      return [];
    }
  }

  Future<Feature?> getResultsByQueryGoogleMap(String newLocation, String nombreDireccion) async {
    try {
      if (newLocation.isEmpty) return null;

      double latitud = double.parse(newLocation.split(',')[0].split(':')[1]);
      double longitud = double.parse(newLocation.split(',')[1].split(':')[1].split('}')[0]);

      List<Feature>? features = [];

      Feature objFeatures = Feature();

      List<double> lstCoordenadas = [];
      lstCoordenadas.add(longitud);
      lstCoordenadas.add(latitud);
      
      objFeatures = Feature(
        text: nombreDireccion,
        placeName: nombreDireccion,
        center: lstCoordenadas,
        geometry: Geometry(coordinates: lstCoordenadas)
      );

      features.add(objFeatures);

      return objFeatures;
    } catch (e) {
      return null;
    }
  }

  
*/
  Future<List<Candidate>> getResultsByGoogle(String query) async {
    String apiKey = '';

    if (Platform.isAndroid) {
      apiKey = EnvironmentsProd().apiKeyGMapAndroid;
      //print(apiKeyMapaUbic);
    } else {
      apiKey = EnvironmentsProd().apiKeyGMapIos;
    }

    if (query.isEmpty) {
      
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$query&inputtype=textquery&fields=geometry&key=$apiKey',
        ),
      );     

      final response2 = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$apiKey',
        ),
      );

      var dec2 = jsonDecode(response2.body);

      //print('Test: $dec2');

      var dec = jsonDecode(response.body);

      final objResp = ConsultaDireccionResponseModel.fromJson(dec);
      objResp.nombreLugar = query;
      objResp.candidates[0].direccion = dec2['results'][0]['formatted_address'];
      objResp.candidates[0].text = objResp.candidates[0].text == null || objResp.candidates[0].text!.isEmpty ? query : objResp.candidates[0].text;

      return objResp.candidates;
      
    } catch (e) {
      //print('Error al buscar direcciones: $e');
      return [];
    }
  }
}


