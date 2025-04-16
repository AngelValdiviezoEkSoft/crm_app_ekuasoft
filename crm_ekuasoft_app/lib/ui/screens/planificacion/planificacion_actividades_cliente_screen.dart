
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';

late TextEditingController motivoPlanTxt;
late TextEditingController resumenTxt;
late TextEditingController comentariosTxt;
String fechaVencimiento = "";
String? _selectedTpAct;

class PlanificacionActividadClienteScreen extends StatefulWidget {
  const PlanificacionActividadClienteScreen({super.key});

  @override
  State<PlanificacionActividadClienteScreen> createState() => _PlanificacionActividadClienteScreenState();
}

//class MarcacionScreen extends StatelessWidget {
class _PlanificacionActividadClienteScreenState extends State<PlanificacionActividadClienteScreen> {

  final LocalAuthentication auth = LocalAuthentication();
  //_SupportState _supportState = _SupportState.unknown;
  
  @override
  void initState() {
    super.initState();
    motivoPlanTxt = TextEditingController();
    resumenTxt = TextEditingController();
    comentariosTxt = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    ColorsApp objColorsApp = ColorsApp();

    //ScrollController scrollListaClt = ScrollController();

    final size = MediaQuery.of(context).size;

    final List<String> tipoActividades = ['Llamada', 'Visita', 'Cobro'];
    
    return Scaffold(
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {

            return Scaffold(
                  appBar: EcvAppBarWidget(
                    null,
                  'Planificación de actividad',//AppLocalizations.of(context)!.iniciarSesion,
                  oColorLetra: AppLightColors().gray800SecondaryText,
                  onPressed: () {
                    context.pop();
                  },
                  backgorundAppBarColor: AppLightColors().gray100Background,
                ),
                  body: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                                  
                          Container(
                            height: size.height * 0.15,
                            width: size.width * 0.33,
                            color: Colors.transparent,
                            child: Image.asset(
                              'assets/logos_app/ic_ekuasoft.png',
                              height: size.height * 0.35,
                            ),
                          ),
                                  
                          SizedBox(height: size.height * 0.01,),
                  
                          Container(
                            width: size.width * 0.88,
                            height: size.height * 0.07,
                            color: Colors.transparent,
                            child: DropdownButton<String>(
                              hint: const Text('Selecciona un tipo de actividad', style: TextStyle(color: Colors.black),),
                              value: _selectedTpAct,
                              //style: TextStyle(color: Colors.white),
                              dropdownColor: Colors.white,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedTpAct = newValue;
                                });
                              },
                              items: tipoActividades.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(                                  
                                  value: value,
                                  child: Text(value, style: const TextStyle(color: Colors.black)),//objColorsApp.azul50PorcTrans),),
                                );
                              }).toList(),
                            ),
                          ),
                  
                          SizedBox(height: size.height * 0.05,),
                  
                          const Text(
                            'Resumen',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                  
                          SizedBox(height: size.height * 0.03,),
                  
                          Container(
                            color: Colors.transparent,
                            width: size.width * 0.92,
                            alignment: Alignment.topCenter,
                            child: TextFormField(     
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                                hintText: 'Por ejemplo, conversación de una propuesta',  // Aquí se define el hintText
                                //border: OutlineInputBorder(),        // Bordes alrededor del TextField
                              ),
                              controller: resumenTxt,
                              autocorrect: false,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20, color: Colors.white),
                              onChanged: (value) {},
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                            ),
                          ),
                  
                          SizedBox(height: size.height * 0.03,),
                  
                          const Text(
                            'Fecha de vencimiento',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          
                          SizedBox(height: size.height * 0.02,),
                  
                          Container(
                            color: Colors.transparent,
                            width: size.width * 0.85,
                            child: TextButton(
                              style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: const BorderSide(color: Colors.black)))),
                              onPressed: () async {
                                initializeDateFormatting('es');
                                //DateTime fechaActual = DateTime.now();
                                //int anioActual = fechaActual.year;
                                //int anioValido = anioActual - 18;
                                DateTime? varSelectedDate = await showDatePicker(
                                  cancelText: 'Cancelar',
                                  confirmText: 'Ok',
                                  fieldLabelText: 'Mes/Día/Año',
                                  helpText: '',
                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                                  errorFormatText: 'Formato inválido',
                                  context: context,
                                  initialDate: DateTime(DateTime.now().year - 10),
                                  firstDate: DateTime(DateTime.now().year - 10),
                                  lastDate: DateTime(DateTime.now().year),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: objColorsApp.naranjaIntenso, onPrimary: Colors.white), textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(backgroundColor: Colors.white))),
                                      child: child!,
                                    );
                                  },
                                );
                                              
                                if (varSelectedDate != null) {
                                  /*
                                  varObjetoProspectoFunc!.fechaNacDate = varSelectedDate;
                                  
                                  */
                                  setState(() {
                                    fechaVencimiento = DateFormat('dd-MM-yyyy', 'es').format(varSelectedDate);
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '',
                                    style: TextStyle(color: Colors.transparent),
                                  ),
                                  Text(
                                    fechaVencimiento,
                                    style: const TextStyle(color: Colors.black, fontSize: 15),
                                  ),
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: size.height * 0.02,),
                                  
                          Container(
                            color: Colors.transparent,
                            width: size.width * 0.92,
                            alignment: Alignment.topCenter,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                                hintText: 'Ingrese observaciones',  // Aquí se define el hintText
                                //border: OutlineInputBorder(),        // Bordes alrededor del TextField
                              ),
                              minLines: 2,
                              maxLines: 2,
                              controller: comentariosTxt,
                              autocorrect: false,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                              onChanged: (value) {
                                
                              },
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                            ),
                          ),
                  
                          SizedBox(height: size.height * 0.02,),
                  
                          GestureDetector(
                              onTap: () async {
                                Fluttertoast.showToast(
                                            msg: 'Actividad registrada exitosamente',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                          );
                                //context.push(Rutas().rutaListaClientes);
                                context.pop();
                              },
                              child: ButtonCvsWidget(
                                text: 'Guardar',
                                    //AppLocalizations.of(context)!.iniciarSesion,
                                textStyle: AppTextStyles.h3Bold(
                                    width: size.width,
                                    color: AppLightColors().white),
                              )),
                  
                            SizedBox(height: size.height * 0.02,),
                  
                            Column(
                            children: [
                              SizedBox(
                                height: AppSpacing.space02(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: Text(
                                  'Descartar',//AppLocalizations.of(context)!.olvideClave,
                                  style:
                                      AppTextStyles.bodyBold(width: size.width, color: Colors.white),
                                ),
                              ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: AppSpacing.space02(),
                                    ),
                                  ],
                                ),
                  
                              SizedBox(height: size.height * 0.02,),
                            ],
                          ),
                        
                        ],
                      ),
                    ),
                  ),
                );
              
        }
      ),
    );
  }
}
