import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

bool comienzaEditarFechaCierre = false;
bool comienzaEditarCorreo = false;
bool comienzaEditarDireccion = false;
bool comienzaEditarNombres = false;
bool comienzaEditarNombresContacto = false;
bool comienzaEditarRecomendacion = false;
bool comienzaEditarProbabilidad = false;
bool comienzaEditarIngEsp = false;
bool comienzaEditarObservacon = false;
bool comienzaEditarPais = false;
bool comienzaEditarCampania= false;
bool comienzaEditarOrigen = false;
bool comienzaEditarMedio = false;

DatumCrmLead? objDatumCrmLeadEdit;
int idProsp = 0;
int tabAccionesEditPrsp = 0;

late TextEditingController nombresEditTxt;
late TextEditingController nombresOportEditTxt;
late TextEditingController emailEditTxt;
late TextEditingController direccionEditTxt;
late TextEditingController observacionesEditTxt;
late TextEditingController paisEditTxt;
late TextEditingController probabilityEditTxt;
late TextEditingController telefonoEditTxt;
late TextEditingController sectorEditTxt;
late TextEditingController ingresoEsperadoEditTxt;
late TextEditingController recomendadoPorEditTxt;
late TextEditingController fechaCierreEditxt;

String rutaFinal = '';

DateTime dateEdPrsp = DateTime.now();

String campEditSelect = '';
String mediaEditSelect = '';
String originEditSelect = '';
String actEditSelect = '';
String paisEditSelect = '';
bool prspAsignado = false;

class FrmEditProspectoScreen extends StatefulWidget {
  const FrmEditProspectoScreen({super.key});

  @override
  State<FrmEditProspectoScreen> createState() => _FrmEditProspectoScreenState();
}

class _FrmEditProspectoScreenState extends State<FrmEditProspectoScreen> {

  late final WebViewController _wvController;
  final LocalAuthentication auth = LocalAuthentication();  

  String initialCountry = 'EC';
  PhoneNumber number = PhoneNumber(isoCode: 'EC');
  
