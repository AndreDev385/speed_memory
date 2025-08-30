import 'package:flutter/material.dart';

class ColoredFiguresScreen extends StatelessWidget {
  const ColoredFiguresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Figuras'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Pantalla para el módulo de Figuras de Colores'),
      ),
    );
  }
}
