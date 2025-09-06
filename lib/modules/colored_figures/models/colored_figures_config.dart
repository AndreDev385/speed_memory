/// Configuration for the Colored Figures exercise.
class ColoredFiguresConfig {
  /// Number of figures in the game.
  final int numberOfFigures;

  /// Time in seconds each figure is displayed on screen.
  final double showTime;

  /// Time in seconds the screen is blank between figures.
  final double blankTime;


  /// Creates a new ColoredFiguresConfig instance.
  const ColoredFiguresConfig({
    required this.numberOfFigures,
    required this.showTime,
    required this.blankTime,
  });

  /// Creates a default ColoredFiguresConfig instance.
  /// Defaults to 5 figures in sequence, 3 seconds on screen,
  /// 1 second off screen, and a series of 3 sequences.
  factory ColoredFiguresConfig.defaultConfig() {
    return const ColoredFiguresConfig(
      numberOfFigures: 4,
      showTime: 3,
      blankTime: 1,
    );
  }
}
