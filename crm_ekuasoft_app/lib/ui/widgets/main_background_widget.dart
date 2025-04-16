import 'package:flutter/material.dart';

class MainBackgroundWidget extends StatelessWidget {
  final Widget child;

  const MainBackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/main_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
