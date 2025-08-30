import 'package:flutter/material.dart';
// Import the ResultsScreen
import 'results_screen.dart'; 
import '../../modules/matrix/matrix_game_manager.dart';
import '../../modules/matrix/components/input_matrix.dart';

/// An updated minimal screen with proper button states and styles.
class UserInputScreen extends StatefulWidget {
  final MatrixGameManager gameManager;

  const UserInputScreen({super.key, required this.gameManager});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  late MatrixGameManager _gameManager;
  late PageController _pageController;
  // Keep track of the current page index locally for UI updates
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _gameManager = widget.gameManager;
    // Initialize the local page index
    _currentPageIndex = _gameManager.currentMatrixIndex;
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  void _onNextPressed() {
    // Let the game manager handle the core logic
    _gameManager.nextMatrix();

    if (_gameManager.state == MatrixGameState.userInput) {
      // Move to the next page in the UI
      final nextIndex = _currentPageIndex + 1;
      if (nextIndex < _gameManager.config.numberOfMatrices) {
        setState(() {
          _currentPageIndex = nextIndex;
        });
        _pageController.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.ease);
        // Sync game manager index after UI change
        _gameManager.goToUserMatrixIndex(nextIndex);
      }
    } else if (_gameManager.state == MatrixGameState.results) {
      // Navigate to the results screen when the game is finished
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultsScreen(gameManager: _gameManager),
        ),
      );
    }
  }

  void _onPreviousPressed() {
    // Let the game manager handle the core logic
    _gameManager.previousMatrix();

    // Move to the previous page in the UI
    final prevIndex = _currentPageIndex - 1;
    if (prevIndex >= 0) {
      setState(() {
         _currentPageIndex = prevIndex;
      });
      _pageController.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.ease);
      // Sync game manager index after UI change
      _gameManager.goToUserMatrixIndex(prevIndex);
    }
    // If prevIndex < 0, gameManager.previousMatrix() handles it internally (does nothing)
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine button states based on the LOCAL _currentPageIndex
    final bool isFirst = _currentPageIndex == 0;
    final bool isLast = _currentPageIndex == _gameManager.config.numberOfMatrices - 1;
    final String nextButtonLabel = isLast ? 'Completar' : 'Siguiente';

    return Scaffold(
      appBar: AppBar(title: const Text('Matrices')),
      body: Column(
        children: [
          // Main Input Area
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
                _gameManager.goToUserMatrixIndex(index);
              },
              itemCount: _gameManager.config.numberOfMatrices,
              itemBuilder: (context, index) {
                return Center(
                  child: InputMatrix(
                    initialMatrix: _gameManager.userMatrices[index],
                    onMatrixChanged: (newMatrix) {
                      _gameManager.updateCurrentUserInputMatrix(newMatrix);
                    },
                  ),
                );
              },
            ),
          ),
          // Fixed height for buttons
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous Button (ElevatedButton)
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200), // Max width
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: isFirst ? null : _onPreviousPressed,
                        child: const Text('Anterior'),
                      ),
                    ),
                  ),
                ),
                // Next/Complete Button (ElevatedButton)
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200), // Max width
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: _onNextPressed,
                        child: Text(nextButtonLabel),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}