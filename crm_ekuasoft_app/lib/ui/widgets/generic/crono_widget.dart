import 'dart:async';
import 'package:flutter/material.dart';

class CronometroWidget extends StatefulWidget {

  const CronometroWidget(Key? key) : super(key: key);

  @override
  CronometroWidgetState createState() => CronometroWidgetState();
}

class CronometroWidgetState extends State<CronometroWidget> {
  Timer? _timer;
  int _segundos = 0; // Tiempo en segundos
  bool _corriendo = false;

  void iniciarCronometro() {
    if (!_corriendo) {
      _corriendo = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _segundos++;
        });
      });
    }
  }

  void detenerCronometro() {
    if (_corriendo) {
      _timer?.cancel();
      _corriendo = false;
    }
  }

  void reiniciarCronometro() {
    _timer?.cancel();
    setState(() {
      _segundos = 0;
      _corriendo = false;
    });
  }

  String formatearTiempo(int segundos) {
    int horas = segundos ~/ 3600;
    int minutos = (segundos % 3600) ~/ 60;
    int segs = segundos % 60;
    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar el timer al destruir el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.95,
      height: size.height * 0.11,
      color: Colors.transparent,
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatearTiempo(_segundos),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            
            ],
          ),
        ),
    );
  }
}
