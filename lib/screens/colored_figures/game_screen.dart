import 'dart:async';
import 'package:flutter/material.dart';
import '../../modules/colored_figures/colored_figures_game_manager.dart';
import '../../modules/colored_figures/components/colored_figure_widget.dart';
import '../../modules/colored_figures/models/colored_figure.dart';
import 'user_input_screen.dart';

/// A screen that manages the flow of the colored figures game.
/// It shows the target figures, handles the timing, and transitions
/// to the user input phase.
class ColoredFiguresGameScreen extends StatefulWidget {
  final ColoredFiguresGameManager gameManager;

  const ColoredFiguresGameScreen({super.key, required this.gameManager});

  @override
  State<ColoredFiguresGameScreen> createState() =>
      _ColoredFiguresGameScreenState();
}

class _ColoredFiguresGameScreenState extends State<ColoredFiguresGameScreen> {
  late ColoredFiguresGameManager _gameManager;
  late StreamController<ColoredFiguresGameState> _gameStateStreamController;

  late Timer _displayTimer;
  late Timer _blankTimer;

  @override
  void initState() {
    super.initState();
    _gameManager = widget.gameManager;
    _gameStateStreamController =
        StreamController<ColoredFiguresGameState>.broadcast();

    // Defer the start of the game flow until after the first frame,
    // ensuring the widgets are properly attached.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGameFlow();
    });
  }

  /// Starts the sequence of showing figures.
  Future<void> _startGameFlow() async {
    // Ensure we start from the first figure
    // _gameManager state should already be 'showingFigures' and index 0 from startGame()
    // but let's be safe.
    // _gameManager.currentFigureIndex should be 0

    // Show the first figure immediately
    _gameStateStreamController.add(ColoredFiguresGameState.showingFigures);
    
    // Start the display timer for the first figure
    _displayTimer = Timer(
        Duration(milliseconds: (_gameManager.config.showTime * 1000).toInt()),
        _onDisplayTimeEnd);
  }

  /// Called when the display time for a figure ends.
  void _onDisplayTimeEnd() {
    _gameStateStreamController.add(ColoredFiguresGameState.initial); // Using initial as "blank" state
    // Start the blank time timer
    _blankTimer = Timer(
        Duration(milliseconds: (_gameManager.config.blankTime * 1000).toInt()),
        _onBlankTimeEnd);
  }

  /// Called when the blank time ends.
  void _onBlankTimeEnd() {
    // Move to the next figure index by calling the game manager's method
    _gameManager.nextFigure();

    // Check the game manager's state to determine next action
    if (_gameManager.state == ColoredFiguresGameState.showingFigures) {
      // Show the next figure
      _gameStateStreamController.add(ColoredFiguresGameState.showingFigures);
      
      // Restart the display timer for the next figure
      _displayTimer = Timer(
          Duration(milliseconds: (_gameManager.config.showTime * 1000).toInt()),
          _onDisplayTimeEnd);
    } else if (_gameManager.state == ColoredFiguresGameState.userInput) {
      // All figures have been shown, transition to user input phase
      _gameStateStreamController.add(ColoredFiguresGameState.userInput);
      // Navigate to the UserInputScreen, passing the game manager
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserInputScreen(gameManager: _gameManager),
        ),
      );
    }
    // If state is 'results', it means nextFigure was called erroneously, we should be in userInput by now.
  }

  @override
  void dispose() {
    _displayTimer.cancel();
    _blankTimer.cancel();
    _gameStateStreamController.close();
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
      body: StreamBuilder<ColoredFiguresGameState>(
        stream: _gameStateStreamController.stream,
        initialData: ColoredFiguresGameState.showingFigures,
        builder: (context, snapshot) {
          final gameState = snapshot.data ?? ColoredFiguresGameState.showingFigures;

          switch (gameState) {
            case ColoredFiguresGameState.showingFigures:
              return _buildFigureDisplay();
            case ColoredFiguresGameState.initial: // Using initial as "blank" state
              return _buildBlankScreen();
            case ColoredFiguresGameState.userInput:
              // This state transition should navigate away, so a simple container is fine
              return const Center(
                  child: Text("Cargando entrada del usuario..."));
            case ColoredFiguresGameState.results:
              // This shouldn't happen in this screen
              return const Center(
                  child: Text("Error: Estado de resultados inesperado."));
          }
        },
      ),
    );
  }

  /// Builds the screen showing the current target figure.
  Widget _buildFigureDisplay() {
    // Get the current figure to display from the game manager
    final currentFigure = _gameManager.currentFigureToShow;
    if (currentFigure == null) {
      // This should not happen in 'showingFigures' state, but handle gracefully
      return const Center(
          child: Text("Error: No se pudo obtener la figura a mostrar."));
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the figure
          _buildFigureWidget(currentFigure),
          const SizedBox(height: 20),
          // Show figure counter
          Text(
            'Figura ${_gameManager.currentFigureIndex + 1} de ${_gameManager.config.numberOfFigures}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  /// Builds the blank screen.
  Widget _buildBlankScreen() {
    // Return an empty container instead of the "Blanco" text
    return const SizedBox.shrink();
  }

  /// Builds a visual representation of a figure.
  Widget _buildFigureWidget(ColoredFigure figure) {
    // Determine the size for the figure based on screen dimensions
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth =
            constraints.maxWidth > 0 ? constraints.maxWidth * 0.6 : 200.0;
        final maxHeight =
            constraints.maxHeight > 0 ? constraints.maxHeight * 0.4 : 200.0;

        final double size = maxWidth < maxHeight ? maxWidth : maxHeight;

        return Center(
          child: ColoredFigureWidget(
            figure: figure,
            size: size.clamp(100.0, 300.0),
          ),
        );
      },
    );
  }
}