import 'package:animate_do/animate_do.dart';
import 'package:crm_ekuasoft_app/config/config.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:one_clock/one_clock.dart';

class ListaActividades extends StatelessWidget {

  const ListaActividades(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int varPosicionMostrar = 0;
    final size = MediaQuery.of(context).size;

    final items = <ItemBoton>[
      ItemBoton('','','',1, Icons.keyboard_arrow_right_sharp, 'Visita', '','','', Colors.white, const Color(0xFF5636D3),false,true,'','','icTramApr.png','icTramAprTrans.png','','', () => context.push(Rutas().rutaListaClientes),),
      ItemBoton('','','',2, Icons.keyboard_arrow_right_sharp, 'Reunión Virtual', '','','', Colors.white, const Color(0xFF5636D3),false,true,'','','icTramProc.png','icTramProcTrans.png','','', () => context.push(Rutas().rutaListaClientes)),
      ItemBoton('','','',3, Icons.keyboard_arrow_right_sharp, 'Reunión Presencial', '','','', Colors.white, const Color(0xFF5636D3),false,true,'','','icCompras.png','icComprasTrans.png','','', () => context.push(Rutas().rutaListaClientes)),      
    ]; 

    String numeroIdentificacion = '';

    List<Widget> itemMap = items.map(
                    (item) => FadeInLeft(
                      duration: const Duration( milliseconds: 250 ),
                      child: 
                        ItemsListasWidget(
                          null,
                          varIdPosicionMostrar: varPosicionMostrar,
                          varEsRelevante: item.esRelevante,
                          varIdNotificacion: item.ordenNot,
                          varNumIdenti: numeroIdentificacion,
                          icon: item.icon,
                          texto: item.mensajeNotificacion,
                          texto2: item.mensaje2,
                          color1: item.color1,
                          color2: item.color2,
                          onPress: () {  },
                          varMuestraNotificacionesTrAp: 0,
                          varMuestraNotificacionesTrProc: 0,
                          varMuestraNotificacionesTrComp: 0,
                          varMuestraNotificacionesTrInfo: 0,
                          varIconoNot: item.iconoNotificacion,
                          //objUserSolicVac: objUserSolicNotificacion, 
                          varIconoNotTrans: item.rutaImagen,
                          permiteGestion: true,
                        ),
                      )
                    ).toList();

    //DateTime dateTime = DateTime.now();

    return Scaffold(
        //backgroundColor: Color(0xFF5636D3),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5636D3),
          actions: const [],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              context.pop();
            },
          ),
          title: Container(
            color: const Color(0xFF5636D3),
            child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Angel Valdiviezo',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            'RUC: xxxxxx',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            'Cod: xxxxxx',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.settings, color: Colors.white),
                          Text(
                            '00:00:00',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const SizedBox(height: 10),

                  /*
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMenuButton('Acciones'),
                        _buildMenuButton('Detalles'),
                        _buildMenuButton('Sucursales'),
                        _buildMenuButton('Cartera'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  */

                  Container(
                    color: Colors.white,//Colors.greenAccent,
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_today, color: Color.fromARGB(255, 4, 162, 76),),
                        SizedBox(width: 5),
                        Text('Agendado para hoy', style: TextStyle(color: Color.fromARGB(255, 4, 162, 76)),),
                        Spacer(),
                        Icon(Icons.expand_more),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /*
                      _buildActionButton('Llegada', Icons.arrow_forward),
                      _buildActionButton('Salida', Icons.arrow_back),
                      */
                    ],
                  ),
                  
                  //const SizedBox(height: 20),
                  /*
                  Text('Gestiones y Más', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenuButton2('Pedidos'),
                      _buildMenuButton2('Cotizaciones'),
                    ],
                  ),
                  */

                  //AnalogClockExample(dateTime),
              /*
              const SizedBox(
                height: 50,
              ),
              */
              //...DigitalClockExample(dateTime),

              Container(
                width: size.width * 0.99,
                color: Colors.transparent,
                child: Center(
                  child: DigitalClock.dark(
                    datetime: DateTime.now(),
                    isLive: true,

                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              
                  _buildArrivalDepartureButtons(),

              _buildCollapsibleSection('Gestiones y Más', [
                Container(
                    margin: const EdgeInsets.only( top: 25 ),
                    width: size.width * 0.99,
                    height: size.height * 0.35,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: <Widget>[
                        const SizedBox( height: 3, ),
                        ...itemMap,
                      ],
                    ),
                  ),
              ]),
              /*
              _buildIndicators(),
              _buildTopProductsTable(),
              */
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget buildMenuButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  
  Widget buildMenuButton2(String title) {
    return Container(
      color: const Color(0xFF5636D3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildArrivalDepartureButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.login, color: Colors.white,),
            label: const Text('Llegada', style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout, color: Colors.white,),
            label: const Text('Salida', style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleSection(String title, List<Widget> items) {
    return ExpansionTile(
      title: Text(title),
      children: items,
    );
  }

  Widget buildExpandableTile(String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        // Handle navigation or expansion logic
      },
    );
  }

  Widget buildIndicators() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Indicadores',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total de Pedidos'),
              Text('[S]1,234.56'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Factura/Cobranza'),
              Text('[S]1,234.56'),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(value: 0.8),
        ],
      ),
    );
  }

   Widget buildTopProductsTable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top 5 Productos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Productos')),
              DataColumn(label: Text('Cantidad')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('Producto 1')),
                DataCell(Text('1,234.56')),
              ]),
              DataRow(cells: [
                DataCell(Text('Producto 2')),
                DataCell(Text('1,234.56')),
              ]),
              DataRow(cells: [
                DataCell(Text('Producto 3')),
                DataCell(Text('1,234.56')),
              ]),
            ],
          ),
        ],
      ),
    );
  }

}


