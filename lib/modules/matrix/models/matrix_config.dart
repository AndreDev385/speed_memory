/// Configuration for the Matrix exercise.
class MatrixConfig {
  /// Number of columns in the matrix.
  final int columns;

  /// Number of rows in the matrix.
  final int rows;

  /// Time in seconds the matrix is displayed on screen.
  final double showTime;

  /// Time in seconds the screen is blank between matrices.
  final double blankTime;

  /// Number of matrices in the series.
  final int numberOfMatrices;

  /// Creates a new MatrixConfig instance.
  const MatrixConfig({
    required this.columns,
    required this.rows,
    required this.showTime,
    required this.blankTime,
    required this.numberOfMatrices,
  });

  /// Creates a default MatrixConfig instance.
  /// Defaults to 3 columns, 2 rows, 4 seconds on screen,
  /// 2 seconds off screen, and a series of 4 matrices.
  factory MatrixConfig.defaultConfig() {
    return const MatrixConfig(
      columns: 3,
      rows: 2,
      showTime: 4,
      blankTime: 2,
      numberOfMatrices: 4,
    );
  }
}
