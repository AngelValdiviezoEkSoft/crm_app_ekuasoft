
//import 'package:crm_ekuasoft_app/config/config.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

ResPartnerDatumAppModel? objPerfil;
late Future<String> dataProf;
bool isCve = false;

class ProfileScreenGen extends StatelessWidget {
  
  ProfileScreenGen({super.key}){
    dataProf = gtDatosPerfil();
    isCve = false;
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi perfil"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(context, size),
            const SizedBox(height: 20),
            _buildOptionCard(context),
            const SizedBox(height: 20),
            const Text("Más", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildAdditionalOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, Size size) {
    return FutureBuilder(
      future: dataProf,//AuthService().getDatosPerfil(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

        if(snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty){
          String respuesta = '${snapshot.data}';

          List<String> arrayRsp = respuesta.split('%%%');

          objPerfil = ResPartnerDatumAppModel.fromRawJson(arrayRsp[0]);

          String db = arrayRsp[1];

          if(db.isNotEmpty && db.toLowerCase().contains(EnvironmentsProd().baseCentroViajes)){            
            isCve = true;
          }

        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              SizedBox(width: size.width * 0.035),//16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      objPerfil?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      objPerfil?.street ?? '',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push(objRutasGen.rutaProf);
                },
                child: const Icon(Icons.info_outline, color: Colors.white)
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildOptionCard(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 1 ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Column(
        children: [
          _buildListTile(context, Icons.lock, 'Cambiar contraseña'),
          const Divider(height: 1),
          _buildListTile(context, Icons.settings, 'Configuración'),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: themeProvider.themeMode.index == 0 || themeProvider.themeMode.index == 1 ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Column(
        children: [
          _buildListTile(context, Icons.privacy_tip, 'Política de privacidad'),
          const Divider(height: 1),
          _buildListTile(context, Icons.description, 'Términos y condiciones'),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        
        if(title == 'Cambiar contraseña'){
          context.push(objRutasGen.rutaFrmChangePassword);
        }

        if(title == 'Configuración'){
          context.push(objRutasGen.rutaSettingsUser);
        }

        if(title == 'Términos y condiciones'){
          context.push(objRutasGen.rutaTermCond2);
        }

        //

      },
    );
  }
}


Future<String> gtDatosPerfil() async {
  try{
    return await AuthService().getDatosPerfil();
  }
  catch(ex){
    return '';
  }
}