Widget analogClockExample(DateTime dateTimee) {
  return SingleChildScrollView(
    // padding: EdgeInsets.all(7),
    scrollDirection: Axis.horizontal,
    child: Column(
      children: [
        const Text(
          "Analog Clock Example",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            AnalogClock(
              isLive: false,
              width: 120,
              height: 120,
              datetime: dateTimee,
            ),
            const SizedBox(
              width: 10,
            ),
            AnalogClock.dark(
              width: 120,
              height: 120,
              isLive: true,
              datetime: dateTimee,
            ),
            const SizedBox(
              width: 10,
            ),
            AnalogClock(
              width: 120,
              height: 120,
              isLive: true,
              decoration: BoxDecoration(color: Colors.green[100], shape: BoxShape.circle),
              datetime: dateTimee,
            ),
            const SizedBox(
              width: 10,
            ),
            AnalogClock(
              width: 120,
              height: 120,
              isLive: true,
              decoration: BoxDecoration(color: Colors.yellow[100], shape: BoxShape.circle),
              datetime: dateTimee,
            ),
            const SizedBox(
              width: 10,
            ),
            AnalogClock(
              width: 120,
              height: 120,
              isLive: true,
              showDigitalClock: false,
              decoration: BoxDecoration(color: Colors.cyan[100], shape: BoxShape.circle),
              datetime: dateTimee,
            ),
            const SizedBox(
              width: 10,
            ),
            AnalogClock(
              width: 120,
              height: 120,
              isLive: true,
              showDigitalClock: false,
              decoration: BoxDecoration(color: Colors.red[100], shape: BoxShape.circle),
              datetime: dateTimee,
            ),
          ],
        ),
      ],
    ),
  );
}

List<Widget> digitalClockExample(DateTime dateTimee) {
  return [
    SingleChildScrollView(
      //scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          /*
          const Text(
            "Digital Clock Example",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          */
          const SizedBox(
            height: 50,
          ),
          Row(
            //mainAxisSize: MainAxisSize.min,
            children: [
              /*
              DigitalClock(
                showSeconds: true,
                datetime: dateTimee,
                textScaleFactor: 1.3,
                isLive: true,
              ),
              const SizedBox(
                width: 10,
              ),
              */
              DigitalClock.dark(
                datetime: dateTimee,
              ),
              const SizedBox(
                width: 10,
              ),
              /*
              DigitalClock.light(
                isLive: true,
                datetime: dateTimee,
              ),
              const SizedBox(
                width: 10,
              ),
              DigitalClock(
                datetime: dateTimee,
                textScaleFactor: 2,
                showSeconds: false,
                isLive: true,
                decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
              const SizedBox(
                width: 10,
              ),
              DigitalClock(
                datetime: dateTimee,
                isLive: true,
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
              const SizedBox(
                width: 10,
              ),
              DigitalClock(
                datetime: dateTimee,
                isLive: true,
                decoration: const BoxDecoration(color: Colors.yellow, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
              */
            ],
          ),
        ],
      ),
    ),
    /*
    const SizedBox(
      height: 20,
    ),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigitalClock(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            datetime: dateTimee,
            isLive: true,
          ),
          DigitalClock.dark(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            datetime: dateTimee,
          ),
          DigitalClock.light(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            isLive: true,
            datetime: dateTimee,
          )
        ],
      ),
    ),
    const SizedBox(
      height: 20,
    ),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigitalClock(
            datetime: dateTimee,
            isLive: true,
            decoration: const BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.zero)),
          ),
          const SizedBox(
            width: 10,
          ),
          DigitalClock.dark(
            datetime: dateTimee,
            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.zero)),
          ),
          const SizedBox(
            width: 10,
          ),
          DigitalClock.light(
            isLive: true,
            datetime: dateTimee,
            decoration: const BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.zero)),
          ),
          const SizedBox(
            width: 10,
          ),
          DigitalClock(
            datetime: dateTimee,
            isLive: true,
            decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.zero)),
          ),
          const SizedBox(
            width: 10,
          ),
          DigitalClock(
            datetime: dateTimee,
            isLive: true,
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.zero)),
          ),
          const SizedBox(
            width: 10,
          ),
          DigitalClock(
            datetime: dateTimee,
            isLive: true,
            decoration: const BoxDecoration(color: Colors.yellow, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(15))),
          ),
        ],
      ),
    ),
    const SizedBox(
      height: 20,
    ),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigitalClock(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            datetime: dateTimee,
            decoration: const BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.zero)),
            isLive: true,
          ),
          DigitalClock.dark(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            datetime: dateTimee,
            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.zero)),
          ),
          DigitalClock.light(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            isLive: true,
            datetime: dateTimee,
            decoration: const BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.zero)),
          )
        ],
      ),
    ),
    const SizedBox(
      height: 50,
    ),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          const Text(
            "Digital Clock Example with custom INTL format",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigitalClock(
                format: "H",
                showSeconds: true,
                datetime: dateTimee,
                textScaleFactor: 1.3,
                isLive: true,
              ),
              const SizedBox(
                width: 10,
              ),
              DigitalClock.dark(
                format: "Hm",
                datetime: dateTimee,
              ),
              const SizedBox(
                width: 10,
              ),
              DigitalClock.light(
                format: "Hms",
                isLive: true,
                datetime: dateTimee,
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: DigitalClock(
                  format: 'yMMMEd',
                  datetime: dateTimee,
                  textScaleFactor: 1,
                  showSeconds: false,
                  isLive: true,
                  // decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  */
  ];
}