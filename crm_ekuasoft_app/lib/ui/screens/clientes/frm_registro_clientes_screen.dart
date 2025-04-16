import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_ekuasoft_app/ui/bloc/auth/auth_bloc.dart';
import 'package:crm_ekuasoft_app/ui/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

late TextEditingController montoNuevoTxt;
late TextEditingController nombreTrxTxt;
bool estadoTrx = false;

//ignore: must_be_immutable
class FrmRegistroClientesScreen extends StatefulWidget {

  FrmRegistroClientesScreen(Key? key, {oAdministracionMontosResponse})
      : super(key: key) {
    if (oAdministracionMontosResponse != null) {
      /*
      oAdministracionMontosResponseGen = oAdministracionMontosResponse;
      estadoTrx = oAdministracionMontosResponseGen!.enabled;
      */
    }
  }

  @override
  FrmRegistroClientesScreenState createState() => FrmRegistroClientesScreenState();
}

class FrmRegistroClientesScreenState extends State<FrmRegistroClientesScreen> {
/*
  var currencyFormatter = CurrencyInputFormatter(
    thousandSeparator: ThousandSeparator.None,
  );
*/
  @override
  void initState() {
    super.initState();
    nombreTrxTxt = TextEditingController();
    montoNuevoTxt = TextEditingController();
    /*
    nombreTrxTxt.text = oAdministracionMontosResponseGen!.nameTypeMovement;
    montoNuevoTxt.text = oAdministracionMontosResponseGen!.maxAmount;
    */
  }

  @override
  void dispose() {
    montoNuevoTxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, stateEstado) {
          return 
          /*
          !stateEstado.cambioEstadoBool
              ? 
              */
              Scaffold(
                  backgroundColor: Colors.white,                  
                  appBar: const EcvAppBarWidget(
                    null,
                    'Registro de cliente',
                    oColorLetra: Colors.black,
                    backgorundAppBarColor: Color(0xffF6F6F6),
                    goToHome: true,        
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          color: Colors.black45, //Colors.transparent,
                          width: size.width * 0.95, //- 100,
                          height: size.height * 0.045, //40,
                          alignment: Alignment.centerLeft,
                          child: const AutoSizeText(
                            'Registre nuevo cliente',
                            /*
                            align: TextAlign.center,
                            color: Colors.black,//CorpColors().negroPlux,
                            //fuentePlux: GoogleFontsPlux().fontMulish,
                            sizeLetra: 32,
                            tipoFontWeight: FontWeight.w700,
                            */
                          ),
                        ),
                        Container(
                          color: const Color(0xffF6F6F6),
                          width: size.width,
                          height: size.height * 0.82,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                color: Colors.transparent,
                                width: size.width * 0.91, //- 100,
                                height: size.height * 0.04, //40,
                                alignment: Alignment.center,
                                child: const AutoSizeText('Nombre del cliente',)
                                /*
                                TextoModificableWidget(
                                  'Nombre de transacción',
                                  align: TextAlign.center,
                                  color: CorpColors().negroPlux,
                                  fuentePlux: GoogleFontsPlux().fontMulish,
                                  sizeLetra: 20,
                                  tipoFontWeight: FontWeight.w400,
                                ),
                                */
                              ),
                              SizedBox(
                                height: size.height * 0.07,
                              ),
                              Container(
                                color: Colors.transparent,
                                width: size.width * 0.86,
                                alignment: Alignment.topCenter,
                                child: TextFormField(
                                  
                                  controller: nombreTrxTxt,
                                  autocorrect: false,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                  onChanged: (value) {},
                                  onTapOutside: (event) =>
                                      FocusScope.of(context).unfocus(),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.07,
                              ),
                              Container(
                                color: Colors.transparent,
                                width: size.width * 0.91, //- 100,
                                height: size.height * 0.04, //40,
                                alignment: Alignment.center,
                                child: const AutoSizeText('Apellidos del cliente',)
                                /*
                                TextoModificableWidget(
                                  'Nombre de transacción',
                                  align: TextAlign.center,
                                  color: CorpColors().negroPlux,
                                  fuentePlux: GoogleFontsPlux().fontMulish,
                                  sizeLetra: 20,
                                  tipoFontWeight: FontWeight.w400,
                                ),
                                */
                              ),
                              SizedBox(
                                height: size.height * 0.07,
                              ),
                              Container(
                                color: Colors.transparent,
                                width: size.width * 0.86,
                                alignment: Alignment.topCenter,
                                child: TextFormField(
                                  
                                  controller: nombreTrxTxt,
                                  autocorrect: false,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                  onChanged: (value) {},
                                  onTapOutside: (event) =>
                                      FocusScope.of(context).unfocus(),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.07,
                              ),
                              Container(
                                color: Colors.transparent,
                                width: size.width * 0.91, //- 100,
                                height: size.height * 0.04, //40,
                                alignment: Alignment.center,
                                child: const AutoSizeText('Dirección del cliente',)
                                /*
                                TextoModificableWidget(
                                  'Nombre de transacción',
                                  align: TextAlign.center,
                                  color: CorpColors().negroPlux,
                                  fuentePlux: GoogleFontsPlux().fontMulish,
                                  sizeLetra: 20,
                                  tipoFontWeight: FontWeight.w400,
                                ),
                                */
                              ),
                              Container(
                                color: Colors.transparent,
                                width: size.width * 0.86,
                                alignment: Alignment.topCenter,
                                child: TextFormField(
                                  
                                  controller: nombreTrxTxt,
                                  autocorrect: false,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                  onChanged: (value) {},
                                  onTapOutside: (event) =>
                                      FocusScope.of(context).unfocus(),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.07,
                              ),

                              GestureDetector(
                                          //onTap: () => context.push(Rutas().rutaRegistroCliente),
                                          child: Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.5,
                                              height: size.height * 0.05,
                                              child: const Center(
                                                child: AutoSizeText(
                                                'Guardar',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                  color: Colors.black
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                              )
                                            )
                                          ),
                                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
          /*
              : Scaffold(
                  backgroundColor: oCorpColorsGen.moradoPlux,
                  body: Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.18,
                        ),
                        Container(
                          color: Colors.transparent,
                          width: size.width,
                          height: size.height * 0.2,
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(AppConfig().rutaGifPluxMorado),
                        ),
                        Container(
                          color: Colors.transparent,
                          width: size.width * 0.98,
                          height: size.height * 0.35,
                          child: BaseText(
                            'Espere mientras procesamos su información...',
                            color: CorpColors().white,
                            size: 0.055,
                            weight: FontWeight.w600,
                            maxlines: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                );
        */
        }),
      ),
    );
  }
}
