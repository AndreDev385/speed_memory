import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_memory/modules/colored_figures/models/colored_figures_config.dart';

/// Service to manage persistent storage of ColoredFiguresConfig.
class ColoredFiguresConfigService {
  static const String _keyNumberOfFigures = 'colored_figures_config_number_of_figures';
  static const String _keyShowTime = 'colored_figures_config_show_time';
  static const String _keyBlankTime = 'colored_figures_config_blank_time';

  /// Loads the ColoredFiguresConfig from SharedPreferences.
  /// If no config is found, returns the default config.
  Future<ColoredFiguresConfig> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();

    final int numberOfFigures = prefs.getInt(_keyNumberOfFigures) ?? 4;
    final double showTime = prefs.getDouble(_keyShowTime) ?? 3;
    final double blankTime = prefs.getDouble(_keyBlankTime) ?? 1;

    return ColoredFiguresConfig(
      numberOfFigures: numberOfFigures,
      showTime: showTime,
      blankTime: blankTime,
    );
  }

  /// Saves the ColoredFiguresConfig to SharedPreferences.
  Future<void> saveConfig(ColoredFiguresConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNumberOfFigures, config.numberOfFigures);
    await prefs.setDouble(_keyShowTime, config.showTime);
    await prefs.setDouble(_keyBlankTime, config.blankTime);
  }
}