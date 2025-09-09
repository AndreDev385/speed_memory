import 'models/colored_figures_config.dart';
import 'models/colored_figure.dart';

enum ColoredFiguresGameState {
  initial,
  showingFigures,
  userInput,
  results,
}

class ColoredFiguresGameManager {
  final ColoredFiguresConfig config;
  final List<ColoredFigure> gameFigures;
  final List<ColoredFigure?> userFigures;

  /// The current state of the game.
  ColoredFiguresGameState _state = ColoredFiguresGameState.initial;
  ColoredFiguresGameState get state => _state;

  int _currentFigureIndex = 0;
  int get currentFigureIndex => _currentFigureIndex;

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

  void startGame() {
    if (_state != ColoredFiguresGameState.initial) {
      return;
    }
    _state = ColoredFiguresGameState.showingFigures;
    _currentFigureIndex = 0;
  }

  ColoredFigure? get currentFigureToShow {
    if (_state == ColoredFiguresGameState.showingFigures &&
        _currentFigureIndex >= 0 &&
        _currentFigureIndex < gameFigures.length) {
      return gameFigures[_currentFigureIndex];
    }
    return null;
  }

void nextFigure() {
    if (_state == ColoredFiguresGameState.showingFigures) {
      if (_currentFigureIndex < userFigures.length - 1) {
        _currentFigureIndex++;
      } else {
        _currentFigureIndex = 0;
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

void goToUserFigureIndex(int index) {
    if (_state != ColoredFiguresGameState.userInput) {
      return;
    }
    if (index >= 0 && index < config.numberOfFigures) {
      _currentFigureIndex = index;
    }
  }

int calculateScore() {
    int score = 0;
    final int totalSequences = gameFigures.length;
    const int pointsPerFigure = 10;

    for (int i = 0; i < totalSequences; i++) {
      final List<ColoredFigure> target = gameFigures;
      final List<ColoredFigure?> user = userFigures;

      for (int j = 0; j < target.length; j++) {
        if (j < user.length && target[j] == user[j]) {
          score += pointsPerFigure;
        }
      }
    }

    return score;
  }

List<ColoredFigure> get generatedSequences => gameFigures;

  List<ColoredFigure?> get userSequences => userFigures;
}

