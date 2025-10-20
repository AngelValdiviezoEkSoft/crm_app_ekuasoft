import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoricoActByProspView extends StatefulWidget {

  const HistoricoActByProspView(Key? key) : super(key: key);

  @override
  HistoricoActByProspViewState createState() => HistoricoActByProspViewState();
}

class HistoricoActByProspViewState extends State<HistoricoActByProspView> {

  ColorsApp objColorsApp = ColorsApp();
  List<DatumActivitiesResponse> lstActividadesHistoricosByProspecto = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {      
      await cargaActividadesByCliente();
      //ignore: use_build_context_synchronously
      final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      gnrBloc.setMuestraCarga(false);
    });

  }

  
   Future<void> cargaActividadesByCliente() async {
    try {
      final gnrBloc = Provider.of<GenericBloc>(context, listen: false);
      gnrBloc.setIniciaCarga(true);
      
      ActivitiesPageModel? objRspFinal = await ActivitiesService().getActivitiesHistoricasByProspecto(objDatumCrmLead?.id ?? 0);

      if(objRspFinal != null && lstActividadesHistoricosByProspecto.isEmpty){
        lstActividadesHistoricosByProspecto = objRspFinal.activities.data;
        //actividadesFilAgendaPlanAct = objRspFinal.objMailAct.data;
        //lstActividadesAct = [];
        objDatumCrmLead = objRspFinal.lead;
        /*
        for(int i = 0; i < actividadesFilAgendaPlanAct.length; i++){
          lstActividadesAct.add(actividadesFilAgendaPlanAct[i].name ?? '');
        }

        if(actPlanSelectAct.isEmpty && lstActividadesAct.isNotEmpty){
          actPlanSelectAct = lstActividadesAct.first;
        }
        */
      }

      gnrBloc.setIniciaCarga(false);
/*
      setState(() {
        //_mensaje = "¡Datos recibidos!";
      });
      */

    } catch (_) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //ScrollController scrollListaClt = ScrollController();

    final gnrBloc = Provider.of<GenericBloc>(context);
    gnrBloc.setMuestraCarga(true);
    //final themeProvider = Provider.of<ThemeProvider>(context);
  
    return BlocBuilder<GenericBloc, GenericState>(
      builder: (context,state) {

        if(!state.inicioCarga){
          gnrBloc.setMuestraCarga(false);
        }

              return !state.muestraCarga 
              ? 
                Column(
                  children: [
                    Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          if(lstActividadesHistoricosByProspecto.isNotEmpty && !state.muestraCarga)
                          Container(
                            width: size.width * 0.95,
                            height: size.height * 0.07,
                            color: Colors.transparent,
                            child: const Text('Histórico de actividades', style: TextStyle(color: Colors.blueGrey, fontSize: 25, fontWeight: FontWeight.bold),),
                          ),
                      
                          if(lstActividadesHistoricosByProspecto.isNotEmpty && !state.muestraCarga)
                          Container(
                            color: Colors.transparent,
                            width: size.width,
                            height: size.height * 0.62,
                            child: ListView.builder(
                              itemCount: lstActividadesHistoricosByProspecto.length,
                              itemBuilder: ( _, int index ) {
                                    
                                return Slidable(
                                  key: ValueKey(lstActividadesHistoricosByProspecto[index].id),                                
                                  child:  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: lstActividadesHistoricosByProspecto[index].cerrado ? Colors.grey[300] : Colors.white,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: lstActividadesHistoricosByProspecto[index].cerrado ? Colors.black45 : Colors.grey[300],
                                          child: Stack(
                                              children: [
                                                if(lstActividadesHistoricosByProspecto[index].activityCategory != null 
                                                  && lstActividadesHistoricosByProspecto[index].activityCategory!.toLowerCase() != 'whatsapp'
                                                  && lstActividadesHistoricosByProspecto[index].activityCategory!.toLowerCase() != 'phonecall'
                                                  && (lstActividadesHistoricosByProspecto[index].activityCategory!.toLowerCase() != 'email' || lstActividadesHistoricosByProspecto[index].leadEmail == null || lstActividadesHistoricosByProspecto[index].leadEmail!.isEmpty))
                                                const Icon(Icons.person),

                                                if(lstActividadesHistoricosByProspecto[index].activityCategory != null && lstActividadesHistoricosByProspecto[index].activityCategory!.toLowerCase() == 'phonecall')
                                                GestureDetector(
                                                  onTap: () {
                                                    //makePhoneCall(lstActividadesDiariasByProspecto[index].leadPhone!);                                                        
                                                  },
                                                  child: const Icon(Icons.call, size: 22,)
                                                ),

                                                if(lstActividadesHistoricosByProspecto[index].activityCategory != null && lstActividadesHistoricosByProspecto[index].activityCategory!.toLowerCase() == 'email' && lstActividadesHistoricosByProspecto[index].leadEmail != null && lstActividadesHistoricosByProspecto[index].leadEmail!.isNotEmpty)
                                                GestureDetector(
                                                  onTap: () {
                                                    //openEmailApp(lstActividadesDiariasByProspecto[index].leadEmail!);                                                        
                                                  },
                                                  child: const Icon(Icons.email, color: Colors.white, size: 22,)
                                                ),

                                                if(lstActividadesHistoricosByProspecto[index].activityCategory != null && lstActividadesHistoricosByProspecto[index].activityCategory!.toLowerCase() == 'whatsapp' && lstActividadesHistoricosByProspecto[index].leadEmail != null && lstActividadesHistoricosByProspecto[index].leadEmail!.isNotEmpty)
                                                GestureDetector(
                                                  onTap: () {
                                                    //abrirWhatsapp(lstActividadesDiariasByProspecto[index].leadPhone!, size);
                                                  },
                                                  child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 22,)
                                                ),


                                                if(!lstActividadesHistoricosByProspecto[index].cerrado && DateFormat('yyyy-MM-dd', 'es').format(lstActividadesHistoricosByProspecto[index].dateDeadline) == DateFormat('yyyy-MM-dd', 'es').format(DateTime.now()))
                                                Positioned(
                                                  top: size.height * 0.01,
                                                  left: size.width * 0.02,
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.05,
                                                    height: size.height * 0.02,
                                                    child: const IndicatorPointWidget(null)
                                                  ),
                                                )
                                              ]
                                            ),
                                        ),
                                        title: GestureDetector(
                                          onTap: () {
                                            tipoActividadEscogida = lstActividadesHistoricosByProspecto[index].summary ?? '';

                                            setState(() {
                                              
                                            });
                                          },
                                          child: Text(lstActividadesHistoricosByProspecto[index].summary ?? '')
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                                                            
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Tipo de actividad: ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: lstActividadesHistoricosByProspecto[index].activityTypeId.name,
                                                    style: const TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Fecha planificada: ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: DateFormat('dd/MM/yyyy', 'es').format(lstActividadesHistoricosByProspecto[index].dateDeadline),
                                                    style: const TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Hora planificada: ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: lstActividadesHistoricosByProspecto[index].scheduledTimeFormula,
                                                    style: const TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),


                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Creado en: ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: lstActividadesHistoricosByProspecto[index].dateCreate != null ? DateFormat('dd/MM/yyyy HH:MM:SS', 'es').format(lstActividadesHistoricosByProspecto[index].dateCreate!) : "",
                                                    style: const TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          
                                          
                                          ],
                                        ),
                                        
                                      ),
                                    ),
                                  )
                                );
                              
                              },
                            ),
                          ),
                      
                          if(lstActividadesHistoricosByProspecto.isEmpty && !state.muestraCarga)
                          SizedBox(height: size.height * 0.15),
                          
                          if(lstActividadesHistoricosByProspecto.isEmpty && !state.muestraCarga)
                          Container(
                            color: Colors.transparent,
                            width: size.width * 0.95,
                            height: size.height * 0.09,
                            alignment: Alignment.topCenter,
                            child: const AutoSizeText('No existen actividades agendadas para el prospecto', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,), maxLines: 2,  presetFontSizes: [42,40,38,36,34,32,30,28,26,24,22,20,18,16,14,12,10]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ],
                )
              :
              Center(
                  child: Image.asset(
                    "assets/gifs/gif_carga.gif",
                    height: size.width * 0.85,//150.0,
                    width: size.width * 0.85,//150.0,
                  ),
                );
          
      }
    );
  }
}
