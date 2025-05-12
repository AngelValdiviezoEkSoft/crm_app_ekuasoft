
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

int tabAccionesRegPrsp = 0;

late TextEditingController nombresTxt;
late TextEditingController nombresOportTxt;
late TextEditingController emailTxt;
late TextEditingController direccionTxt;
late TextEditingController observacionesTxt;
late TextEditingController paisTxt;
late TextEditingController probabilityTxt;
late TextEditingController telefonoTxt;
late TextEditingController sectorTxt;
late TextEditingController ingresoEsperadoTxt;
late TextEditingController recomendadoPorTxt;
late TextEditingController fechaCierreContTxt;

String fecCierre = '';
String fecCierreFin = '';
                  

DateTime dateRgPrsp = DateTime.now();

String campSelect = '';
String mediaSelect = '';
String originSelect = '';
String actSelect = '';
String paisSelect = 'Ecuador';
String telefonoPrsp = '';
bool habilitaGuardar = false;
bool celularValido = false;
bool validandoCell = false;

class FrmRegistroProspectoScreen extends StatefulWidget {
  const FrmRegistroProspectoScreen({super.key});

  @override
  State<FrmRegistroProspectoScreen> createState() => _FrmRegistroProspectoScreenState();
}

class _FrmRegistroProspectoScreenState extends State<FrmRegistroProspectoScreen> {

  var currencyFormatter = CurrencyInputFormatter(
    thousandSeparator: ThousandSeparator.None,
  );
  
  String message = '';
  final LocalAuthentication auth = LocalAuthentication();  

  String initialCountry = 'EC';
  PhoneNumber number = PhoneNumber(isoCode: 'EC');
  final formKeyRegPrp = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    objActividadEscogida = null;
    tabAccionesRegPrsp = 0;
    fechaCierreContTxt = TextEditingController();
    nombresTxt = TextEditingController();
    nombresOportTxt = TextEditingController();
    emailTxt = TextEditingController();
    direccionTxt = TextEditingController();
    observacionesTxt = TextEditingController();
    paisTxt = TextEditingController();
    probabilityTxt = TextEditingController();    
    telefonoTxt = TextEditingController();
    ingresoEsperadoTxt = TextEditingController();
    sectorTxt = TextEditingController(text: 'Norte');
    recomendadoPorTxt = TextEditingController();

    fecCierre = DateFormat('yyyy-MM-dd', 'es').format(dateRgPrsp);
    fecCierreFin = DateFormat('yyyy-MM-dd', 'es').format(dateRgPrsp);
    fechaCierreContTxt.text = fecCierre;

    habilitaGuardar = false;
    celularValido = false;
    validandoCell = false;
    paisSelect = 'Ecuador';

