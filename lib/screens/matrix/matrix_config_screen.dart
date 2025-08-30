import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/matrix_config_provider.dart';
import '../../modules/matrix/models/matrix_config.dart';

class MatrixConfigScreen extends StatefulWidget {
  const MatrixConfigScreen({super.key});

  @override
  State<MatrixConfigScreen> createState() => _MatrixConfigScreenState();
}

class _MatrixConfigScreenState extends State<MatrixConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the TextFields
  late TextEditingController _rowsController;
  late TextEditingController _columnsController;
  late TextEditingController _numMatricesController;
  late TextEditingController _showTimeController;
  late TextEditingController _blankTimeController;

  @override
  void initState() {
    super.initState();
    final configProvider = context.read<MatrixConfigProvider>();
    final config = configProvider.config;

    _rowsController = TextEditingController(text: config.rows.toString());
    _columnsController = TextEditingController(text: config.columns.toString());
    _numMatricesController =
        TextEditingController(text: config.numberOfMatrices.toString());
    _showTimeController =
        TextEditingController(text: config.showTime.toStringAsFixed(2));
    _blankTimeController =
        TextEditingController(text: config.blankTime.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _rowsController.dispose();
    _columnsController.dispose();
    _numMatricesController.dispose();
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
      final configProvider = context.read<MatrixConfigProvider>();

      final int rows = int.parse(_rowsController.text);
      final int columns = int.parse(_columnsController.text);
      final int numOfMatrices = int.parse(_numMatricesController.text);
      final double showTime = double.parse(_showTimeController.text);
      final double blankTime = double.parse(_blankTimeController.text);

      final MatrixConfig newConfig = MatrixConfig(
        rows: rows,
        columns: columns,
        numberOfMatrices: numOfMatrices,
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
        title: const Text('Configuración de Matrices'),
        centerTitle: true,
      ),
      body: Center(
        // Center horizontally and vertically
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 400, // Set a maximum width
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _rowsController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Filas',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // Only integers
                    validator: (value) =>
                        _validatePositiveInteger(value, 'Filas'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _columnsController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Columnas',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // Only integers
                    validator: (value) =>
                        _validatePositiveInteger(value, 'Columnas'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numMatricesController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Matrices',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // Only integers
                    validator: (value) =>
                        _validatePositiveInteger(value, 'Número de Matrices'),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 24),
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
