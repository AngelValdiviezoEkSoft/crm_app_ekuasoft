import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

bool isLoadingScreenQr = false;
const storageQr = FlutterSecureStorage();

//ignore: must_be_immutable
class ScanQrScreen extends StatefulWidget {
  String rutaFotoPerfilTmp = '';
  int? numNotTmp = 0;

  ScanQrScreen(Key? key, {objUserGeneralPrincipalTmp}) : super(key: key) {    
    isLoadingScreenQr = false;
  }

  @override
  ScanQrScreenState createState() => ScanQrScreenState();
}

class ScanQrScreenState extends State<ScanQrScreen> {
  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBarWidget(
          null,
          isLoadingScreenQr ? '' : 'Servidor',
          oColorLetra:
              isLoadingScreenQr ? ColorsApp().morado : Colors.white,
          backgorundAppBarColor: isLoadingScreenQr
              ? ColorsApp().morado
              : Colors.black.withOpacity(0.5),
          arrowBackColor:
              isLoadingScreenQr ? ColorsApp().morado : Colors.white,
          onPressed: () async {
            String cantNav =
                await storageQr.read(key: 'conteoNavegacionTransf') ?? '1';

            int contNav = int.parse(cantNav);

            for (int i = 0; i < contNav; i++) {
              //ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            }
          },
        ),
        backgroundColor: isLoadingScreenQr
            ? ColorsApp().morado
            : Colors.black.withOpacity(0.5),
        body: isLoadingScreenQr
            ? Container(
                color: ColorsApp().morado,
                width: sizeScreen.width,
                height: sizeScreen.height * 0.99,
                child: Image.asset(AppConfig().rutaGifPluxMorado),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  height: sizeScreen.height * 0.85,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSpacing.space04()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Escanear código QR',
                          style: AppTextStyles.h1Bold(
                            width: sizeScreen.width * 0.5,
                            color: AppLightColors().white
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/scan_qr_img.png',
                              width: sizeScreen.width * 0.07,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: AppSpacing.space03(),
                            ),
                            SizedBox(
                              width: sizeScreen.width * 0.8,
                              child: Text(
                                'Encuadra el código QR dentro del marco violeta',
                                style: AppTextStyles.h4Bold(
                                    width: sizeScreen.width,
                                    color: AppLightColors().white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppSpacing.space03(),
                        ),
                        
                        Container(
                          color: Colors.transparent,
                          height: sizeScreen.height * 0.5,
                          alignment: Alignment.center,
                          child: AiBarcodeScanner(
                            canPop: false,
                            onScan: (String value) async {
                              /*
                              //debugPrint(value);
                  
                              setState(() {
                                isLoadingScreenQr = true;
                              });
                  
                              WalletTransaccionResponse
                                  oWalletTransaccionResponse =
                                  await WalletService()
                                      //.consultaContactoTransferir('03670036627N');
                                      .consultaContactoTransferir(value);
                  
                              setState(() {
                                isLoadingScreenQr = false;
                              });
                  
                              //ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        ConfirmacionTransferenciaScreen(
                                          tmpWalletTransac:
                                              oWalletTransaccionResponse,
                                        )),
                              );
                              */
                            },
                            onDetect: (value) async {
                              String valorScaneado = '';
                              
                              if (value.barcodes.isNotEmpty) {
                                var firstItem = value.barcodes[0].rawValue;
                                
                                valorScaneado = firstItem ?? '';
                              } 
                              if (valorScaneado.isNotEmpty) {

                                rutaServerWelcome = valorScaneado;
                                //rutaServerWelcome = 'https://ekuasoft-taller-16347134.dev.odoo.com';

                                context.pop();

                              }
                            },
                            onDispose: () {
                              debugPrint("Barcode scanner disposed!");
                            },
                            controller: MobileScannerController(
                              detectionSpeed: DetectionSpeed.normal,
                              autoStart: true,
                            ),
                            borderColor: AppLightColors().primary,
                            borderRadius: 16,
                            bottomBar: Container(
                              color: Colors.black,
                              height: sizeScreen.height * 0.001,
                              width: sizeScreen.width * 0.001,
                              child: const Text(''),
                            ),
                            bottomBarText: '',
                            bottomBarTextStyle: const TextStyle(fontSize: 1),
                          ),
                        ),
                        
                        SizedBox(
                          height: AppSpacing.space04(),
                        ),
                        SizedBox(
                          height: AppSpacing.space01(),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: ButtonCvsWidget(
                            text: 'Cancelar',
                            textStyle: AppTextStyles.h3Bold(
                                width: sizeScreen.width,
                                color: AppLightColors().white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
