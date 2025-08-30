import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_memory/modules/matrix/models/matrix_config.dart';

/// Service to manage persistent storage of MatrixConfig.
class MatrixConfigService {
  static const String _keyColumns = 'matrix_config_columns';
  static const String _keyRows = 'matrix_config_rows';
  static const String _keyShowTime = 'matrix_config_show_time';
  static const String _keyBlankTime = 'matrix_config_blank_time';
  static const String _keyNumberOfMatrices = 'matrix_config_number_of_matrices';

  /// Loads the MatrixConfig from SharedPreferences.
  /// If no config is found, returns the default config.
  Future<MatrixConfig> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();

    final int columns = prefs.getInt(_keyColumns) ?? 3;
    final int rows = prefs.getInt(_keyRows) ?? 2;
    final double showTime = prefs.getDouble(_keyShowTime) ?? 4;
    final double blankTime = prefs.getDouble(_keyBlankTime) ?? 2;
    final int numberOfMatrices = prefs.getInt(_keyNumberOfMatrices) ?? 4;

    return MatrixConfig(
      columns: columns,
      rows: rows,
      showTime: showTime,
      blankTime: blankTime,
      numberOfMatrices: numberOfMatrices,
    );
  }

  /// Saves the MatrixConfig to SharedPreferences.
  Future<void> saveConfig(MatrixConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyColumns, config.columns);
    await prefs.setInt(_keyRows, config.rows);
    await prefs.setDouble(_keyShowTime, config.showTime);
    await prefs.setDouble(_keyBlankTime, config.blankTime);
    await prefs.setInt(_keyNumberOfMatrices, config.numberOfMatrices);
  }
}
