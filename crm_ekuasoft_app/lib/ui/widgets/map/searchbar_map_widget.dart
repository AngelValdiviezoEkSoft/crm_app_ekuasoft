
import 'package:animate_do/animate_do.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String filtroBusqueda = '';
String apiKeySearchBarWidgetMap = '';

//ignore: must_be_immutable
class SearchBarWidgetMap extends StatelessWidget {
  String? varFiltroBusqueda;
  String? varApiKey;

  SearchBarWidgetMap(Key? key,{varFiltroBusqueda, varApiKey}) : super(key: key) {
    filtroBusqueda = varFiltroBusqueda;
    apiKeySearchBarWidgetMap = varApiKey;
  }

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);

    //Para que no se mueva el mapa
    Future.delayed(
      const Duration(milliseconds: 5),
      () => locationBloc.stopFollowingUser(),
    );

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) { return state.displayManualMarker 
        ? const SizedBox()
        : FadeInDown(
          duration: const Duration( milliseconds: 300 ),
          child: const _SearchBarWidgetMapBody(null)
        );
      },
    );
  }
}


class _SearchBarWidgetMapBody extends StatelessWidget {
  const _SearchBarWidgetMapBody(Key? key) : super(key: key);

  void onSearchResults( BuildContext context, SearchResult result ) async {
    
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    //locationBloc.stopFollowingUser();

    if ( result.manual == true ) {
      searchBloc.add( OnActivateManualMarkerEvent() );
      return;
    }

    if ( result.position != null ) {
      final destination = await searchBloc.getCoorsStartToEnd( locationBloc.state.lastKnownLocation!, result.position! );
      await mapBloc.drawRoutePolyline(destination);
      
    }

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only( top: 10 ),
        padding: const EdgeInsets.symmetric( horizontal: 30 ),
        width: double.infinity,
        child: GestureDetector(
          onTap: () async { 
            //final locationBloc = BlocProvider.of<LocationBloc>(context);
            final result = await showSearch(context: context, delegate: SearchDestinationDelegate(filtroBusqueda, apiKeySearchBarWidgetMap));
            if ( result == null ) return;
            //locationBloc.stopFollowingUser();
            // ignore: use_build_context_synchronously
            onSearchResults( context, result );
          },
          child: Container(
            padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0,5)
                )
              ]
            ),
            child: const Text('Ingresa tu ubicación', style: TextStyle( color: Colors.black87 )),
          )
        ),
      ),
    );
  }
}