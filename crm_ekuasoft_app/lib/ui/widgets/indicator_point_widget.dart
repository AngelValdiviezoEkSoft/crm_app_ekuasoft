import 'package:flutter/material.dart';


class IndicatorPointWidget extends StatelessWidget {

  const IndicatorPointWidget(Key? key):super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
        child: CustomPaint(
          size: Size(size.width * 0.04, size.height * 0.03), // Tamaño del widget
          painter: IndicatorPointPainterWidget(),
        ),
    );
  }
}

class IndicatorPointPainterWidget extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Fondo gris
    paint.color = Colors.transparent;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    
    // Dibujar un rectángulo blanco en el fondo
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.2, size.height * 0.3, size.width * 0.6, size.height * 0.4), paint);
    
    // Círculo exterior (borde verde)
    paint.color = Colors.green;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width * 0.3, paint);
    
    // Círculo interior rojo
    paint.color = Colors.red;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width * 0.25, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
