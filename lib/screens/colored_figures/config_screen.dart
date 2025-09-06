import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/colored_figures_config_provider.dart';
import '../../modules/colored_figures/models/colored_figures_config.dart';
import '../../shared/theme/dimensions.dart'; // Importar las dimensiones

class ColoredFiguresConfigScreen extends StatefulWidget {
  const ColoredFiguresConfigScreen({super.key});

  @override
  State<ColoredFiguresConfigScreen> createState() => _ColoredFiguresConfigScreenState();
}

class _ColoredFiguresConfigScreenState extends State<ColoredFiguresConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the TextFields
  late TextEditingController _numFiguresController;
  late TextEditingController _showTimeController;
  late TextEditingController _blankTimeController;

  @override
  void initState() {
    super.initState();
    final configProvider = context.read<ColoredFiguresConfigProvider>();
    final config = configProvider.config;

    _numFiguresController =
        TextEditingController(text: config.numberOfFigures.toString());
    _showTimeController =
        TextEditingController(text: config.showTime.toStringAsFixed(2));
    _blankTimeController =
        TextEditingController(text: config.blankTime.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _numFiguresController.dispose();
    _showTimeController.dispose();
    _blankTimeController.dispose();
    super.dispose();
  }

  // Helper to validate integer fields (positive only)
  String? _validatePositiveInteger(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un valor para $fieldName';
    }
    final n = int.tryParse(value);
    if (n == null) {
      return '$fieldName debe ser un número entero';
    }
    if (n <= 0) {
      return '$fieldName debe ser un número positivo';
    }
    return null; // Valid
  }

  // Helper to validate double fields (positive only)
  String? _validatePositiveDouble(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un valor para $fieldName';
    }
    final n = double.tryParse(value);
    if (n == null) {
      return '$fieldName debe ser un número';
    }
    if (n <= 0) {
      return '$fieldName debe ser un número positivo';
    }
    return null; // Valid
  }

  void _saveConfig() {
    if (_formKey.currentState!.validate()) {
      final configProvider = context.read<ColoredFiguresConfigProvider>();

      final int numOfFigures = int.parse(_numFiguresController.text);
      final double showTime = double.parse(_showTimeController.text);
      final double blankTime = double.parse(_blankTimeController.text);

      final ColoredFiguresConfig newConfig = ColoredFiguresConfig(
        numberOfFigures: numOfFigures,
        showTime: showTime,
        blankTime: blankTime,
      );

      configProvider.updateConfig(newConfig);
      Navigator.of(context).pop(); // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Figuras de Colores'),
        centerTitle: true,
      ),
      body: Center(
        // Center horizontally and vertically
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: SizedBox(
            width: AppDimensions.maxWidthConstraint, // Set a maximum width
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _numFiguresController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Figuras',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // Only integers
                    validator: (value) =>
                        _validatePositiveInteger(value, 'Número de Figuras'),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  // Show Time
                  TextFormField(
                    controller: _showTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Tiempo en Pantalla (segundos)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true), // Allow decimals
                    validator: (value) =>
                        _validatePositiveDouble(value, 'Tiempo en Pantalla'),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  // Blank Time
                  TextFormField(
                    controller: _blankTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Tiempo en Blanco (segundos)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true), // Allow decimals
                    validator: (value) =>
                        _validatePositiveDouble(value, 'Tiempo en Blanco'),
                  ),
                  const SizedBox(height: AppDimensions.spacingBetweenElements),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveConfig,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child:
                          const Text('Guardar', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}