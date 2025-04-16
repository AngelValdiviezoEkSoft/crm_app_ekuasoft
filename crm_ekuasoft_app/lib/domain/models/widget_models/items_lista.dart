import 'package:flutter/material.dart';

class ItemBoton {
  final String tipoNotificacion;
  final String idSolicitud;
  final String idNotificacionGen;
  final int ordenNot;
  final IconData icon;
  final String mensajeNotificacion;
  final String mensaje2;
  final String fechaNotificacion;
  final String tiempoDesde;
  final Color color1;
  final Color color2;
  final bool requiereAccion;
  final bool esRelevante;
  final String estadoLeido;
  final String numIdenti;
  final String iconoNotificacion;
  final String rutaImagen;
  final String idTransaccion;
  final String rutaNavegacion;
  @required final VoidCallback? onPress;

  ItemBoton(this.tipoNotificacion,this.idSolicitud,this.idNotificacionGen,this.ordenNot, this.icon, this.mensajeNotificacion, this.mensaje2, this.fechaNotificacion,this.tiempoDesde, this.color1, this.color2, this.requiereAccion, this.esRelevante, this.estadoLeido, this.numIdenti, this.iconoNotificacion, this.rutaImagen, this.idTransaccion, this.rutaNavegacion, this.onPress );
}
