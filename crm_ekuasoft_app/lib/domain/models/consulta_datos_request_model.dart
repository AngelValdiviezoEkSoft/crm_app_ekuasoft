

class ConsultaDatosRequestModel {
    ConsultaDatosRequestModel({      
      required this.key,
      required this.imei,
      required this.token,
      required this.uid,
      required this.company,
      required this.bearer,
      required this.tokenValidDate
    });

    String key;
    String token;
    String imei;
    String uid;
    String company;
    String bearer;
    String tokenValidDate;

}