
//import 'package:crm_ekuasoft_app/domain/domain.dart';
//import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InformativeScreen extends StatefulWidget {
  
  const InformativeScreen(Key? key) : super(key: key);

  @override
  State<InformativeScreen> createState() => InformativeScreenState();

}

class InformativeScreenState extends State<InformativeScreen>  {

  late final WebViewController _wvController;

  @override
  void initState() {
    super.initState();
    terminoBusquedaActAgenda = '';
    actualizaListaActAgenda = false;    
    actividadesFilAgenda = [];
    contLstAgenda = 0;
    isSelected = [false,true ];
    selectedDayGen = DateTime.now();
    focusedDayGen = DateTime.now();

    _wvController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.ekuasoft.com/blog/automatizacion-con-odoo-6/metodologia-de-implementacion-de-odoo-64'));
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    /*
    return FutureBuilder(
      future: InformativeService().getLinksInformation(),
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
        
        if(snapshot.hasData && snapshot.data != null) {

          ActivitiesPageModel rspAct = snapshot.data as ActivitiesPageModel;

          return Scaffold(
            appBar: AppBar(
              title: const Text("Agenda"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  context.pop();
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // Acción del botón de refrescar
                  },
                ),
              ],
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
            ),
            body: Container(
              width: size.width * 0.99,
              height: size.height,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    
                    SizedBox(height:  size.height * 0.02,),
          
                    SizedBox(height: size.height * 0.008),

                    if(contLstAgenda > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          actualizaListaActAgenda = true;
                          terminoBusquedaActAgenda = value;                          
                        },
                        decoration: InputDecoration(
                          labelText: 'Buscar agendas por nombre.',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    //if(contLstAgenda > 0)
                    SizedBox(height: size.height * 0.007),


                  ],
                ),
              ),
            ),
          );
        }

        return Center(
          child: Container(
            color: Colors.transparent,
            child: Image.asset('assets/gifs/gif_carga.gif'),
          ),
        );
      }
    );
    */

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
          title: const Text('Página informativa'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      
      body: Container(
        color: Colors.transparent,
        width: size.width,
        height: size.height * 0.9,//300,
        child: WebViewWidget(controller: _wvController)
      ),
    );
  }

}
