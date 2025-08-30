import 'package:flutter/foundation.dart';
import 'package:speed_memory/shared/services/matrix_config_service.dart';
import 'package:speed_memory/modules/matrix/models/matrix_config.dart';

/// A ChangeNotifier to manage the MatrixConfig state across the app.
class MatrixConfigProvider with ChangeNotifier {
  MatrixConfig _config = MatrixConfig.defaultConfig();
  final MatrixConfigService _configService = MatrixConfigService();

  /// Gets the current configuration.
  MatrixConfig get config => _config;

  /// Loads the configuration from persistent storage.
  Future<void> loadConfig() async {
    _config = await _configService.loadConfig();
    notifyListeners();
  }

  /// Updates the configuration and saves it to persistent storage.
  Future<void> updateConfig(MatrixConfig newConfig) async {
    _config = newConfig;
    await _configService.saveConfig(newConfig);
    notifyListeners();
  }
}