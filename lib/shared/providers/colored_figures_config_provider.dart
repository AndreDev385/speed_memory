import 'package:flutter/foundation.dart';
import 'package:speed_memory/shared/services/colored_figures_config_service.dart';
import 'package:speed_memory/modules/colored_figures/models/colored_figures_config.dart';

/// A ChangeNotifier to manage the ColoredFiguresConfig state across the app.
class ColoredFiguresConfigProvider with ChangeNotifier {
  ColoredFiguresConfig _config = ColoredFiguresConfig.defaultConfig();
  final ColoredFiguresConfigService _configService = ColoredFiguresConfigService();

  /// Gets the current configuration.
  ColoredFiguresConfig get config => _config;

  /// Loads the configuration from persistent storage.
  Future<void> loadConfig() async {
    _config = await _configService.loadConfig();
    notifyListeners();
  }

  /// Updates the configuration and saves it to persistent storage.
  Future<void> updateConfig(ColoredFiguresConfig newConfig) async {
    _config = newConfig;
    await _configService.saveConfig(newConfig);
    notifyListeners();
  }
}