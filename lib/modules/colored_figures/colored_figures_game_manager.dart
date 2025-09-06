import 'models/colored_figures_config.dart';
import 'models/colored_figure.dart';

enum ColoredFiguresGameState {
  /// Initial state, waiting for the game to start.
  initial,

  /// Showing figures to the user.
  showingFigures,

  /// Waiting for the user to input their answers.
  userInput,

  /// Showing the results of the game.
  results,
}

/// Manages the state and logic for the Colored Figures memory game.
/// It holds the configuration, generates the target sequences,
/// tracks the user's input, and calculates the final score.
class ColoredFiguresGameManager {
  /// The configuration for the game, containing sequence length, timings, etc.
  final ColoredFiguresConfig config;

  /// The list of target sequences that the user needs to memorize.
  /// These are generated randomly at the start of the game based on config.
  final List<ColoredFigure> gameFigures;

  /// The list of sequences representing the user's input.
  /// Initially filled with empty sequences matching the target dimensions.
  final List<ColoredFigure?> userFigures;

  /// The current state of the game.
  ColoredFiguresGameState _state = ColoredFiguresGameState.initial;
  ColoredFiguresGameState get state => _state;

  int _currentFigureIndex = 0;
  int get currentFigureIndex => _currentFigureIndex;

  /// Creates a new ColoredFiguresGameManager with the given configuration.
  ///
  /// Initializes the target sequences (randomly generated) and user input sequences (empty).
  ColoredFiguresGameManager({required this.config})
      : gameFigures = List.generate(
          config.numberOfFigures,
          (index) => randomColoredFigure(),
          growable: false,
        ),
        userFigures = List.generate(
          config.numberOfFigures,
          (index) => null,
          growable: false,
        );

  /// Starts the game by transitioning to the 'showingFigures' state.
  void startGame() {
    if (_state != ColoredFiguresGameState.initial) {
      // Prevent starting if already started or finished
      return;
    }
    _state = ColoredFiguresGameState.showingFigures;
    _currentFigureIndex = 0; // Ensure we start from the first figure
  }

  /// Gets the figure that should currently be displayed to the user.
  ColoredFigure? get currentFigureToShow {
    if (_state == ColoredFiguresGameState.showingFigures &&
        _currentFigureIndex >= 0 &&
        _currentFigureIndex < gameFigures.length) {
      return gameFigures[_currentFigureIndex];
    }
    return null;
  }

  /// Advances to the next figure in the current sequence.
  /// If called during 'showingFigures', it moves to the next target figure
  /// or transitions to the next sequence or 'userInput' if all figures have been shown.
  void nextFigure() {
    if (_state == ColoredFiguresGameState.showingFigures) {
      if (_currentFigureIndex < userFigures.length - 1) {
        _currentFigureIndex++;
      } else {
        _currentFigureIndex = 0; // Start user input from the first matrix
        _state = ColoredFiguresGameState.userInput;
      }
    } else if (_state == ColoredFiguresGameState.userInput) {
      if (_currentFigureIndex < userFigures.length - 1) {
        _currentFigureIndex++;
      } else {
        _state = ColoredFiguresGameState.results;
      }
    }
  }

  void previousFigure() {
    if (_state != ColoredFiguresGameState.userInput) {
      return;
    }
    if (_currentFigureIndex > 0) {
      _currentFigureIndex--;
    }
  }

  /// Calculates the total score for the game session.
  ///
  /// Score is the sum of correctly remembered figures across all sequences.
  ///
  /// TODO: This score increase based on a table, the faster you show up every
  /// figure more points you get per figure
  int calculateScore() {
    int score = 0;
    final int totalSequences = gameFigures.length;
    const int pointsPerFigure = 10;

    // Iterate through each pair of target and user sequences
    for (int i = 0; i < totalSequences; i++) {
      final List<ColoredFigure> target = gameFigures;
      final List<ColoredFigure?> user = userFigures;

      // Compare each figure in the sequence
      for (int j = 0; j < target.length; j++) {
        if (j < user.length && target[j] == user[j]) {
          score += pointsPerFigure;
        }
      }
    }

    return score;
  }

  /// Gets the list of generated target sequences.
  /// This should generally only be used for displaying results.
  List<ColoredFigure> get generatedSequences => gameFigures;

  /// Gets the list of sequences input by the user.
  /// This should generally only be used for displaying results.
  List<ColoredFigure?> get userSequences => userFigures;
}

