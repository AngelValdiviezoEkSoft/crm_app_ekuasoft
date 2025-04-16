
import 'package:flutter/material.dart';

class OpcionesMenuModel {
    OpcionesMenuModel({
      required this.icono,
      required this.descMenu,
      required this.onPress
    });

    IconData icono;
    String descMenu;
    @required final VoidCallback? onPress;

}
