//import 'dart:convert';

/*
class ConsultaDireccionResponseModel {
  List<Candidate> candidates;
  String status;

  ConsultaDireccionResponseModel({
      required this.candidates,
      required this.status,
  });

  factory ConsultaDireccionResponseModel.fromJson(String str) => ConsultaDireccionResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConsultaDireccionResponseModel.fromMap(Map<String, dynamic> json) => ConsultaDireccionResponseModel(
      candidates: List<Candidate>.from(json["candidates"].map((x) => Candidate.fromJson(x))),
      status: json["status"],
  );

  Map<String, dynamic> toMap() => {
      "candidates": List<dynamic>.from(candidates.map((x) => x.toJson())),
      "status": status,
  };
}

class Candidate {
    GeometryDir geometry;

    Candidate({
        required this.geometry,
    });

    factory Candidate.fromJson(String str) => Candidate.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Candidate.fromMap(Map<String, dynamic> json) => Candidate(
        geometry: GeometryDir.fromJson(json["geometry"]),
    );

    Map<String, dynamic> toMap() => {
        "geometry": geometry.toJson(),
    };
}

class GeometryDir {
    LocationDir location;
    Viewport viewport;

    GeometryDir({
        required this.location,
        required this.viewport,
    });

    factory GeometryDir.fromJson(String str) => GeometryDir.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GeometryDir.fromMap(Map<String, dynamic> json) => GeometryDir(
        location: LocationDir.fromJson(json["location"]),
        viewport: Viewport.fromJson(json["viewport"]),
    );

    Map<String, dynamic> toMap() => {
        "location": location.toJson(),
        "viewport": viewport.toJson(),
    };
}

class LocationDir {
    double lat;
    double lng;

    LocationDir({
        required this.lat,
        required this.lng,
    });

    factory LocationDir.fromJson(String str) => LocationDir.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory LocationDir.fromMap(Map<String, dynamic> json) => LocationDir(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "lat": lat,
        "lng": lng,
    };
}

class Viewport {
    LocationDir northeast;
    LocationDir southwest;

    Viewport({
        required this.northeast,
        required this.southwest,
    });

    /* 
  factory ClientTypeResponse.fromJson(String str) => ClientTypeResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ClientTypeResponse.fromMap(Map<String, dynamic> json) => ClientTypeResponse(
  */

    factory Viewport.fromJson(String str) => Viewport.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Viewport.fromMap(Map<String, dynamic> json) => Viewport(
        northeast: LocationDir.fromJson(json["northeast"]),
        southwest: LocationDir.fromJson(json["southwest"]),
    );

    Map<String, dynamic> toMap() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
    };
}
*/

class ConsultaDireccionResponseModel {
  final List<Candidate> candidates;
  final String status;
  String nombreLugar;

  ConsultaDireccionResponseModel({required this.candidates, required this.status, required this.nombreLugar});

  factory ConsultaDireccionResponseModel.fromJson(Map<String, dynamic> json) {
    return ConsultaDireccionResponseModel(
      candidates: (json['candidates'] as List<dynamic>)
          .map((e) => Candidate.fromJson(e))
          .toList(),
      status: json['status'] ?? '',
      nombreLugar: ''
    );
  }
}

class Candidate {
  final GeometryDir geometry;
  String? text;
  String? placeName;
  String? direccion;

  Candidate({
    required this.geometry,
    required this.text,
    required this.placeName,
    required this.direccion
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      geometry: GeometryDir.fromJson(json['geometry']),
      text: '',
      placeName: '',
      direccion: ''
    );
  }
}

class GeometryDir {
  final LocationDir location;
  final Viewport viewport;

  GeometryDir({required this.location, required this.viewport});

  factory GeometryDir.fromJson(Map<String, dynamic> json) {
    return GeometryDir(
      location: LocationDir.fromJson(json['location']),
      viewport: Viewport.fromJson(json['viewport']),
    );
  }
}

class LocationDir {
  final double lat;
  final double lng;

  LocationDir({required this.lat, required this.lng});

  factory LocationDir.fromJson(Map<String, dynamic> json) {
    return LocationDir(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Viewport {
  final LocationDir northeast;
  final LocationDir southwest;

  Viewport({required this.northeast, required this.southwest});

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: LocationDir.fromJson(json['northeast']),
      southwest: LocationDir.fromJson(json['southwest']),
    );
  }
}
