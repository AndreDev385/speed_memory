import 'package:flutter/material.dart';
import 'results_screen.dart';
import '../../modules/matrix/matrix_game_manager.dart';
import '../../modules/matrix/components/matrix_widget.dart';
import '../../modules/matrix/components/matrix_answer_preview_widget.dart';
import '../../shared/theme/dimensions.dart';

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
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _gameManager = widget.gameManager;
    _currentPageIndex = _gameManager.currentMatrixIndex;
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  void _onNextPressed() {
    _gameManager.nextMatrix();

    if (_gameManager.state == MatrixGameState.userInput) {
      final nextIndex = _currentPageIndex + 1;
      if (nextIndex < _gameManager.config.numberOfMatrices) {
        setState(() {
          _currentPageIndex = nextIndex;
        });
        _pageController.nextPage(
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
        _gameManager.goToUserMatrixIndex(nextIndex);
      }
    } else if (_gameManager.state == MatrixGameState.results) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultsScreen(gameManager: _gameManager),
        ),
      );
    }
  }

  void _onPreviewItemTapped(int index) {
    if (index != _currentPageIndex) {
      setState(() {
        _currentPageIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
      _gameManager.goToUserMatrixIndex(index);
    }
  }

  void _onPreviousPressed() {
    _gameManager.previousMatrix();

    final prevIndex = _currentPageIndex - 1;
    if (prevIndex >= 0) {
      setState(() {
        _currentPageIndex = prevIndex;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
      _gameManager.goToUserMatrixIndex(prevIndex);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFirst = _currentPageIndex == 0;
    final bool isLast =
        _currentPageIndex == _gameManager.config.numberOfMatrices - 1;
    final String nextButtonLabel = isLast ? 'Completar' : 'Siguiente';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrices'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            height: AppDimensions.previewSectionHeight,
            padding: const EdgeInsets.all(AppDimensions.previewContainerPadding),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _gameManager.userMatrices.length,
                  (index) => MatrixAnswerPreviewWidget(
                    matrix: _gameManager.userMatrices[index],
                    index: index,
                    isCurrent: index == _currentPageIndex,
                    onTap: () => _onPreviewItemTapped(index),
                  ),
                ),
              ),
            ),
          ),
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
                  child: MatrixWidget(
                    initialMatrix: _gameManager.userMatrices[index],
                    isEditable: true,
                    onMatrixChanged: (newMatrix) {
                      _gameManager.updateCurrentUserInputMatrix(newMatrix);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: AppDimensions.buttonHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: AppDimensions.maxWidthConstraint / 2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingHorizontalButtons),
                      child: ElevatedButton(
                        onPressed: isFirst ? null : _onPreviousPressed,
                        child: const Text('Anterior'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: AppDimensions.maxWidthConstraint / 2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingHorizontalButtons),
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

