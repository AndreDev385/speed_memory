import 'dart:async';
import 'package:flutter/material.dart';
// Import the game manager from its correct location
import '../../modules/matrix/matrix_game_manager.dart';
// Import Matrix model
import '../../modules/matrix/models/matrix.dart';
// Import Square model for Active type
import '../../modules/matrix/models/square.dart';
import 'user_input_screen.dart'; // Import the user input screen

/// A screen that manages the flow of the matrix game.
/// It shows the target matrices, handles the timing, and transitions
/// to the user input phase.
class GameScreen extends StatefulWidget {
  final MatrixGameManager gameManager;

  const GameScreen({super.key, required this.gameManager});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late MatrixGameManager _gameManager;
  late PageController _pageController;
  late StreamController<int> _countdownStreamController;
  late StreamController<GameState> _gameStateStreamController;

  late Timer _displayTimer;
  late Timer _blankTimer;

  @override
  void initState() {
    super.initState();
    _gameManager = widget.gameManager;
    _pageController = PageController();
    _countdownStreamController = StreamController<int>.broadcast();
    _gameStateStreamController = StreamController<GameState>.broadcast();

    // Defer the start of the game flow until after the first frame,
    // ensuring the PageView and PageController are properly attached.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGameFlow();
    });
  }

  /// Starts the sequence of showing matrices.
  Future<void> _startGameFlow() async {
    // Ensure we start from the first matrix
    // _gameManager state should already be 'showingMatrices' and index 0 from startGame()
    // but let's be safe.
    // _gameManager.currentMatrixIndex should be 0

    // Show the first matrix immediately
    _gameStateStreamController.add(GameState.displaying);
    _pageController.jumpToPage(_gameManager.currentMatrixIndex);

    // Start the display timer for the first matrix
    _displayTimer = Timer(
        Duration(milliseconds: (_gameManager.config.showTime * 1000).toInt()),
        _onDisplayTimeEnd);
  }

  /// Called when the display time for a matrix ends.
  void _onDisplayTimeEnd() {
    _gameStateStreamController.add(GameState.blank);
    // Start the blank time timer
    _blankTimer = Timer(
        Duration(milliseconds: (_gameManager.config.blankTime * 1000).toInt()),
        _onBlankTimeEnd);
  }

  /// Called when the blank time ends.
  void _onBlankTimeEnd() {
    // Move to the next matrix index by calling the game manager's method
    _gameManager.nextMatrix();

    // Check the game manager's state to determine next action
    if (_gameManager.state == MatrixGameState.showingMatrices) {
      // Show the next matrix
      _gameStateStreamController.add(GameState.displaying);
      // Safety check: ensure the PageController is still attached before using it
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_gameManager.currentMatrixIndex);
      }

      // Restart the display timer for the next matrix
      _displayTimer = Timer(
          Duration(milliseconds: (_gameManager.config.showTime * 1000).toInt()),
          _onDisplayTimeEnd);
    } else if (_gameManager.state == MatrixGameState.userInput) {
      // All matrices have been shown, transition to user input phase
      _gameStateStreamController.add(GameState.userInput);
      // Navigate to the UserInputScreen, passing the game manager
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserInputScreen(gameManager: _gameManager),
        ),
      );
    }
    // If state is 'results', it means nextMatrix was called erroneously, we should be in userInput by now.
  }

  @override
  void dispose() {
    _displayTimer.cancel();
    _blankTimer.cancel();
    _countdownStreamController.close();
    _gameStateStreamController.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memoriza'),
        centerTitle: true,
        // Disable back button
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<GameState>(
        stream: _gameStateStreamController.stream,
        initialData: GameState.displaying,
        builder: (context, snapshot) {
          final gameState = snapshot.data ?? GameState.displaying;

          switch (gameState) {
            case GameState.displaying:
              return _buildMatrixDisplay();
            case GameState.blank:
              return _buildBlankScreen();
            case GameState.userInput:
              // This state transition should navigate away, so a simple container is fine
              return const Center(
                  child: Text("Cargando entrada del usuario..."));
          }
        },
      ),
    );
  }

  /// Builds the screen showing the current target matrix.
  Widget _buildMatrixDisplay() {
    // Get the current matrix to display from the game manager
    final currentMatrix = _gameManager.currentMatrixToShow;
    if (currentMatrix == null) {
      // This should not happen in 'displaying' state, but handle gracefully
      return const Center(
          child: Text("Error: No se pudo obtener la matriz a mostrar."));
    }

    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Prevent manual swiping
      itemCount: _gameManager.config.numberOfMatrices,
      itemBuilder: (context, index) {
        // For PageView.builder, we only build the page that is currently visible.
        // However, since we jumpToPage and don't allow swiping, we can assume
        // the 'currentMatrix' is the one for the current index.
        // We still use the index to ensure the PageView knows which page it's on.
        // The actual matrix data comes from _gameManager.currentMatrixToShow for simplicity,
        // assuming it's correctly synced with _gameManager.currentMatrixIndex.
        // A more robust way would be to use targetMatrices[index] directly here.
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the matrix for the current page
              _buildMatrixGrid(
                currentMatrix,
              ), // Use the matrix from the game manager
              const SizedBox(height: 20),
              // Countdown timer indicator (simplified)
            ],
          ),
        );
      },
    );
  }

  /// Builds the blank screen.
  Widget _buildBlankScreen() {
    // Return an empty container instead of the "Blanco" text
    return const SizedBox.shrink();
    // Or alternatively: return Container();
  }

  /// Builds a visual representation of a matrix.
  /// This is a simplified version and might be replaced by a dedicated widget later.
  Widget _buildMatrixGrid(Matrix matrix) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth =
            constraints.maxWidth > 0 ? constraints.maxWidth * 0.8 : 300.0;
        final maxHeight =
            constraints.maxHeight > 0 ? constraints.maxHeight * 0.6 : 300.0;

        final double cellSize = (maxWidth / matrix.columns).clamp(15.0, 100.0);
        final double calculatedHeightCellSize =
            (maxHeight / matrix.rows).clamp(15.0, 100.0);
        final double finalCellSize = cellSize < calculatedHeightCellSize
            ? cellSize
            : calculatedHeightCellSize;

        final double borderWidth = finalCellSize * 0.03;

        // Determine cell color based on Square state
        Color getCellColor(Square square) {
          if (square is Active) {
            // Use Tailwind's blue-800 for active squares
            return const Color(0xFF1e40af);
          } else {
            // Inactive squares are usually white
            return Colors.white;
          }
        }

        // Build the grid of cells
        List<Widget> buildRows() {
          return List.generate(matrix.rows, (y) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(matrix.columns, (x) {
                final square = matrix.get(x, y);
                final color = getCellColor(square);

                return Container(
                  width: finalCellSize,
                  height: finalCellSize,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey,
                        width: borderWidth,
                      ),
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: borderWidth,
                      ),
                    ),
                  ),
                );
              }),
            );
          });
        }

        return Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: borderWidth,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: buildRows(),
            ),
          ),
        );
      },
    );
  }
}

/// Enum to represent the different states of the game flow.
enum GameState { displaying, blank, userInput }
