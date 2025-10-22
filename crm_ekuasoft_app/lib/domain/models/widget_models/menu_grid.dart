import 'package:flutter/material.dart';

class MenuGridWidgetModel {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const MenuGridWidgetModel({required this.icon, required this.title, this.onTap});
}