import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:crm_ekuasoft_app/infraestructure/infraestructure.dart';
import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

part 'generic_event.dart';
part 'generic_state.dart';

class GenericBloc extends Bloc<GenericEvent, GenericState> { 
  int positionMenu = 0;
  int positionFormaPago = 0;
  double coordenadasMapa = 0;
  double radioMarcacion = 0;
  String formaPago = '';
  String localidadId = '';
  String idFormaPago = '';
  double heightModalPlanAct = 0.65;
  bool muestraCarga = false;
  bool inicioCarga = true;

  GenericBloc() : super(const GenericState(
    positionMenu: 0, positionFormaPago: 0, coordenadasMapa: 0.0, 
    radioMarcacion: 0.0,formaPago: '',localidadId: '', idFormaPago: '', 
    heightModalPlanAct: 0.65, muestraCarga: false, inicioCarga: true)) {
    on<OnNewCambioHeightModalPlanActEvent>(_onReInitHeight);
    on<OnNewPositionEvent>(_onReInitPosition);
    on<OnNewCoordenadasPositionEvent>(_onReInitPositionMapa);
    on<OnNewFormaPagoEvent>(_onCambioFormaPago);
    on<OnNewRadioMarcacionEvent>(_onCambioRadio);//_onCambioLocalidad
    on<OnNewLocalidadMarcacionEvent>(_onCambioLocalidad);//_onCambioLocalidad
    on<OnNewIdFormaPagoEvent>(_onCambioIdFormaPago);//_onCambioLocalidad  _onInitPositionFormaPago
    on<OnNewPositionFormaPagoEvent>(_onInitPositionFormaPago);//_onCambioLocalidad      
    on<OnNewMuestraCargaEvent>(_onInitMuestraCarga);//_onCambioLocalidad      
    on<OnNewInicioCargaEvent>(_onInitInicioCarga);//_onCambioLocalidad       
  }

  Future<void> init() async {
    add( OnNewPositionEvent(
       positionMenu
    ));
    add( OnNewCoordenadasPositionEvent(
       coordenadasMapa
    ));
    add(OnNewFormaPagoEvent(
      formaPago
    ));
    add(OnNewRadioMarcacionEvent(
      radioMarcacion
    ));
    add(OnNewLocalidadMarcacionEvent(
      localidadId
    ));
    add(OnNewIdFormaPagoEvent(
      idFormaPago
    ));
    add(OnNewPositionFormaPagoEvent(
      positionFormaPago
    ));
    add(
      OnNewMuestraCargaEvent(muestraCarga)
    );
  }

  void _onInitMuestraCarga( OnNewMuestraCargaEvent event, Emitter<GenericState> emit ) {
    emit( state.copyWith( muestraCarga: muestraCarga ) );
  }

  void _onInitInicioCarga( OnNewInicioCargaEvent event, Emitter<GenericState> emit ) {
    emit( state.copyWith( inicioCarga: inicioCarga ) );
  }

  void _onReInitHeight( OnNewCambioHeightModalPlanActEvent event, Emitter<GenericState> emit ) {
    emit( state.copyWith( heightModalPlanAct: heightModalPlanAct ) );
  }

  void _onReInitPosition( OnNewPositionEvent event, Emitter<GenericState> emit ) {
    emit( state.copyWith( positionMenu: positionMenu ) );
  }

  void _onReInitPositionMapa( OnNewCoordenadasPositionEvent event, Emitter<GenericState> emit ) {
    emit( state.copyWith( coordenadasMapa: coordenadasMapa ) );
  }

  void _onCambioFormaPago( OnNewFormaPagoEvent event, Emitter<GenericState> emit ) {
    emit( state.copyWith( formaPago: formaPago ) );
  }

  void _onCambioRadio( OnNewRadioMarcacionEvent event, Emitter<GenericState> emit ) {
    emit( state.copyWith( radioMarcacion: radioMarcacion ) );
  }

  void _onCambioIdFormaPago( OnNewIdFormaPagoEvent event, Emitter<GenericState> emit ) {
    emit( state.copyWith( idFormaPago: idFormaPago ) );
  }

  void _onCambioLocalidad( OnNewLocalidadMarcacionEvent event, Emitter<GenericState> emit ) {
    emit( state.copyWith( localidadId: localidadId ) );
  }

  void _onInitPositionFormaPago( OnNewPositionFormaPagoEvent event, Emitter<GenericState> emit ) {
    emit( state.copyWith( positionFormaPago: positionFormaPago ) );
  }

  void setPosicionFormaPago(int varPositionFormaPago) {
    positionFormaPago = varPositionFormaPago;
    add(OnNewPositionFormaPagoEvent(varPositionFormaPago));
  }

  void getPosicion() {
    add(OnNewPositionEvent(positionMenu));
  }

  void setPosicion(int posicionMenu) {
    positionMenu = posicionMenu;
    add(OnNewPositionEvent(posicionMenu));
  }

  void setPosicionMapa(double coordenadasMapas) {
    coordenadasMapa = coordenadasMapas;
    add(OnNewCoordenadasPositionEvent(coordenadasMapas));
  }

  void setFormaPago(String formaPagos) {
    formaPago = formaPagos;
    add(OnNewFormaPagoEvent(formaPagos));
  }

  void setRadioMarcacion(double radioMarcaciones) {
    radioMarcacion = radioMarcaciones;
    add(OnNewRadioMarcacionEvent(radioMarcaciones));
  }

  //OnNewLocalidadMarcacionEvent
  void setLocalidadId(String localidadIdCambiable) {
    localidadId = localidadIdCambiable;
    add(OnNewLocalidadMarcacionEvent(localidadIdCambiable));
  }

  void setIdFormaPago(String idFormaPagos) {
    idFormaPago = idFormaPagos;
    add(OnNewIdFormaPagoEvent(idFormaPagos));
  }

  void setHeightModalPlanAct(double varheightModalPlanAct) {
    heightModalPlanAct = varheightModalPlanAct;
    add(OnNewCambioHeightModalPlanActEvent(heightModalPlanAct));
  }

  void setMuestraCarga(bool varMuestraCarga) {//
    muestraCarga = varMuestraCarga;
    add(OnNewMuestraCargaEvent(varMuestraCarga));
  }

  void setIniciaCarga(bool varMuestraCarga) {//
    inicioCarga = varMuestraCarga;
    add(OnNewInicioCargaEvent(inicioCarga));
  }

  @override
  //ignore: unnecessary_overrides
  Future<void> close() {
    return super.close();
  }

}

 