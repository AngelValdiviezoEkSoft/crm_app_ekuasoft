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
import 'package:webview_flutter/webview_flutter.dart';

int idProsp = 0;
int tabAccionesEditPrsp = 0;
String codIsoPhone = '';
String dialCodePhone = '';

class FrmEditProspectoScreen extends StatefulWidget {
  const FrmEditProspectoScreen({super.key});

  @override
  State<FrmEditProspectoScreen> createState() => _FrmEditProspectoScreenState();
}

class _FrmEditProspectoScreenState extends State<FrmEditProspectoScreen> {

  String paisSelect = 'Ecuador';
  String campSelect = '';
  String mediaSelect = '';
  String originSelect = '';

  late final WebViewController _wvController;
  final LocalAuthentication auth = LocalAuthentication();  

  PhoneNumber number = PhoneNumber(isoCode: 'EC');

  String campEditSelect = '';
  String mediaEditSelect = '';
  String originEditSelect = '';
  String actEditSelect = '';
  String paisEditSelect = '';
  
  bool prspAsignado = false;
  
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

  void _loadInitialData() {    
    nombresEditTxt = TextEditingController(text: objDatumCrmLeadEdit?.contactName ?? '');
    nombresOportEditTxt = TextEditingController(text: objDatumCrmLeadEdit?.name ?? '');
    emailEditTxt = TextEditingController(text: objDatumCrmLeadEdit?.emailFrom ?? '');
    direccionEditTxt = TextEditingController(text: objDatumCrmLeadEdit?.street ?? '');
    observacionesEditTxt = TextEditingController(text: objDatumCrmLeadEdit?.description ?? '');
    paisEditTxt = TextEditingController();
    probabilityEditTxt = TextEditingController(text: objDatumCrmLeadEdit?.probability?.toString() ?? "0");
    ingresoEsperadoEditTxt = TextEditingController(text: objDatumCrmLeadEdit?.expectedRevenue.toString() ?? '');
    recomendadoPorEditTxt = TextEditingController(text: objDatumCrmLeadEdit?.referred ?? '');
    
    String initialDateText = objDatumCrmLeadEdit?.dateDeadline != null 
        ? DateFormat('yyyy-MM-dd', 'es').format(objDatumCrmLeadEdit!.dateDeadline!) 
        : '-- No tiene fecha de cierre --';
    fechaCierreEditxt = TextEditingController(text: initialDateText);
    
    //String cell = separatePhoneNumber(objDatumCrmLeadEdit?.phone ?? '');
    //telefonoEditTxt = TextEditingController(text: cell);
    sectorEditTxt = TextEditingController(text: 'Norte');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final nuevoTexto = objDatumCrmLeadEdit?.phone ?? '';

      String numero = nuevoTexto.replaceAll(RegExp(r'\s+'), '');
        
      if (numero.startsWith('+')) {
        try {
          // Detectar país automáticamente
          PhoneNumber parsed = await PhoneNumber.getRegionInfoFromPhoneNumber(numero);

          codIsoPhone = parsed.isoCode ?? '';
          dialCodePhone = parsed.dialCode ?? '';

          // Quitar código del país si está presente (sin cortar el último número)
          String localNumber = numero;
          if (dialCodePhone.isNotEmpty) {
            localNumber = numero.replaceFirst(RegExp('^\\+?${RegExp.escape(dialCodePhone)}'), '');
          }

          // Aseguramos que no se elimine el último dígito
          if (localNumber.isNotEmpty && localNumber != telefonoEditTxt.text) {              
            
            telefonoEditTxt.text = localNumber;
            telefonoEditTxt.selection = TextSelection.fromPosition(
              TextPosition(offset: localNumber.length),
            );
            
          }

          // Actualizar bandera / país detectado
          //setState(() {
            number = parsed;
          //});

        } catch (e) {

          telefonoEditTxt.text = numero;
          telefonoEditTxt.selection = TextSelection.fromPosition(
            TextPosition(offset: numero.length),
          );
            
        }
      } else {
        
        telefonoEditTxt.text = numero;
        telefonoEditTxt.selection = TextSelection.fromPosition(
          TextPosition(offset: numero.length),
        );            
      
      }

      number = PhoneNumber(isoCode: codIsoPhone);
      //telefonoEditTxt = TextEditingController(text: cell);
    });

    rutaFinal = objDatumCrmLeadEdit?.description ?? '';

    if(rutaFinal.isNotEmpty){
      _wvController = WebViewController();
      _wvController.loadHtmlString(rutaFinal);
    }

    prspAsignado = objDatumCrmLeadEdit?.userId != null && objDatumCrmLeadEdit!.userId!.name.isNotEmpty;
    tabAccionesEditPrsp = 0;

    campEditSelect = objDatumCrmLeadEdit?.campaignId?.name.isNotEmpty == true 
        ? objDatumCrmLeadEdit!.campaignId!.name 
        : '';
        
    originEditSelect = objDatumCrmLeadEdit?.sourceId.name.isNotEmpty == true 
        ? objDatumCrmLeadEdit!.sourceId.name 
        : '';

    mediaEditSelect = objDatumCrmLeadEdit?.mediumId.name.isNotEmpty == true 
        ? objDatumCrmLeadEdit!.mediumId.name 
        : '';

    paisEditSelect = objDatumCrmLeadEdit?.countryId.name.isNotEmpty == true 
        ? objDatumCrmLeadEdit!.countryId.name 
        : '';
        
    actEditSelect = objDatumCrmLeadEdit?.activityIds.isNotEmpty == true 
        ? objDatumCrmLeadEdit!.activityIds.first.name 
        : '';

  }
  
  @override
  void initState() {
    super.initState();
    objActividadEscogida = null;
    objCalendarioActividadescogidaByFiltroCal = null;

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

      String cell = separatePhoneNumber(objDatumCrmLeadEdit!.phone ?? '');

      telefonoEditTxt.text = cell;

      rutaFinal = objDatumCrmLeadEdit!.description ?? '';

      if(rutaFinal.isNotEmpty){
        _wvController = WebViewController();

        _wvController.loadHtmlString(rutaFinal);
      }

      if(objDatumCrmLeadEdit!.userId != null && objDatumCrmLeadEdit!.userId!.name.isNotEmpty){
        prspAsignado = true;
      }
      _loadInitialData();
    }

  }

  @override
  void didUpdateWidget(covariant FrmEditProspectoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Asumiendo que el objeto global objDatumCrmLead cambia para forzar la actualización
    if (objDatumCrmLead != objDatumCrmLeadEdit) {
      objDatumCrmLeadEdit = objDatumCrmLead;
      _loadInitialData(); // Recargar data si el prospecto cambia
    }
  }

  @override
  void dispose() {
    nombresEditTxt.dispose();
    nombresOportEditTxt.dispose();
    emailEditTxt.dispose();
    direccionEditTxt.dispose();
    observacionesEditTxt.dispose();
    paisEditTxt.dispose();
    probabilityEditTxt.dispose();
    telefonoEditTxt.dispose();
    sectorEditTxt.dispose();
    ingresoEsperadoEditTxt.dispose();
    recomendadoPorEditTxt.dispose();
    fechaCierreEditxt.dispose();
    super.dispose();
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  String separatePhoneNumber(String phone) {
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
          backgroundColor: Colors.blue.shade800,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Edición de Prospecto', style: TextStyle(color: Colors.white)),
          actions: [
            Tooltip(
              message: 'Regresar al prospecto anterior',
              child: GestureDetector(
                onTap: () async {
                  if(objDatumCrmLead == null) return;
                  
                  var lstProspStr = await ProspectoTypeService().getProspectos();
                  var objLogDecode = json.decode(lstProspStr);
              
                  ProspectoResponseModel apiResponse = ProspectoResponseModel.fromJson(objLogDecode);
              
                  List<DatumCrmLead> prospectosFiltradosNext = apiResponse.result.data.crmLead.data;                      
              
                  for(int i = 0; i < prospectosFiltradosNext.length; i++){
                    if(prospectosFiltradosNext[i].id == objDatumCrmLead!.id) {
                      try{
                        objDatumCrmLead = prospectosFiltradosNext[i - 1];
                      }
                      catch(_){
                        objDatumCrmLead = prospectosFiltradosNext[prospectosFiltradosNext.length - 1];
                      }
              
                      //ignore:use_build_context_synchronously
                      context.pop();
              
                      //ignore:use_build_context_synchronously
                      context.push(objRutasGen.rutaEditProsp);
              
                      return;
                    }
                  }
              
                },
                child: const Icon(
                  Icons.keyboard_double_arrow_left_sharp,
                  color: Colors.white,
                  size: 23,
                )
              ),
            ),

            SizedBox(
              width: size.width * 0.025,
            ),

            Tooltip(
              message: 'Ir al siguiente prospecto',
              child: GestureDetector(
                onTap: () async {
                  if(objDatumCrmLead == null) return;
                  
                  var lstProspStr = await ProspectoTypeService().getProspectos();
                  var objLogDecode = json.decode(lstProspStr);
              
                  ProspectoResponseModel apiResponse = ProspectoResponseModel.fromJson(objLogDecode);
              
                  List<DatumCrmLead> prospectosFiltradosNext = apiResponse.result.data.crmLead.data;                      
              
                  for(int i = 0; i < prospectosFiltradosNext.length; i++){
                    if(prospectosFiltradosNext[i].id == objDatumCrmLead!.id) {
                      try{
                        objDatumCrmLead = prospectosFiltradosNext[i + 1];
                      }
                      catch(_){
                        objDatumCrmLead = prospectosFiltradosNext[0];
                      }
              
                      //ignore:use_build_context_synchronously
                      context.pop();
              
                      //ignore:use_build_context_synchronously
                      context.push(objRutasGen.rutaEditProsp);
              
                      return;
                    }
                  }
              
                },
                child: const Icon(
                  Icons.keyboard_double_arrow_right_sharp,
                  color: Colors.white,
                  size: 25,
                )
              ),
            ),

            SizedBox(
              width: size.width * 0.04,
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
                  String fecEditCierre = DateFormat('yyyy-MM-dd', 'es').format(DateTime.now());
                  
                  // ... (Lógica para parsear rspCombos y obtener lstPaises, lstCampanias, etc.)
                  List<String> lstPaises = [];
                  List<String> lstActividades = [];
                  List<String> lstMedias = [];
                  List<String> lstCampanias = [];
                  List<String> lstOrigenes = [];

                  // ... (Código de parseo)                  
                  ProspectoCombosModel objTmp = ProspectoCombosModel(
                      campanias: rspCombos.split('---')[0],
                      origen: rspCombos.split('---')[1],
                      medias: rspCombos.split('---')[2],
                      actividades: rspCombos.split('---')[3],
                      paises: rspCombos.split('---')[4],
                      lstActividades: ''
                    );

                    var objCamp = json.decode(objTmp.campanias);
                    var objMedia = json.decode(objTmp.medias);
                    var objOrigen = json.decode(objTmp.origen);
                    var objAct = json.decode(objTmp.actividades);
                    var objPais = json.decode(objTmp.paises);

                    var objCamp3 = objCamp['data'];
                    var objMedia3 = objMedia['data'];
                    var objOrigen3 = objOrigen['data'];
                    var objAct3 = objAct['data'];
                    var objPai3 = objPais['data'];

                    List<Map<String, dynamic>> mappedObjCamp3 = List<Map<String, dynamic>>.from(objCamp3);
                    lstCampanias = mappedObjCamp3.map((item) => item["name"]?.toString() ?? '').toList();

                    List<Map<String, dynamic>> mappedObjMed3 = List<Map<String, dynamic>>.from(objMedia3);
                    lstMedias = mappedObjMed3.map((item) => item["name"]?.toString() ?? '').toList();

                    List<Map<String, dynamic>> mappedObjOrig3 = List<Map<String, dynamic>>.from(objOrigen3);
                    lstOrigenes = mappedObjOrig3.map((item) => item["name"]?.toString() ?? '').toList();

                    List<Map<String, dynamic>> mappedObjAct3 = List<Map<String, dynamic>>.from(objAct3);
                    lstActividades = mappedObjAct3.map((item) => item["name"]?.toString() ?? '').toList();

                    List<Map<String, dynamic>> mappedObjPais3 = List<Map<String, dynamic>>.from(objPai3);
                    lstPaises = mappedObjPais3.map((item) => item["name"]?.toString() ?? '').toList();

                  // 2. Lógica para establecer el valor *inicial* de los selectores si está vacío
                  // Esto solo ocurre si el valor del Lead está vacío O si el Lead no tiene un valor válido
                  // La inicialización con el valor del lead ya se hizo en initState, aquí solo se asegura un valor por defecto.
                  
                  if(actEditSelect.isEmpty && lstActividades.isNotEmpty){
                    actEditSelect = lstActividades.first;
                  }
                  
                  if(paisEditSelect.isEmpty && lstPaises.isNotEmpty){
                    paisEditSelect = lstPaises.first;
                  }
                  
                  if(campEditSelect.isEmpty && lstCampanias.isNotEmpty){
                    campEditSelect = lstCampanias.first;
                  }
                  
                  if(originEditSelect.isEmpty && lstOrigenes.isNotEmpty){
                    originEditSelect = lstOrigenes.first;
                  }
                  
                  if(mediaEditSelect.isEmpty && lstMedias.isNotEmpty){
                    mediaEditSelect = lstMedias.first;
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
                                                              fontSize: 9.85
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
                                                              fontSize: 9.85
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
                                                            Icons.bookmark,
                                                            color: tabAccionesEditPrsp == 2
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Observaciones',
                                                            style: TextStyle(
                                                              //color: Colors.purple.shade700,
                                                              color: tabAccionesEditPrsp == 2
                                                                  ? Colors.blue.shade800
                                                                  : Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 9.85
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
                                                  color: tabAccionesEditPrsp == 3
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesEditPrsp = 3;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.book,
                                                            color: tabAccionesEditPrsp == 3
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Notas Int.',
                                                            style: TextStyle(
                                                              //color: Colors.purple.shade700,
                                                              color: tabAccionesEditPrsp == 3
                                                                  ? Colors.blue.shade800
                                                                  : Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 9.85
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
                                        hintText: "Ingrese número",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onSaved: (PhoneNumber phoneNumber) {
                                        //print('Número guardado: ${phoneNumber.phoneNumber}');
                                      },
                                      errorMessage: 'Teléfono no válido',
                                    ),
                                    ),
                                    
                                    if(tabAccionesEditPrsp != 3)
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
                                                  labelText: '* Nombre de Prospecto',
                                                  hintTetx: '* Empresa o Contacto *',
                                                  size: size,
                                                  suffix: IconButton(
                                                    onPressed: () {
                                                      nombresEditTxt.text = '';
                                                    },
                                                    icon: Icon(
                                                        size: 18,
                                                        Icons.close,
                                                        color: AppLightColors().gray900PrimaryText
                                                    ),
                                                  ),
                                                ),
                                                //enabled: false,
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
                                                  labelText: '* Nombre Oportunidad',
                                                  hintTetx: 'Ej: Nomb. producto + Nomb. prospecto',
                                                  size: size,
                                                  suffix: IconButton(
                                                    onPressed: () {
                                                      nombresOportEditTxt.text = '';
                                                    },
                                                    icon: Icon(
                                                        size: 18,
                                                        Icons.close,
                                                        color: AppLightColors().gray900PrimaryText
                                                    ),
                                                  ),
                                                ),
                                                //enabled: false,
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
                                              
                                              setState(() {
                                                paisEditSelect = value ?? '';
                                              });
                                                                      
                                            },
                                          ),
                                        ),
                                        
                                      SizedBox(
                                        height: size.height * 0.025,
                                      ),
                                                                        
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
                                            setState(() {
                                              campEditSelect = newValue ?? '';
                                            });
                                          },
                                        ),
                                      ),
                                                                      
                                      SizedBox(
                                        height: size.height * 0.025,
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
                                            setState(() {
                                              originEditSelect = newValue ?? '';
                                            });
                                          },
                                        ),
                                        ),
                                                                          
                                      SizedBox(
                                        height: size.height * 0.025,
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
                                                        setState(() {
                                              mediaEditSelect = newValue ?? '';
                                            });
                                                      },
                                                    ),
                                      ),
                                                                          
                                      SizedBox(
                                        height: size.height * 0.025,
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
                                            hintTetx: '* Nombre de la persona quien recomendó *',
                                            size: size,
                                            suffix: IconButton(
                                              onPressed: () {
                                                recomendadoPorEditTxt.text = '';
                                              },
                                              icon: Icon(
                                                  size: 18,
                                                  Icons.close,
                                                  color: AppLightColors().gray900PrimaryText
                                              ),
                                            ),
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
                                                  //suffixText: '%',
                                                  labelText: '% Probabilidad',
                                                  suffix: IconButton(
                                                    onPressed: () {
                                                      
                                                      probabilityEditTxt.text = '';
                                                    },
                                                    icon: Icon(
                                                        size: 18,
                                                        Icons.close,
                                                        color: AppLightColors().gray900PrimaryText
                                                    ),
                                                  ),
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
                                              height: size.height * 0.003,
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
                                                hintText: "\$0.00",
                                                //suffixText: '\$',
                                                suffix: IconButton(
                                                  onPressed: () {
                                                    ingresoEsperadoEditTxt.text = '';
                                                  },
                                                  icon: Icon(
                                                    size: 18,
                                                    Icons.close,
                                                    color: AppLightColors().gray900PrimaryText
                                                  ),
                                                ),
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
                                              height: size.height * 0.0003,
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
                                                size: size,
                                                suffix: IconButton(
                                                  onPressed: () {
                                                    emailEditTxt.text = '';
                                                  },
                                                  icon: Icon(
                                                      size: 18,
                                                      Icons.close,
                                                      color: AppLightColors().gray900PrimaryText
                                                  ),
                                                ),
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
                                              height: size.height * 0.04,
                                            ),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              height: size.height * 0.07,
                                              child: TextFormField(
                                                onTapOutside: (event) {
                                                  setState(() {
                                                      
                                                  });
                                                },
                                                controller: fechaCierreEditxt,
                          //initialValue: fecEditCierre,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Cierre esperado',
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.calendar_today),
                            suffix: IconButton(
                              onPressed: () {
                                fechaCierreEditxt.text = '';
                              },
                              icon: Icon(
                                  size: 18,
                                  Icons.close,
                                  color: AppLightColors().gray900PrimaryText
                              ),
                            ),
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
                            }

                            setState(() {
                                //dateEdPrsp = pickedDate;
                                
                              });
                          },
                                              ),
                                                                    
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.002,
                                            ),
                          
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              height: size.height * 0.15,
                                              alignment: Alignment.topCenter,
                                              child: TextFormField(
                                              controller: direccionEditTxt,
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              inputFormatters: [
                                                EmojiInputFormatter()
                                              ],
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                                                labelText: 'Dirección',
                                                hintTetx: '',
                                                size: size,
                                                suffix: IconButton(
                                                  onPressed: () {
                                                    direccionEditTxt.text = '';
                                                  },
                                                  icon: Icon(
                                                      size: 18,
                                                      Icons.close,
                                                      color: AppLightColors().gray900PrimaryText
                                                  ),
                                                ),
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
                          //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
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
                                              height: size.height * 0.05,
                                              child: const Text('-- Sin Observaciones --', style: TextStyle(color: Colors.black, fontSize: 20),)
                                            ),

                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),                        
                                          ],
                                        ),
                                      ),
                                    ),
                                
                                    if(tabAccionesEditPrsp == 3)
                                    const FrmNotasInternasView(),
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

                                  if(nombresEditTxt.text.isEmpty || nombresOportEditTxt.text.isEmpty){
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

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => SimpleDialog(
                                        alignment: Alignment.center,
                                        children: [
                                          SimpleDialogCargando(
                                            null,
                                            mensajeMostrar: 'Estamos editar',
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
                                      if (elemento['name'] == campEditSelect) {
                                        idCamp = elemento['id'];
                                      }
                                    }
                    
                                    for (var elemento in mappedObjOrig3) {
                                      if (elemento['name'] == originEditSelect) {
                                        idOrigen = elemento['id'];
                                      }
                                    }
                    
                                    for (var elemento in mappedObjMed3) {
                                      if (elemento['name'] == mediaEditSelect) {
                                        idMedia = elemento['id'];
                                      }
                                    }
                                    
                                    for (var elemento in mappedObjAct3) {
                                      if (elemento['name'] == mediaSelect) {
                                        idActivi = elemento['id'];
                                      }
                                    }

                                  DatumCrmLead objProsp = DatumCrmLead(                                    
                                    //dateClose: DateTime.now(),
                                    //userId: 0,
                                    dateCreate: DateTime.now(),
                                    id: objDatumCrmLeadEdit?.id ?? 0,
                                    dayClose: double.parse(dateEdPrsp.day.toString()),                                    
                                    name: nombresOportEditTxt.text,
                                    emailCc: emailEditTxt.text,
                                    priority: '',
                                    type: '',
                                    city: '',
                                    contactName: nombresEditTxt.text,
                                    description: observacionesEditTxt.text,
                                    emailFrom: emailEditTxt.text,
                                    street: direccionEditTxt.text,
                                    phone: '+$dialCodePhone${telefonoEditTxt.text}',
                                    partnerName: nombresEditTxt.text,
                                    mobile: '',
                                    dateOpen: DateTime.now(),
                                    dateDeadline: DateTime.now(),
                                    probability: double.parse(probabilityEditTxt.text),

                                    activityIds: [
                                        StructCombos(id: idActivi, name: actEditSelect)
                                      ],
                                      campaignId: CampaignId(
                                        id: idCamp,
                                        name: campEditSelect
                                      ),
                                      countryId: StructCombos (
                                        id: idPais,
                                        name: paisEditTxt.text
                                      ),
                                      lostReasonId: CampaignId(
                                        id: 2,
                                        name: ''
                                      ),
                                      mediumId: StructCombos (
                                        id: idMedia,
                                        name: ''
                                      ),
                                      partnerId: PartnerId(
                                        id: 2,
                                        name: '',
                                        tradeName: '',
                                        channelId: StructCombos(id: 0, name: ''),
                                        cityId: StructCombos(id: 0, name: ''),
                                        clasificationId: StructCombos(id: 0, name: ''),
                                        email: '',
                                        cantonId: StructCombos(id: 0, name: ''),
                                        regionId: StructCombos(id: 0, name: ''),
                                        sectorId: StructCombos(id: 0, name: '')
                                      ),
                                      sourceId: StructCombos (
                                        id: idOrigen,
                                        name: originEditSelect
                                      ),
                                      stageId: StageId (
                                        id: 2,
                                        name: '',
                                        isWon: false
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
                                    referred: recomendadoPorEditTxt.text,
                                    active: objDatumCrmLeadEdit?.active
                                  );

                                    ProspectoRegistroResponseModel? objRsp = await ProspectoTypeService().editaProspecto(objProsp);
                                    
                                    
                                    if(objRsp != null){
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
                                    //context.pop();
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
                                  
                                    }
                                    else{
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
                                                    child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                                  ),
                      
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.95,
                                                    height: size.height * 0.08,
                                                    alignment: Alignment.center,
                                                    child: const AutoSizeText(
                                                      "Error al editar prospecto.",
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
                                    }


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

              //return Container();
              return const SizedBox.shrink();
            }
          );
          
        }
      ),
        
    );
  }

}