    campSelect = '';
    mediaSelect = '';
    originSelect = '';
    actSelect = '';
    telefonoPrsp = '';
  }

  @override
  Widget build(BuildContext context) {

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
          title: const Text('Prospectos'),
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
                  var objMedia3 = objMedia['data'];//['result']['data']['utm.medium']['data'];
                  var objOrigen3 = objOrigen['data'];//2['result']['data']['utm.source']['data'];
                  var objAct3 = objAct['data'];//2['result']['data']['mail.activity.type']['data'];
                  var objPai3 = objPais['data'];//2['result']['data']['res.country']['data'];

                  List<Map<String, dynamic>> mappedObjCamp3 = List<Map<String, dynamic>>.from(objCamp3);

                  List<String> lstCampanias = mappedObjCamp3
                  .map((item) => item["name"]?.toString() ?? '')
                  .toList();

                  List<Map<String, dynamic>> mappedObjMed3 = List<Map<String, dynamic>>.from(objMedia3);

                  List<String> lstMedias = mappedObjMed3
                      .map((item) => item["name"]?.toString() ?? '')
                      .toList();

                  List<Map<String, dynamic>> mappedObjOrig3 = List<Map<String, dynamic>>.from(objOrigen3);

                  List<String> lstOrigenes = mappedObjOrig3
                      .map((item) => item["name"]?.toString() ?? '')
                      .toList();

                  List<Map<String, dynamic>> mappedObjAct3 = List<Map<String, dynamic>>.from(objAct3);

                  List<String> lstActividades = mappedObjAct3
                      .map((item) => item["name"]?.toString() ?? '')
                      .toList();

                  List<Map<String, dynamic>> mappedObjPais3 = List<Map<String, dynamic>>.from(objPai3);

                  List<String> lstPaises = mappedObjPais3
                      .map((item) => item["name"]?.toString() ?? '')
                      .toList();

                  if(campSelect.isEmpty && lstCampanias.isNotEmpty){                      
                    campSelect = lstCampanias.first;
                  }

                  if(mediaSelect.isEmpty && lstMedias.isNotEmpty){
                    mediaSelect = lstMedias.first;
                  }

                  if(originSelect.isEmpty && lstOrigenes.isNotEmpty){
                    originSelect = lstOrigenes.first;
                  }

                  if(actSelect.isEmpty && lstActividades.isNotEmpty){
                    actSelect = lstActividades.first;
                  }

                  /*
                  if(paisSelect.isEmpty){
                    paisSelect = lstPaises.first;
                  }
                  */

                  return Form(
                    key: formKeyRegPrp,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [                
                              Container(
                                color: Colors.transparent,
                                width: size.width * 0.95, //- 100,
                                height: size.height * 0.045, //40,
                                alignment: Alignment.centerLeft,
                                child: const AutoSizeText(
                                  'Registre nuevo prospecto',  
                                  presetFontSizes: [30,28,26,24,22,20,18,16,14,12,10],                          
                                ),
                              ),
                          
                              Container(
                                //color: const Color(0xffF6F6F6),
                                color: Colors.transparent,
                                width: size.width,
                                height: size.height * 0.86,
                                alignment: Alignment.topCenter,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                
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
                                                  color: tabAccionesRegPrsp == 0
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesRegPrsp = 0;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.info_outline,
                                                            color: tabAccionesRegPrsp == 0
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Inf. general',
                                                            style: TextStyle(
                                                              color: tabAccionesRegPrsp == 0
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
                                                  color: tabAccionesRegPrsp == 1
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesRegPrsp = 1;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.grid_on_outlined,
                                                            color: tabAccionesRegPrsp == 1
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Inf. Adicional',
                                                            style: TextStyle(
                                                              //color: Colors.purple.shade700,
                                                              color: tabAccionesRegPrsp == 1
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
                                                  color: tabAccionesRegPrsp == 2
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesRegPrsp = 2;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.add_business_rounded,
                                                            color: tabAccionesRegPrsp == 2
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Notas Int.',
                                                            style: TextStyle(
                                                              //color: Colors.purple.shade700,
                                                              color: tabAccionesRegPrsp == 2
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
                                        isEnabled: !validandoCell,
                                        onInputChanged: (PhoneNumber phoneNumber) async {
                                          telefonoPrsp = phoneNumber.phoneNumber ?? '';
                                          setState(() {});
                                        },
                                        onInputValidated: (bool isValid) async {
                                          validandoCell = true;
                                          celularValido = isValid;
                                          String tituloAlerta = '';
                                          IconData? iconoAlerta;
                                          Color? colorIcono;
                                          String msmBoton = '';

                                          if(isValid){
                                            
                                            String resInt = await ValidacionesUtils().validaInternet();

                                            if(resInt.isEmpty){

                                              showDialog(
                                                //ignore: use_build_context_synchronously
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => SimpleDialog(
                                                alignment: Alignment.center,
                                                children: [
                                                  SimpleDialogCargando(
                                                    null,
                                                    mensajeMostrar: 'Estamos consultando',
                                                    mensajeMostrarDialogCargando: 'los datos del prospecto',
                                                  ),
                                                ]
                                              ),
                                            );
                                              
                                              var resp = await ProspectoTypeService().getProspectoRegistrado(telefonoPrsp);
                      
                                              //ignore: use_build_context_synchronously
                                              FocusScope.of(context).unfocus();

                                              //ignore: use_build_context_synchronously
                                              context.pop();

                                              if(resp == null){
                                                
                                                showDialog(
                                                  barrierDismissible: false,
                                                  //ignore: use_build_context_synchronously
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
                                                      numLineasMensaje: 3,
                                                      titulo: 'Atención',
                                                      mensajeAlerta: 'Error al consultar datos.'
                                                    );
                                                  },
                                                );

                                                return;
                                              }

                                              var objResp = json.decode(resp);

                                              //print('Núm Cell: ${objResp['result']['create_date']}');

                                              if(objResp['result']['create_date'] == null){
                                                habilitaGuardar = true;
                                                tituloAlerta = 'Información';
                                                iconoAlerta = Icons.check;
                                                colorIcono = Colors.green;
                                                msmBoton = 'Continuar';
                                              } else {
                                                habilitaGuardar = false;
                                                tituloAlerta = 'Atención';
                                                colorIcono = Colors.red;
                                                iconoAlerta = Icons.cancel;
                                                msmBoton = 'Volver';
                                              }
                        
                                              showDialog(
                                                barrierDismissible: false,
                                                //ignore: use_build_context_synchronously
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
                                                    numLineasMensaje: 3,
                                                    titulo: tituloAlerta,//'Atención',
                                                    msmConIcono: true,
                                                    iconoAlerta: iconoAlerta!,
                                                    colorIconoAlerta: colorIcono,
                                                    mensajeAlerta: objResp['result']['mensaje'],
                                                    mensajeBoton: msmBoton
                                                  );
                                                },
                                              );
                                            } else {
                                              showDialog(
                                                barrierDismissible: false,
                                                //ignore: use_build_context_synchronously
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
                                                    numLineasMensaje: 3,
                                                    titulo: 'Información',
                                                    mensajeAlerta: 'Aunque no tiene internet, sus datos se registrarán en memoria.'
                                                  );
                                                },
                                              );
                                              //habilitaGuardar = false;
                                              habilitaGuardar = true;
                                            }
                      
                                          }

                                          validandoCell = false;
                                          setState(() {
                                            
                                          });
                                        },
                                        selectorConfig: const SelectorConfig(
                                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET, // Tipo de selector
                                        ),
                                        ignoreBlank: false,
                                        autoValidateMode: AutovalidateMode.onUserInteraction,
                                        initialValue: number,
                                        textFieldController: telefonoTxt,
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
                                        maxLength: 11,
                                        errorMessage: 'Teléfono no válido',
                                      ),
                                    ),
                                    
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                
                                    if(tabAccionesRegPrsp == 0)
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
                                                textCapitalization: TextCapitalization.sentences,
                                                cursorColor: AppLightColors().primary,                                        
                                                inputFormatters: [
                                                  EmojiInputFormatter()
                                                ],
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                decoration: InputDecorationCvs.formsDecoration(
                                                  labelText: '* Nombre de Prospecto',
                                                  hintTetx: 'Ej: Juan Valdez',
                                                  size: size
                                                ),
                                                enabled: habilitaGuardar,
                                                controller: nombresTxt,
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
                                              height: size.height * 0.04,
                                            ),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                                textCapitalization: TextCapitalization.sentences,
                                                cursorColor: AppLightColors().primary,                                        
                                                inputFormatters: [
                                                  EmojiInputFormatter()
                                                ],
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                decoration: InputDecorationCvs.formsDecoration(
                                                  labelText: '* Nombre Oportunidad',
                                                  hintTetx: 'Ej: Juan Valdez',
                                                  size: size
                                                ),
                                                enabled: habilitaGuardar,
                                                controller: nombresOportTxt,
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
                                              height: size.height * 0.04,
                                            ),

                                            if(habilitaGuardar)
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: DropdownButtonFormField<String>(                                          
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Seleccione el país...',
                                                ),
                                                value: paisSelect,
                                                items: lstPaises
                                                  .map(
                                                    (activityPrsp) =>
                                                      DropdownMenuItem(
                                                        value: activityPrsp,
                                                        //child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                        child: AutoSizeText(activityPrsp, presetFontSizes: const [12, 10, 8, 6,4], maxLines: 1, minFontSize: 2, maxFontSize: 12,),
                                                      )
                                                    )
                                                  .toList(),
                                                onChanged: (value) {
                                                  
                                                  setState(() {
                                                    paisSelect = value ?? '';
                                                  });
                                                                          
                                                },
                                              ),
                                            ),
                                              
                                            if(habilitaGuardar)
                                            SizedBox(
                                              height: size.height * 0.03,
                                            ),

                                            if(!habilitaGuardar)
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: DropdownButtonFormField<String>(                                          
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Seleccione el país...',
                                                ),
                                                items: const [],
                                                onChanged: (value) {},
                                              ),
                                            ),
                                              
                                            if(!habilitaGuardar)
                                            SizedBox(
                                              height: size.height * 0.03,
                                            ),

                                      if(habilitaGuardar)    
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Seleccione la campaña...',
                                          ),
                                          value: campSelect,
                                          items: lstCampanias.map((activityPrsp) =>
                                                  DropdownMenuItem(
                                                    value: activityPrsp,
                                                    //child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                    child: AutoSizeText(activityPrsp, presetFontSizes: const [12, 10, 8, 6,4], maxLines: 1, minFontSize: 2, maxFontSize: 12,),
                                                  ))
                                              .toList(),
                                          onChanged: (String? newValue) {                        
                                            setState(() {
                                              campSelect = newValue ?? '';
                                            });
                                          },
                                        ),
                                      ),

                                      if(habilitaGuardar)
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),

                                      if(!habilitaGuardar)
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(                                          
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Seleccione la campaña...',
                                          ),
                                          items: const [],
                                          onChanged: (value) {},
                                        ),
                                      ),

                                      if(!habilitaGuardar)
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                          
                                      if(habilitaGuardar)
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText:
                                                'Seleccione el origen...',
                                          ),
                                          value: originSelect,
                                          items: lstOrigenes
                                              .map((activityPrsp) =>
                                                  DropdownMenuItem(
                                                    value: activityPrsp,
                                                    //child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                    child: AutoSizeText(activityPrsp, presetFontSizes: const [10, 8, 6,4], maxLines: 1, minFontSize: 2, maxFontSize: 12,),
                                                  ))
                                              .toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              originSelect = newValue ?? '';
                                            });
                                          },
                                        ),
                                        ),

                                      if(habilitaGuardar)                                 
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),

                                      if(!habilitaGuardar)
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(                                          
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Seleccione el origen...',
                                          ),
                                          items: const [],
                                          onChanged: (value) {},
                                        ),
                                      ),

                                      if(!habilitaGuardar)
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),

                                      if(habilitaGuardar)
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                                      decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        labelText:
                                                            'Seleccione el medio...',
                                                      ),
                                                      value: mediaSelect,
                                                      items: lstMedias
                                                          .map((activityPrsp) =>
                                                              DropdownMenuItem(
                                                                value: activityPrsp,
                                                                //child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                                child: AutoSizeText(activityPrsp, presetFontSizes: const [12, 10, 8, 6,4], maxLines: 1, minFontSize: 2, maxFontSize: 12,),
                                                              ))
                                                          .toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                              mediaSelect = newValue ?? '';
                                            });
                                                      },
                                                    ),
                                      ),

                                      if(habilitaGuardar)
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),

                                      if(!habilitaGuardar)
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(                                          
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Seleccione el medio...',
                                          ),
                                          items: const [],
                                          onChanged: (value) {},
                                        ),
                                      ),

                                      if(!habilitaGuardar)
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),

                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: TextFormField(
                                          enabled: habilitaGuardar,
                                          textCapitalization: TextCapitalization.sentences,
                                          cursorColor: AppLightColors().primary,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,                                        
                                          style: AppTextStyles.bodyRegular(width: size.width),
                                          decoration: InputDecorationCvs.formsDecoration(
                                            labelText: 'Recomendado por',
                                            hintTetx: 'Ej: Majo Piguave',
                                            size: size
                                          ),
                                          controller: recomendadoPorTxt,
                                          autocorrect: false,
                                          keyboardType: TextInputType.text,
                                          minLines: 1,
                                          maxLines: 2,
                                          autofocus: false,
                                          maxLength: 50,
                                          textAlign: TextAlign.left,
                                          onEditingComplete: () {
                                            FocusScope.of(context).unfocus();
                                          },
                                          onChanged: (value) {
                                            
                                          },
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
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
                                
                                    if(tabAccionesRegPrsp == 1)
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
                                                enabled: habilitaGuardar,                        
                                                cursorColor: AppLightColors().primary,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,                                              
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                decoration: InputDecoration(
                                                  labelText: 'Probabilidad',
                                                  hintStyle: SafeGoogleFont(
                                                      GoogleFontsApp().fontMulish,
                                                      fontSize: size.width * 0.0025 * 18,
                                                      fontWeight: FontWeight.w700,
                                                      color:
                                                          AppLightColors().gray800SecondaryText,
                                                      letterSpacing: 0),
                                                      
                                                  hintText: "100%",
                                                  suffixText: '%',
                                                ),
                                                inputFormatters: [currencyFormatter],
                                                controller: probabilityTxt,
                                                autocorrect: false,
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                minLines: 1,
                                                maxLines: 1,
                                                autofocus: false,
                                                maxLength: 6,
                                                textAlign: TextAlign.left,
                                                onEditingComplete: () {
                                                  FocusScope.of(context).unfocus();

                                                  setState(() {
                                                      
                                                  });
                                                },
                                                onChanged: (value) {
                                                  
                                                },
                                                onTapOutside: (event) {
                                                  FocusScope.of(context).unfocus();

                                                  setState(() {
                                                      
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
                                                enabled: habilitaGuardar,
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
                                                controller: ingresoEsperadoTxt,
                                                autocorrect: false,
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                minLines: 1,
                                                maxLines: 1,
                                                autofocus: false,
                                                //maxLength: 7,
                                                textAlign: TextAlign.left,
                                                inputFormatters: [currencyFormatter],
                                                onEditingComplete: () {
                                                  FocusScope.of(context).unfocus();

                                                  setState(() {
                                                      
                                                  });
                                                },
                                                onChanged: (value) {
                            
                                                },
                                                onTapOutside: (event) {
                                                  FocusScope.of(context).unfocus();

                                                  setState(() {
                                                      
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
                                              inputFormatters: [
                                                EmojiInputFormatter()
                                              ],
                                              enabled: habilitaGuardar,
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                                                labelText: 'Correo',
                                                hintTetx: 'Ej: correo@ejemplo.com',
                                                size: size
                                              ),
                                              controller: emailTxt,
                                              autocorrect: false,
                                              keyboardType: TextInputType.emailAddress,
                                              minLines: 1,
                                              maxLines: 2,
                                              autofocus: false,
                                              maxLength: 50,
                                              textAlign: TextAlign.left,
                                              onEditingComplete: () {
                                                FocusScope.of(context).unfocus();

                                                setState(() {
                                                      
                                                  });
                                              },
                                              onChanged: (value) {
                          
                                              },
                                              onTapOutside: (event) {
                                                FocusScope.of(context).unfocus();
                                                setState(() {
                                                      
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
                                              height: size.height * 0.03,
                                            ),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                                onTapOutside: (event) {
                                                  setState(() {
                                                      
                                                  });
                                                },
                                                controller: fechaCierreContTxt,
                                                enabled: habilitaGuardar,
                                                //initialValue: fecCierre,//DateFormat('dd-MM-yyyy', 'es').format(dateRgPrsp),
                                                readOnly: true,
                                                decoration: const InputDecoration(
                                                  labelText: 'Cierre esperado',
                                                  border: OutlineInputBorder(),
                                                  suffixIcon: Icon(Icons.calendar_today),
                                                ),
                                                onTap: () async {
                                                  DateTime? fecCambio = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),//DateTime(2020),
                                                    lastDate: DateTime(DateTime.now().year + 1),
                                                  );

                                                  if (fecCambio != null) {
                                                    
                                                    //tabAccionesRegPrsp = 2;
                                                    fecCierre = DateFormat('yyyy-MM-dd', 'es').format(fecCambio);
                                                    fecCierreFin = DateFormat('yyyy-MM-dd', 'es').format(fecCambio);
                                                    //tabAccionesRegPrsp = 1;
                                                    fechaCierreContTxt.text = fecCierreFin;
    
                                                  }

                                                  setState(() {
                                                      
                                                  });
                                                },
                                              ),
                                                                    
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                          
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              height: size.height * 0.15,
                                              child: TextFormField(
                                                enabled: habilitaGuardar,
                                              controller: direccionTxt,
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
                                                      
                                                  });
                                              },
                                              onChanged: (value) {
                          
                                              },
                                              onTapOutside: (event) {
                                                FocusScope.of(context).unfocus();
                                                setState(() {
                                                      
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
                                
                                    if(tabAccionesRegPrsp == 2)
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
                                                enabled: habilitaGuardar,
                                                inputFormatters: [
                                                  EmojiInputFormatter()
                                                ],
                                                cursorColor: AppLightColors().primary,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                decoration: InputDecorationCvs.formsDecoration(
                                                  labelText: 'Observaciones',
                                                  hintTetx: 'Ej: Interesado en casa pero no tiene trabajo estable',
                                                  size: size
                                                ),
                                                controller: observacionesTxt,
                                                autocorrect: false,
                                                keyboardType: TextInputType.multiline,
                                                minLines: 1,
                                                maxLines: 4,
                                                autofocus: false,
                                                maxLength: 150,
                                                textAlign: TextAlign.left,
                                                onEditingComplete: () {
                                                  FocusScope.of(context).unfocus();
                                                },
                                                onChanged: (value) {
                                                  
                                                },
                                                onTapOutside: (event) {
                                                  FocusScope.of(context).unfocus();
                                                },
                                              ),
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
                    
                        if(habilitaGuardar)
                        Positioned(
                          left: size.width * 0.042,
                          top: size.height * 0.82,
                          child: Container(
                            color: Colors.transparent,
                            width: size.width * 0.92,
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

                                    FocusScope.of(context).requestFocus(FocusNode());

                                    if(!celularValido){
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
                                            mensajeAlerta: 'Número celular inválido, por favor corregir.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    }
                    
                                    if(nombresTxt.text.isEmpty || nombresOportTxt.text.isEmpty) {

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

                                     String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regExp = RegExp(pattern);
                                      
                                      if(emailTxt.text.isNotEmpty && !regExp.hasMatch(emailTxt.text)){
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

                                    /*

                                    if(probabilityTxt.text.isEmpty){
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
                                      if(probabilityTxt.text.isNotEmpty){                                       
                                        try {
                                          double probNeg = double.parse(probabilityTxt.text);

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

                                        } catch(ex) {

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
                                                tipoAlerta: TipoAlerta().alertError,
                                                numLineasTitulo: 2,
                                                numLineasMensaje: 2,
                                                titulo: 'Error',
                                                mensajeAlerta: 'La probabilidad no es un valor válido.'
                                              );
                                            },
                                          );
                        
                                          return;
                                        }

                                      }
                                    }

                                    if(ingresoEsperadoTxt.text.isEmpty){
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
                                      if(ingresoEsperadoTxt.text.isNotEmpty){
                                        
                                        try {
                                          double ingNeg = double.parse(ingresoEsperadoTxt.text);

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
                                        } catch(ex) {

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
                                                tipoAlerta: TipoAlerta().alertError,
                                                numLineasTitulo: 2,
                                                numLineasMensaje: 2,
                                                titulo: 'Error',
                                                mensajeAlerta: 'El ingreso esperado no es un valor válido.'
                                              );
                                            },
                                          );
                        
                                          return;
                                        }
                                      }
                                    }

                                    if(emailTxt.text.isEmpty){
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
                                      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regExp = RegExp(pattern);
                                      
                                      if(!regExp.hasMatch(emailTxt.text)){
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

                                    if(fecCierreFin.isEmpty){
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
                                            mensajeAlerta: 'Ingrese la fecha de cierre.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    }

                                    if(direccionTxt.text.isEmpty){
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
                                            mensajeAlerta: 'Ingrese la dirección.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    }
                                    */
                    
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => SimpleDialog(
                                        alignment: Alignment.center,
                                        children: [
                                          SimpleDialogCargando(
                                            null,
                                            mensajeMostrar: 'Estamos registrando',
                                            mensajeMostrarDialogCargando: 'al nuevo prospecto.',
                                          ),
                                        ]
                                      ),
                                    );
                    
                                    int idPais = 0;
                                    int idCamp = 0;
                                    int idMedia = 0;
                                    int idOrigen = 0;
                                    int idActivi = 0;
                    
                                    for (var elemento in mappedObjPais3) {
                                      if (elemento['name'] == paisSelect) {
                                        idPais = elemento['id'];
                                      }
                                    }
                    
                                    for (var elemento in mappedObjCamp3) {
                                      if (elemento['name'] == campSelect) {
                                        idCamp = elemento['id'];
                                      }
                                    }
                    
                                    for (var elemento in mappedObjOrig3) {
                                      if (elemento['name'] == originSelect) {
                                        idOrigen = elemento['id'];
                                      }
                                    }
                    
                                    for (var elemento in mappedObjMed3) {
                                      if (elemento['name'] == mediaSelect) {
                                        idMedia = elemento['id'];
                                      }
                                    }
                                    
                                    for (var elemento in mappedObjAct3) {
                                      if (elemento['name'] == mediaSelect) {
                                        idActivi = elemento['id'];
                                      }
                                    }

                                    DatumCrmLead objProsp = DatumCrmLead(
                                      expectedRevenue: ingresoEsperadoTxt.text.isNotEmpty ? double.parse(ingresoEsperadoTxt.text) : 0,
                                      dayClose: double.parse(dateRgPrsp.day.toString()),
                                      id: 0,
                                      name: nombresOportTxt.text,
                                      emailCc: emailTxt.text,
                                      priority: '',
                                      type: '',
                                      city: '',
                                      contactName: nombresTxt.text,
                                      description: observacionesTxt.text,
                                      emailFrom: emailTxt.text,
                                      street: direccionTxt.text,
                                      phone: telefonoPrsp,
                                      partnerName: nombresTxt.text,
                                      mobile: telefonoPrsp,
                                      dateOpen: DateTime.now(),
                                      dateDeadline: DateTime.parse(fecCierreFin),//DateTime.now(),
                                      probability: probabilityTxt.text.isNotEmpty ? double.parse(probabilityTxt.text) : 0,
                                      activityIds: [
                                        StructCombos(id: idActivi, name: actSelect)
                                      ],
                                      campaignId: CampaignId(
                                        id: idCamp,
                                        name: campSelect
                                      ),
                                      countryId: StructCombos (
                                        id: idPais,
                                        name: paisTxt.text
                                      ),
                                      lostReasonId: CampaignId(
                                        id: 2,
                                        name: ''
                                      ),
                                      mediumId: StructCombos (
                                        id: idMedia,
                                        name: ''
                                      ),
                                      partnerId: StructCombos (
                                        id: 2,
                                        name: ''
                                      ),
                                      sourceId: StructCombos (
                                        id: idOrigen,
                                        name: originSelect
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
                                      referred: recomendadoPorTxt.text,
                                      dateClose: DateTime.now(),//DateTime.parse(fecCierreFin)
                                    );
                    
                                    ProspectoRegistroResponseModel objRsp = await ProspectoTypeService().registraProspecto(objProsp);
                                    
                                    String respuestaReg = objRsp.result.mensaje;
                                    int estado = objRsp.result.estado;
                                    String gifRespuesta = 'assets/gifs/exito.gif';
                    
                                    //ignore: use_build_context_synchronously
                                    context.pop();
                    
                                    if(objRsp.mensaje.isNotEmpty){
                                
                                      showDialog(
                                        //ignore: use_build_context_synchronously
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
                    
                                    if(estado == 200){
                                      gifRespuesta = 'assets/gifs/exito.gif';
                                    } else {
                                      gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                    }
                    
                                    //ignore:use_build_context_synchronously
                                    context.pop();
                                    //ignore:use_build_context_synchronously
                                    context.pop();
                    
                                    showDialog(
                                      //ignore:use_build_context_synchronously
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
                                                    respuestaReg,
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
                                    //text: 'Crear',
                                    text: 'Crear Prospecto',
                                    textStyle: AppTextStyles.h3Bold(
                                      width: size.width,
                                      color: AppLightColors().white
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                              
                        if(!habilitaGuardar)
                        Positioned(
                          //left: size.width * 0.06,
                          right: size.width * 0.29,
                          top: size.height * 0.82,
                          child: Container(
                            width: size.width * 0.38,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: GestureDetector(
                            onTap: () async {
                              context.pop();
                            },
                            child: ButtonCvsWidget(
                              text: 'Cerrar',
                              textStyle: AppTextStyles.h3Bold(
                                  width: size.width,
                                  color: AppLightColors().white),
                            )
                          ),
                        ),
                    
                        ),
                        
                      ]
                    ),
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
