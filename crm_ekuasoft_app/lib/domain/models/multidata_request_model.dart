class MultiDataRequestModel {
    String? key;
    String? tocken;
    String? imei;
    int? uid;
    int? company;
    String? bearer;
    String? tockenValidDate;
    MultiDataRequestModelEspecifico? models;
}

class MultiDataRequestModelEspecifico {
    String? model;
    List<FiltrosMultiDataRequestModelEspecifico> filters = [];

}

class FiltrosMultiDataRequestModelEspecifico {
    String? model;
    String? filters;

}