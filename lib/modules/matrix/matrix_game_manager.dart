import 'models/matrix_config.dart';
import 'models/matrix.dart';

/// Enum to represent the different states of the Matrix game.
enum MatrixGameState {
  /// Initial state, waiting for the game to start.
  initial,

  /// Showing matrices to the user.
  showingMatrices,

  /// Waiting for the user to input their answers.
  userInput,

  /// Showing the results of the game.
  results,
}

/// Manages the state and logic for the Matrix memory game.
/// It holds the configuration, generates the target matrices,
/// tracks the user's input, and calculates the final score.
class MatrixGameManager {
  /// The configuration for the game, containing rows, columns, timings, etc.
  final MatrixConfig config;

  /// The list of target matrices that the user needs to memorize.
  /// These are generated randomly at the start of the game based on config.
  final List<Matrix> targetMatrices;

  /// The list of matrices representing the user's input.
  /// Initially filled with empty matrices matching the target dimensions.
  final List<Matrix> userInputMatrices;

  /// The current state of the game.
  MatrixGameState _state = MatrixGameState.initial;
  MatrixGameState get state => _state;

  /// The index of the current matrix being displayed or edited (0-based).
  int _currentMatrixIndex = 0;
  int get currentMatrixIndex => _currentMatrixIndex;

  /// Creates a new MatrixGameManager with the given configuration.
  ///
  /// Initializes the target matrices (randomly generated) and user input matrices (empty).
  MatrixGameManager({required this.config})
      : targetMatrices = List.generate(
          config.numberOfMatrices,
          (index) =>
              Matrix.random(config.columns, config.rows), // Use Matrix.random
        ),
        userInputMatrices = List.generate(
          config.numberOfMatrices,
          (index) =>
              Matrix(config.columns, config.rows), // Start with empty matrices
        );

  /// Starts the game by transitioning to the 'showingMatrices' state.
  void startGame() {
    if (_state != MatrixGameState.initial) {
      // Prevent starting if already started or finished
      return;
    }
    _state = MatrixGameState.showingMatrices;
    _currentMatrixIndex = 0; // Ensure we start from the first matrix
  }

  /// Gets the matrix that should currently be displayed to the user.
  Matrix? get currentMatrixToShow {
    if (_state == MatrixGameState.showingMatrices &&
        _currentMatrixIndex >= 0 &&
        _currentMatrixIndex < targetMatrices.length) {
      return targetMatrices[_currentMatrixIndex];
    }
    return null;
  }

  /// Gets the matrix that the user is currently inputting.
  Matrix get currentUserInputMatrix {
    // Ensure index is valid
    if (_currentMatrixIndex >= 0 &&
        _currentMatrixIndex < userInputMatrices.length) {
      return userInputMatrices[_currentMatrixIndex];
    }
    // Return an empty matrix of the correct size if index is somehow invalid
    // This is a safeguard, should not normally happen if navigation is correct.
    return Matrix(config.columns, config.rows);
  }

  /// Updates the user input matrix at the current index.
  /// This is called by the UI when the user interacts with the input matrix.
  void updateCurrentUserInputMatrix(Matrix newMatrix) {
    if (_state != MatrixGameState.userInput) {
      // Only allow updates during the user input phase
      return;
    }
    if (_currentMatrixIndex >= 0 &&
        _currentMatrixIndex < userInputMatrices.length) {
      userInputMatrices[_currentMatrixIndex] = newMatrix;
    }
  }

  /// Navigates to a specific matrix index during the user input phase.
  /// This allows the user to jump between matrices using the thumbnail list.
  void goToUserMatrixIndex(int index) {
    if (_state != MatrixGameState.userInput) {
      return;
    }
    if (index >= 0 && index < config.numberOfMatrices) {
      _currentMatrixIndex = index;
    }
  }

  /// Advances to the next matrix in the sequence.
  ///
  /// If called during 'showingMatrices', it moves to the next target matrix
  /// or transitions to 'userInput' if all target matrices have been shown.
  ///
  /// If called during 'userInput', it moves to the next user input matrix
  /// or transitions to 'results' if all user matrices have been filled.
  void nextMatrix() {
    if (_state == MatrixGameState.showingMatrices) {
      if (_currentMatrixIndex < targetMatrices.length - 1) {
        _currentMatrixIndex++;
      } else {
        // All target matrices shown, move to user input phase
        _currentMatrixIndex = 0; // Start user input from the first matrix
        _state = MatrixGameState.userInput;
      }
    } else if (_state == MatrixGameState.userInput) {
      if (_currentMatrixIndex < userInputMatrices.length - 1) {
        _currentMatrixIndex++;
      } else {
        // All user matrices filled, move to results
        _state = MatrixGameState.results;
      }
    }
  }

  /// Goes back to the previous matrix in the sequence during the user input phase.
  void previousMatrix() {
    if (_state != MatrixGameState.userInput) {
      return;
    }
    if (_currentMatrixIndex > 0) {
      _currentMatrixIndex--;
    }
  }

  /// Calculates the total score for the game session.
  ///
  /// Score is the sum of correctly remembered squares across all matrices.
  int calculateScore() {
    int score = 0;
    final int totalMatrices = targetMatrices.length;
    const int pointsPerSquare = 10;

    // Iterate through each pair of target and user matrices
    for (int i = 0; i < totalMatrices; i++) {
      final Matrix target = targetMatrices[i];
      final Matrix user = userInputMatrices[i];

      if (target == user) {
        score += target.columns * target.rows * pointsPerSquare;
      }
    }

    return score;
  }

  /// Gets the list of generated target matrices.
  /// This should generally only be used for displaying results or thumbnails.
  List<Matrix> get generatedMatrices => targetMatrices;

  /// Gets the list of matrices input by the user.
  /// This should generally only be used for displaying results or thumbnails.
  List<Matrix> get userMatrices => userInputMatrices;
}