  @override
  void initState() {
    super.initState();
    comienzaEditarFechaCierre = false;
    comienzaEditarCorreo = false;
    comienzaEditarDireccion = false;
    comienzaEditarNombres = false;
    comienzaEditarNombresContacto = false;
    comienzaEditarRecomendacion = false;
    comienzaEditarProbabilidad = false;
    comienzaEditarIngEsp = false;
    comienzaEditarObservacon = false;
    comienzaEditarPais = false;
    comienzaEditarCampania = false;
    comienzaEditarOrigen = false;
    comienzaEditarMedio = false;
    objActividadEscogida = null;

    nombresEditTxt = TextEditingController();
    nombresOportEditTxt = TextEditingController();
    emailEditTxt = TextEditingController();
    direccionEditTxt = TextEditingController();
    observacionesEditTxt = TextEditingController();
    paisEditTxt = TextEditingController();
    probabilityEditTxt = TextEditingController();
    ingresoEsperadoEditTxt = TextEditingController();
    recomendadoPorEditTxt = TextEditingController();
    fechaCierreEditxt = TextEditingController();
    
    telefonoEditTxt = TextEditingController();
    sectorEditTxt = TextEditingController(text: 'Norte');

    rutaFinal = '';
    tabAccionesEditPrsp = 0;

    if(objDatumCrmLead != null){
      objDatumCrmLeadEdit = objDatumCrmLead;
      //nombresEditTxt.text = objDatumCrmLeadEdit!.contactName ?? '';
      //emailEditTxt.text = objDatumCrmLeadEdit!.emailFrom;
      //direccionEditTxt.text = objDatumCrmLeadEdit!.street ?? '';
      //observacionesEditTxt.text = objDatumCrmLeadEdit!.description ?? '';
      //probabilityEditTxt.text = objDatumCrmLeadEdit!.probability?.toString() ?? "0";

      String cell = separatePhoneNumber(objDatumCrmLeadEdit!.phone ?? '');

      telefonoEditTxt.text = cell;
      //recomendadoPorEditTxt.text = objDatumCrmLeadEdit!.referred ?? '';

      rutaFinal = objDatumCrmLeadEdit!.description ?? '';

      if(rutaFinal.isNotEmpty){
        _wvController = WebViewController();

        _wvController.loadHtmlString(rutaFinal);
      }

      if(objDatumCrmLeadEdit!.userId != null && objDatumCrmLeadEdit!.userId!.name.isNotEmpty){
        prspAsignado = true;
      }

    }

  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  //final String phoneNumber = "+123456789012"; // Número de ejemplo

  String separatePhoneNumber(String phone) {
    // Expresión regular para dividir el prefijo y el número
    //final regExp = RegExp(r'^\+?(\d{1,4})(\d+)$');
    final regExp = RegExp(r'^\+?(\d{1,3})(\d+)$');
    final match = regExp.firstMatch(phone);

    if (match != null) {
      final localNumber = match.group(2); // Número local
      return localNumber ?? '';
      /*
      return {
        "countryCode": countryCode ?? "",
        "localNumber": localNumber ?? "",
      };
      */
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {

    //ColorsApp objColorsApp = ColorsApp();

    //ScrollController scrollListaClt = ScrollController();

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Edición de Prospecto'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {
          
          return FutureBuilder(
            future: state.readCombosGen(),
            builder: (context, snapshot) {
              
              if(!snapshot.hasData) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Image.asset(
                      "assets/gifs/gif_carga.gif",
                      height: size.width * 0.85,//150.0,
                      width: size.width * 0.85,//150.0,
                    ),
                  ),
                );
              }
              else{
                if(snapshot.data != null) {
                  String fecEditCierre = '';
                  List<String> lstPaises = [];
                  List<String> lstActividades = [];
                  List<String> lstMedias = [];
                  List<String> lstCampanias = [];
                  List<String> lstOrigenes = [];                                    

                  fecEditCierre = DateFormat('yyyy-MM-dd', 'es').format(DateTime.now());

                  if(!comienzaEditarFechaCierre){                    

                    if(objDatumCrmLeadEdit != null ){
                      fecEditCierre = objDatumCrmLeadEdit!.dateDeadline != null ? DateFormat('yyyy-MM-dd', 'es').format(objDatumCrmLeadEdit!.dateDeadline!) : '-- No tiene fecha de cierre --';
                      fechaCierreEditxt.text = fecEditCierre;
                    }
                    
                  }

                  if(!comienzaEditarCorreo){
                    emailEditTxt.text = objDatumCrmLeadEdit!.emailFrom;
                  }

                  if(!comienzaEditarNombresContacto){
                    //nombresEditTxt.text = objDatumCrmLeadEdit!.name;
                    nombresEditTxt.text = objDatumCrmLeadEdit!.contactName ?? '';
                  }

                  if(!comienzaEditarNombres){
                    //nombresOportEditTxt.text = objDatumCrmLeadEdit!.contactName ?? '';
                    nombresOportEditTxt.text = objDatumCrmLeadEdit!.name;
                  }

                  if(!comienzaEditarDireccion){
                    direccionEditTxt.text = objDatumCrmLeadEdit!.street ?? '';
                  }

                  if(!comienzaEditarRecomendacion){
                    recomendadoPorEditTxt.text = objDatumCrmLeadEdit!.referred ?? '';
                  }

                  if(!comienzaEditarProbabilidad){
                    probabilityEditTxt.text = objDatumCrmLeadEdit!.probability?.toString() ?? "0";
                  }

                  if(!comienzaEditarIngEsp){
                    ingresoEsperadoEditTxt.text = objDatumCrmLeadEdit!.expectedRevenue.toString();
                  }

                  if(!comienzaEditarObservacon){
                    observacionesEditTxt.text = objDatumCrmLeadEdit!.description ?? '';
                  }

                  String rspCombos = snapshot.data as String;

                    ProspectoCombosModel objTmp = ProspectoCombosModel(
                      campanias: rspCombos.split('---')[0],
                      origen: rspCombos.split('---')[1],
                      medias: rspCombos.split('---')[2],
                      actividades: rspCombos.split('---')[3],
                      paises: rspCombos.split('---')[4],
                      lstActividades: ''
                    );

                    var objCamp = json.decode(objTmp.campanias);
                    //var objCamp2 = json.decode(objCamp);

                    var objMedia = json.decode(objTmp.medias);
                    //var objMedia2 = json.decode(objMedia);

                    var objOrigen = json.decode(objTmp.origen);
                    //var objOrigen2 = json.decode(objOrigen);

                    var objAct = json.decode(objTmp.actividades);
                    //var objAct2 = json.decode(objAct);

                    var objPais = json.decode(objTmp.paises);
                    //var objPai2 = json.decode(objPais);

                    var objCamp3 = objCamp['data'];//objCamp2['result']['data']['utm.campaign']['data'];
                    var objMedia3 = objMedia['data'];//objMedia2['result']['data']['utm.medium']['data'];
                    var objOrigen3 = objOrigen['data'];//objOrigen2['result']['data']['utm.source']['data'];
                    var objAct3 = objAct['data'];//objAct2['result']['data']['mail.activity.type']['data'];
                    var objPai3 = objPais['data'];//objPai2['result']['data']['res.country']['data'];

                    List<Map<String, dynamic>> mappedObjCamp3 = List<Map<String, dynamic>>.from(objCamp3);

                    lstCampanias = mappedObjCamp3
                    .map((item) => item["name"]?.toString() ?? '')
                    .toList();

                    List<Map<String, dynamic>> mappedObjMed3 = List<Map<String, dynamic>>.from(objMedia3);

                    lstMedias = mappedObjMed3
                        .map((item) => item["name"]?.toString() ?? '')
                        .toList();

                    List<Map<String, dynamic>> mappedObjOrig3 = List<Map<String, dynamic>>.from(objOrigen3);

                    lstOrigenes = mappedObjOrig3
                        .map((item) => item["name"]?.toString() ?? '')
                        .toList();

                    List<Map<String, dynamic>> mappedObjAct3 = List<Map<String, dynamic>>.from(objAct3);

                    lstActividades = mappedObjAct3
                        .map((item) => item["name"]?.toString() ?? '')
                        .toList();

                    List<Map<String, dynamic>> mappedObjPais3 = List<Map<String, dynamic>>.from(objPai3);

                    lstPaises = mappedObjPais3
                        .map((item) => item["name"]?.toString() ?? '')
                        .toList();

                    if(actEditSelect.isEmpty){
                      actEditSelect = objDatumCrmLeadEdit!.activityIds.isNotEmpty ? objDatumCrmLeadEdit!.activityIds.first.name : lstActividades.first;
                    }

                    if(!comienzaEditarPais){
                      if(paisEditSelect.isEmpty){
                        //paisEditSelect = lstPaises.first;
                        paisEditSelect = objDatumCrmLeadEdit!.countryId.name.isNotEmpty ? objDatumCrmLeadEdit!.countryId.name : lstPaises.first;
                      }
                    }

                    if(!comienzaEditarCampania){
                      if(campEditSelect.isEmpty && objDatumCrmLeadEdit!.campaignId != null) {
                        campEditSelect = objDatumCrmLeadEdit!.campaignId!.name.isNotEmpty ? objDatumCrmLeadEdit!.campaignId!.name : lstCampanias.first;
                      }
                    }

                    if(!comienzaEditarOrigen){
                      if(originEditSelect.isEmpty){
                        //originEditSelect = lstOrigenes.first;
                        originEditSelect = objDatumCrmLeadEdit!.sourceId.name.isNotEmpty ? objDatumCrmLeadEdit!.sourceId.name : lstOrigenes.first;
                      }
                    }

                    if(!comienzaEditarMedio){
                      if(mediaEditSelect.isEmpty){
                        mediaEditSelect = objDatumCrmLeadEdit!.mediumId.name.isNotEmpty ? objDatumCrmLeadEdit!.mediumId.name : lstMedias.first;
                      }
                    }

                  return Stack(
                    children: [
                      Container(
                        color: Colors.transparent,
                        width: size.width * 0.99,
                        height: size.height * 0.91,
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [    
                          
                              Container(
                                //color: const Color(0xffF6F6F6),
                                color: Colors.transparent,
                                width: size.width,
                                height: size.height * 0.86,
                                alignment: Alignment.topCenter,
                                child: Column(
                                  children: [
                                
                                    Container(
                                      color: Colors.blue.shade800,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  color: tabAccionesEditPrsp == 0
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesEditPrsp = 0;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.info_outline,
                                                            color: tabAccionesEditPrsp == 0
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Inf. general',
                                                            style: TextStyle(
                                                              color: tabAccionesEditPrsp == 0
                                                                  ? Colors.blue.shade800
                                                                  : Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  color: tabAccionesEditPrsp == 1
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesEditPrsp = 1;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.grid_on_outlined,
                                                            color: tabAccionesEditPrsp == 1
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Inf. Adicional',
                                                            style: TextStyle(
                                                              //color: Colors.purple.shade700,
                                                              color: tabAccionesEditPrsp == 1
                                                                  ? Colors.blue.shade800
                                                                  : Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  color: tabAccionesEditPrsp == 2
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesEditPrsp = 2;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.add_business_rounded,
                                                            color: tabAccionesEditPrsp == 2
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Notas Int.',
                                                            style: TextStyle(
                                                              //color: Colors.purple.shade700,
                                                              color: tabAccionesEditPrsp == 2
                                                                  ? Colors.blue.shade800
                                                                  : Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                          
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                          
                                    Container(
                                      color: Colors.transparent,
                                      width: size.width * 0.92,
                                      child: InternationalPhoneNumberInput(
                                        isEnabled: false,
                                      onInputChanged: (PhoneNumber phoneNumber) async {
                                        
                                      },
                                      onInputValidated: (bool isValid) async {
                                        //print("¿Es válido?: $isValid");                                      
                                      },
                                      selectorConfig: const SelectorConfig(
                                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET, // Tipo de selector
                                      ),
                                      ignoreBlank: false,
                                      autoValidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: number,
                                      textFieldController: telefonoEditTxt,
                                      formatInput: true,
                                      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                      inputDecoration: InputDecoration(
                                        hintText: "Ingrese su número",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onSaved: (PhoneNumber phoneNumber) {
                                        //print('Número guardado: ${phoneNumber.phoneNumber}');
                                      },
                                      //isEnabled: false,
                                      maxLength: 11,
                                      errorMessage: 'Teléfono no válido',
                                    ),
                                    ),
                                    
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                
                                    if(tabAccionesEditPrsp == 0)
                                    Container(
                                      color: Colors.transparent,
                                      height: size.height * 0.55,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                                cursorColor: AppLightColors().primary,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,                                                
                                                inputFormatters: [
                                                  EmojiInputFormatter()
                                                ],
                                                textCapitalization: TextCapitalization.sentences,
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                decoration: InputDecorationCvs.formsDecoration(
                                                  labelText: 'Nombre de prospecto',
                                                  hintTetx: 'Ej: Juan Valdez',
                                                  size: size
                                                ),
                                                enabled: false,
                                                controller: nombresEditTxt,
                                                autocorrect: false,
                                                keyboardType: TextInputType.text,
                                                minLines: 1,
                                                maxLines: 2,
                                                autofocus: false,
                                                maxLength: 50,
                                                textAlign: TextAlign.left,
                                                onEditingComplete: () {
                                                  FocusScope.of(context).unfocus();
                                                  
                                                  setState(() {
                                                    comienzaEditarNombresContacto = true;
                                                  });
                                                },
                                                onChanged: (value) {
                                                  
                                                },
                                                onTapOutside: (event) {
                                                  FocusScope.of(context).unfocus();
                                                  setState(() {
                                                    comienzaEditarNombresContacto = true;
                                                  });
                                                },
                                              ),
                                            ),
                                      
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),

                                      Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                                cursorColor: AppLightColors().primary,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,                                                
                                                inputFormatters: [
                                                  EmojiInputFormatter()
                                                ],
                                                textCapitalization: TextCapitalization.sentences,
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                decoration: InputDecorationCvs.formsDecoration(
                                                  labelText: 'Nombre Oportunidad',
                                                  hintTetx: 'Ej: Juan Valdez',
                                                  size: size
                                                ),
                                                enabled: false,
                                                controller: nombresOportEditTxt,
                                                autocorrect: false,
                                                keyboardType: TextInputType.text,
                                                minLines: 1,
                                                maxLines: 2,
                                                autofocus: false,
                                                maxLength: 50,
                                                textAlign: TextAlign.left,
                                                onEditingComplete: () {
                                                  FocusScope.of(context).unfocus();
                                                  //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                                  setState(() {
                                                    comienzaEditarNombres = true;
                                                  });
                                                },
                                                onChanged: (value) {
                                                  
                                                },
                                                onTapOutside: (event) {
                                                  FocusScope.of(context).unfocus();
                                                  setState(() {
                                                    comienzaEditarNombres = true;
                                                  });
                                                },
                                              ),
                                            ),
                                      
                                      SizedBox(
                                        height: size.height * 0.04,
                                      ),
                          
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Seleccione el país',
                                            ),
                                            value: paisEditSelect,
                                            items: lstPaises
                                                .map((activityPrsp) =>
                                                    DropdownMenuItem(
                                                      value: activityPrsp,
                                                      child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                      //child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 1, maxFontSize: 12,),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              comienzaEditarPais = true;
                                              setState(() {
                                                paisEditSelect = value ?? '';
                                              });
                                                                      
                                            },
                                          ),
                                        ),
                                        
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      
                                      /*
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: TextFormField(
                                          controller: sectorEditTxt,
                                          //initialValue: 'Norte',
                                          enabled: false,
                                          cursorColor: AppLightColors().primary,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          style: AppTextStyles.bodyRegular(width: size.width),
                                          decoration: InputDecorationCvs.formsDecoration(
                                            labelText: 'Sector',
                                            hintTetx: 'Ej: Norte',
                                            size: size
                                          ),
                                          //controller: emailAkiTxt,
                                          autocorrect: false,
                                          keyboardType: TextInputType.text,
                                          minLines: 1,
                                          maxLines: 2,
                                          autofocus: false,
                                          maxLength: 50,
                                          textAlign: TextAlign.left,
                                          onEditingComplete: () {
                                            FocusScope.of(context).unfocus();
                                            //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                          },
                                          onChanged: (value) {
                                            
                                          },
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ),
                                      
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      */
                                      /*
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Asignado', style: TextStyle(fontSize: 20),),
                                            
                                            Checkbox(
                                              value: prspAsignado,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  prspAsignado = value ?? false;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      */
                                                                        
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Seleccione la campaña',
                                          ),
                                          value: campEditSelect,
                                          items: lstCampanias.map((activityPrsp) =>
                                            DropdownMenuItem(
                                              value: activityPrsp,
                                              child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                              //child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
                                            )
                                          )
                                          .toList(),
                                          onChanged: (String? newValue) {
                                            comienzaEditarCampania = true;
                                            setState(() {
                                              campEditSelect = newValue ?? '';
                                            });
                                          },
                                        ),
                                      ),
                                                                      
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                          
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText:
                                                'Seleccione el origen',
                                          ),
                                          value: originEditSelect,
                                          items: lstOrigenes
                                              .map((activityPrsp) =>
                                                  DropdownMenuItem(
                                                    value: activityPrsp,
                                                    child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                    //child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
                                                  ))
                                              .toList(),
                                          onChanged: (newValue) {
                                            comienzaEditarOrigen = true;
                                            setState(() {
                                              originEditSelect = newValue ?? '';
                                            });
                                          },
                                        ),
                                        ),
                                                                          
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                            
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                                      decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        labelText:
                                                            'Seleccione el medio',
                                                      ),
                                                      value: mediaEditSelect,
                                                      items: lstMedias
                                                          .map((activityPrsp) =>
                                                              DropdownMenuItem(
                                                                value: activityPrsp,
                                                                child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                                //child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
                                                              ))
                                                          .toList(),
                                                      onChanged: (newValue) {
                                                        comienzaEditarMedio = true;
                                                        setState(() {
                                              mediaEditSelect = newValue ?? '';
                                            });
                                                      },
                                                    ),
                                      ),
                                                                          
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                                                          
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: TextFormField(
                                          textCapitalization: TextCapitalization.sentences,
                                          inputFormatters: [
                                            EmojiInputFormatter()
                                          ],
                                          cursorColor: AppLightColors().primary,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,                                        
                                          style: AppTextStyles.bodyRegular(width: size.width),
                                          decoration: InputDecorationCvs.formsDecoration(
                                            labelText: 'Recomendado por',
                                            hintTetx: 'Ej: Norte',
                                            size: size
                                          ),
                                          controller: recomendadoPorEditTxt,
                                          autocorrect: false,
                                          keyboardType: TextInputType.text,
                                          minLines: 1,
                                          maxLines: 2,
                                          autofocus: false,
                                          maxLength: 50,
                                          textAlign: TextAlign.left,
                                          onEditingComplete: () {
                                            FocusScope.of(context).unfocus();
                                            //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                            setState(() {
                                              comienzaEditarRecomendacion = true;
                                            });
                                          },
                                          onChanged: (value) {
                                            
                                          },
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                            setState(() {
                                              comienzaEditarRecomendacion = true;
                                            });
                                          },
                                        ),
                                      ),
                                      
                                      SizedBox(
                                        height: size.height * 0.025,
                                      ),
                                                                
                                    ],
                                  ),
                                ),
                              ),
                                
                                    if(tabAccionesEditPrsp == 1)
                                    Container(
                                      color: Colors.transparent,
                                      height: size.height * 0.55,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(                               
                                                cursorColor: AppLightColors().primary,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                
                                                decoration: InputDecoration(
                                                  hintStyle: SafeGoogleFont(
                                                    GoogleFontsApp().fontMulish,
                                                    fontSize: size.width * 0.0025 * 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppLightColors().gray800SecondaryText,
                                                    letterSpacing: 0
                                                  ),
                                                  hintText: "100%",
                                                  suffixText: '%',
                                                  labelText: 'Probabilidad'
                                                ),
                                                controller: probabilityEditTxt,
                                                autocorrect: false,
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                minLines: 1,
                                                maxLines: 1,
                                                autofocus: false,
                                                maxLength: 5,
                                                textAlign: TextAlign.left,
                                                onEditingComplete: () {
                                                  FocusScope.of(context).unfocus();
                                                  setState(() {
                                                    comienzaEditarProbabilidad = true;
                                                  });
                                                },
                                                onChanged: (value) {
                                                  
                                                },
                                                onTapOutside: (event) {
                                                  FocusScope.of(context).unfocus();

                                                  setState(() {
                                                    comienzaEditarProbabilidad = true;
                                                  });
                                                },
                                              ),
                                            ),
                                                                          
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,                    
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecoration(
                                                hintStyle: SafeGoogleFont(
                                                  GoogleFontsApp().fontMulish,
                                                  fontSize: size.width * 0.0025 * 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppLightColors().gray800SecondaryText,
                                                  letterSpacing: 0
                                                ),
                                                labelText: 'Ingreso esperado en dólares',
                                                hintText: "0.00",
                                                suffixText: '\$',
                                              ),
                                              controller: ingresoEsperadoEditTxt,
                                              autocorrect: false,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              minLines: 1,
                                              maxLines: 1,
                                              autofocus: false,
                                              maxLength: 7,
                                              textAlign: TextAlign.left,
                                              onEditingComplete: () {
                                                FocusScope.of(context).unfocus();
                                                setState(() {
                                                  comienzaEditarIngEsp = true;
                                                });
                                              },
                                              onChanged: (value) {
                          
                                              },
                                              onTapOutside: (event) {
                                                FocusScope.of(context).unfocus();

                                                setState(() {
                                                  comienzaEditarIngEsp = true;
                                                });
                                              },
                                            ),
                                          ),
                                            
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                              //initialValue: 'Ecuador',
                                              //initialValue: '',
                                              inputFormatters: [
                                                  EmojiInputFormatter()
                                                ],
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                                                labelText: 'Correo',
                                                hintTetx: 'Ej: correo@ejemplo.com',
                                                size: size
                                              ),
                                              controller: emailEditTxt,
                                              autocorrect: false,
                                              keyboardType: TextInputType.emailAddress,
                                              minLines: 1,
                                              maxLines: 2,
                                              autofocus: false,
                                              maxLength: 50,
                                              textAlign: TextAlign.left,
                                              onEditingComplete: () {
                                                FocusScope.of(context).unfocus();
                          //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                                setState(() {
                                                  comienzaEditarCorreo = true;
                                                });
                                              },
                                              onChanged: (value) {
                          
                                              },
                                              onTapOutside: (event) {
                                                FocusScope.of(context).unfocus();
                                                setState(() {
                                                  comienzaEditarCorreo = true;
                                                });
                                              },
                                              validator: (value) {
                          
                                                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                RegExp regExp = RegExp(pattern);
                                                return regExp.hasMatch(value ?? '')
                                                  ? null
                                                  : 'Correo inválido';                          
                                                },
                                              ),
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.04,
                                            ),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                                onTapOutside: (event) {
                                                  setState(() {
                                                      
                                                  });
                                                },
                                                controller: fechaCierreEditxt,
                          //initialValue: fecEditCierre,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Cierre esperado',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            DateTime? fechaEdit = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),//DateTime(2020),
                              lastDate: DateTime(DateTime.now().year + 1),
                            );
                            
                            if (fechaEdit != null) {
                              fecEditCierre = DateFormat('yyyy-MM-dd', 'es').format(fechaEdit);
                              fechaCierreEditxt.text = '';
                              fechaCierreEditxt.text = fecEditCierre;
                              
                              comienzaEditarFechaCierre = true;
                            }

                            setState(() {
                                //dateEdPrsp = pickedDate;
                                
                              });
                          },
                                              ),
                                                                    
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                          
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              height: size.height * 0.15,
                                              child: TextFormField(
                          controller: direccionEditTxt,
                                              //initialValue: 'Yordani Oliva',
                                              //initialValue: '',
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              inputFormatters: [
                                                EmojiInputFormatter()
                                              ],
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                          labelText: 'Dirección',
                          hintTetx: '',
                          size: size
                                              ),
                                              autocorrect: false,
                                              keyboardType: TextInputType.text,
                                              minLines: 3,
                                              maxLines: 6,
                                              autofocus: false,
                                              maxLength: 150,
                                              textAlign: TextAlign.left,
                                              onEditingComplete: () {
                                                FocusScope.of(context).unfocus();
                                                setState(() {
                                                  comienzaEditarDireccion = true;
                                                });
                          //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                              },
                                              onChanged: (value) {
                          
                                              },
                                              onTapOutside: (event) {
                                                FocusScope.of(context).unfocus();
                                                setState(() {
                                                  comienzaEditarDireccion = true;
                                                });
                                              },
                                              ),
                                      ),
                                      
                                      SizedBox(
                                        height: size.height * 0.025,
                                      ),
                                                                      
                                          ],
                                        ),
                                      ),
                                    ),
                                
                                    if(tabAccionesEditPrsp == 2)
                                    Container(
                                      color: Colors.transparent,
                                      height: size.height * 0.55,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                        
                                            if(rutaFinal.isNotEmpty)
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              height: size.height * 0.22,
                                              child: WebViewWidget(controller: _wvController)
                                            ),

                                            if(rutaFinal.isEmpty)
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              height: size.height * 0.22,
                                              child: const Text('-- Sin Observaciones --', style: TextStyle(color: Colors.black, fontSize: 20),)
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                                                          
                                                                      
                                          ],
                                        ),
                                      ),
                                    ),
                                
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                      Positioned(
                        left: size.width * 0.042,
                        top: size.height * 0.82,
                        child: Container(
                          color: Colors.transparent,
                          width: size.width * 0.92,
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.38,
                                color: Colors.transparent,
                                child: GestureDetector(
                                onTap: () async {                                  
                                  context.pop();
                                },
                                child: ButtonCvsWidget(
                                  text: 'Cerrar',
                                  textStyle: AppTextStyles.h3Bold(
                                      width: size.width,
                                      color: AppLightColors().white),
                                )),
                              ),
                              Container(
                                width: size.width * 0.5,
                                color: Colors.transparent,
                                child: GestureDetector(
                                onTap: () async {

                                  String gifRespuesta = 'assets/gifs/exito.gif';
                    
                                  if(nombresEditTxt.text.isEmpty){
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ContentAlertDialog(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          onPressedCont: () {
                                            Navigator.of(context).pop();
                                          },
                                          tipoAlerta: TipoAlerta().alertAccion,
                                          numLineasTitulo: 2,
                                          numLineasMensaje: 2,
                                          titulo: 'Error',
                                          mensajeAlerta: 'Ingrese los nombres del prospecto.'
                                        );
                                      },
                                    );
                  
                                    return;
                                  }

                                  if(probabilityEditTxt.text.isEmpty){
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ContentAlertDialog(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          onPressedCont: () {
                                            Navigator.of(context).pop();
                                          },
                                          tipoAlerta: TipoAlerta().alertAccion,
                                          numLineasTitulo: 2,
                                          numLineasMensaje: 2,
                                          titulo: 'Error',
                                          mensajeAlerta: 'Ingrese la probabilidad.'
                                        );
                                      },
                                    );
                  
                                    return;
                                  } else {
                                    if(probabilityEditTxt.text.isNotEmpty){
                                      double probNeg = double.parse(probabilityEditTxt.text);

                                      if(probNeg < 0) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ContentAlertDialog(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              onPressedCont: () {
                                                Navigator.of(context).pop();
                                              },
                                              tipoAlerta: TipoAlerta().alertAccion,
                                              numLineasTitulo: 1,
                                              numLineasMensaje: 2,
                                              titulo: 'Error',
                                              mensajeAlerta: 'La probabilidad no puede ser un valor negativo.'
                                            );
                                          },
                                        );
                      
                                        return;
                                      }
                                    }
                                  }

                                  if(ingresoEsperadoEditTxt.text.isEmpty){
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ContentAlertDialog(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          onPressedCont: () {
                                            Navigator.of(context).pop();
                                          },
                                          tipoAlerta: TipoAlerta().alertAccion,
                                          numLineasTitulo: 2,
                                          numLineasMensaje: 2,
                                          titulo: 'Error',
                                          mensajeAlerta: 'Ingrese el monto esperado.'
                                        );
                                      },
                                    );
                  
                                    return;
                                  } else {
                                    if(ingresoEsperadoEditTxt.text.isNotEmpty){
                                      double ingNeg = double.parse(ingresoEsperadoEditTxt.text);

                                      if(ingNeg < 0) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ContentAlertDialog(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              onPressedCont: () {
                                                Navigator.of(context).pop();
                                              },
                                              tipoAlerta: TipoAlerta().alertAccion,
                                              numLineasTitulo: 1,
                                              numLineasMensaje: 2,
                                              titulo: 'Error',
                                              mensajeAlerta: 'El ingreso esperado no puede ser un valor negativo.'
                                            );
                                          },
                                        );
                      
                                        return;
                                      }
                                    }
                                  }

                                  if(emailEditTxt.text.isEmpty){
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ContentAlertDialog(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          onPressedCont: () {
                                            Navigator.of(context).pop();
                                          },
                                          tipoAlerta: TipoAlerta().alertAccion,
                                          numLineasTitulo: 2,
                                          numLineasMensaje: 2,
                                          titulo: 'Error',
                                          mensajeAlerta: 'Ingrese el correo.'
                                        );
                                      },
                                    );
                  
                                    return;
                                  } else {
                                    if(emailEditTxt.text.isNotEmpty){
                                      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regExp = RegExp(pattern);
                                      
                                      if(!regExp.hasMatch(emailEditTxt.text)){
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ContentAlertDialog(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              onPressedCont: () {
                                                Navigator.of(context).pop();
                                              },
                                              tipoAlerta: TipoAlerta().alertAccion,
                                              numLineasTitulo: 2,
                                              numLineasMensaje: 2,
                                              titulo: 'Error',
                                              mensajeAlerta: 'Correo inválido.'
                                            );
                                          },
                                        );
                      
                                        return;
                                      }
                                    }

                                  }

                                  if(fecEditCierre.isEmpty){
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ContentAlertDialog(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          onPressedCont: () {
                                            Navigator.of(context).pop();
                                          },
                                          tipoAlerta: TipoAlerta().alertAccion,
                                          numLineasTitulo: 2,
                                          numLineasMensaje: 2,
                                          titulo: 'Error',
                                          mensajeAlerta: 'Ingrese la fecha de cierre esperado.'
                                        );
                                      },
                                    );
                  
                                    return;
                                  }

                                  if(direccionEditTxt.text.isEmpty){
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ContentAlertDialog(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          onPressedCont: () {
                                            Navigator.of(context).pop();
                                          },
                                          tipoAlerta: TipoAlerta().alertAccion,
                                          numLineasTitulo: 2,
                                          numLineasMensaje: 2,
                                          titulo: 'Error',
                                          mensajeAlerta: 'Ingrese la dirección del prospecto.'
                                        );
                                      },
                                    );
                  
                                    return;
                                  }

                                  /*
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => SimpleDialog(
                                      alignment: Alignment.center,
                                      children: [
                                        SimpleDialogCargando(
                                          null,
                                          mensajeMostrar: 'Estamos editando',
                                          mensajeMostrarDialogCargando: 'los datos del prospecto.',
                                        ),
                                      ]
                                    ),
                                  );

                                  DatumCrmLead objProsp = DatumCrmLead(                                    
                                    
                                    dayClose: double.parse(dateEdPrsp.day.toString()),
                                    id: 0,
                                    name: nombresEditTxt.text,
                                    emailCc: emailEditTxt.text,
                                    priority: '',
                                    type: '',
                                    city: '',
                                    contactName: nombresEditTxt.text,
                                    description: observacionesEditTxt.text,
                                    emailFrom: emailEditTxt.text,
                                    street: direccionEditTxt.text,
                                    phone: telefonoEditTxt.text,
                                    partnerName: nombresEditTxt.text,
                                    mobile: '',
                                    dateOpen: DateTime.now(),
                                    dateDeadline: DateTime.now(),
                                    probability: double.parse(probabilityEditTxt.text),

                                    activityIds: [
                                      StructCombos(id: 2, name: actEditSelect)
                                    ],
                                    campaignId: CampaignId(
                                      id: 2,
                                      name: ''
                                    ),
                                    countryId: StructCombos (
                                      id: 2,
                                      name: paisEditTxt.text
                                    ),
                                    lostReasonId: CampaignId(
                                      id: 2,
                                      name: ''
                                    ),
                                    mediumId: StructCombos (
                                      id: 3,
                                      name: ''
                                    ),
                                    partnerId: StructCombos (
                                      id: 2,
                                      name: ''
                                    ),
                                    sourceId: StructCombos (
                                      id: 2,
                                      name: ''
                                    ),
                                    stageId: StructCombos (
                                      id: 2,
                                      name: ''
                                    ),
                                    stateId: StructCombos (
                                      id: 2,
                                      name: ''
                                    ),
                                    title: CampaignId(
                                      id: 2,
                                      name: ''
                                    ),
                                    tagIds: [],
                                    expectedRevenue: double.parse(ingresoEsperadoEditTxt.text),
                                    referred: recomendadoPorEditTxt.text
                                  );

                                  ProspectoRegistroResponseModel objRsp = await ProspectoTypeService().registraProspecto(objProsp);

                                  String respuestaReg = objRsp.result.mensaje;
                                  int estado = objRsp.result.estado;
                                  

                                  if(estado == 200){
                                    gifRespuesta = 'assets/gifs/exito.gif';
                                  } else {
                                    gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                  }

                                  if(objRsp.mensaje.isEmpty){
                                    
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Container(
                                            color: Colors.transparent,
                                            height: size.height * 0.17,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                
                                                Container(
                                                  color: Colors.transparent,
                                                  height: size.height * 0.09,
                                                  child: Image.asset(gifRespuesta),
                                                ),

                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.95,
                                                  height: size.height * 0.08,
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    objRsp.mensaje,
                                                    maxLines: 2,
                                                    minFontSize: 2,
                                                  ),
                                                )
                                              ],
                                            )
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  
                                    return;
                                  }
                                  */

                                  context.pop();
                                  context.pop();
                                  //context.pop();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Container(
                                          color: Colors.transparent,
                                          height: size.height * 0.17,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              
                                              Container(
                                                color: Colors.transparent,
                                                height: size.height * 0.09,
                                                //child: Image.asset(gifRespuesta),
                                                child: Image.asset(gifRespuesta),
                                              ),

                                              Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.95,
                                                height: size.height * 0.08,
                                                alignment: Alignment.center,
                                                child: const AutoSizeText(
                                                  //respuestaReg,
                                                  'Prospecto editado con éxito',
                                                  maxLines: 2,
                                                  minFontSize: 2,
                                                ),
                                              )
                                            ],
                                          )
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                
                                },
                                child: ButtonCvsWidget(
                                  text: 'Actualizar',
                                  textStyle: AppTextStyles.h3Bold(
                                      width: size.width,
                                      color: AppLightColors().white),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                            
                    ]
                  );
                
                }
              }

              return Container();
            }
          );
          
        }
      ),
        
    );
  }

}
