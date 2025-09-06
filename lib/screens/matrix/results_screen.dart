import 'package:flutter/material.dart';
import 'package:speed_memory/screens/matrix/matrix_screen.dart';
import '../../modules/matrix/matrix_game_manager.dart';
import '../../modules/matrix/models/matrix.dart';
// Assuming MatrixWidget is in this path, adjust if necessary
import '../../modules/matrix/components/matrix_widget.dart';
import '../../shared/theme/dimensions.dart'; // Importar las dimensiones

/// A screen to display the results of the matrix game.
/// Shows user matrices on the left and target matrices on the right,
/// indicating correct matches and errors.
class ResultsScreen extends StatelessWidget {
  final MatrixGameManager gameManager;

  const ResultsScreen({super.key, required this.gameManager});

  @override
  Widget build(BuildContext context) {
    final int numberOfMatrices = gameManager.config.numberOfMatrices;
    final List<Matrix> userMatrices = gameManager.userMatrices;
    final List<Matrix> targetMatrices = gameManager.generatedMatrices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Final Score
            Text(
              'Puntaje Final: ${gameManager.calculateScore()}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppDimensions.spacingBetweenElements),
            // Scrollable list of matrix comparisons
            Expanded(
              child: ListView.builder(
                itemCount: numberOfMatrices,
                itemBuilder: (context, index) {
                  final Matrix userMatrix = userMatrices[index];
                  final Matrix targetMatrix = targetMatrices[index];
                  // Simple comparison: matrices are equal if all squares match
                  final bool isCorrect = userMatrix == targetMatrix;

                  return _buildMatrixComparisonRow(
                    context,
                    index + 1, // 1-based index for display
                    userMatrix,
                    targetMatrix,
                    isCorrect,
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimensions.spacingBetweenElements),
            // Back to main menu button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the MatrixScreen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MatrixScreen()),
                    (route) => route.isFirst,
                  );
                },
                child: const Text('Volver a jugar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single row comparing a user matrix to a target matrix.
  Widget _buildMatrixComparisonRow(
    BuildContext context,
    int matrixNumber,
    Matrix userMatrix,
    Matrix targetMatrix,
    bool isCorrect,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.marginVerticalCard),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Matrix number and result indicator
            Row(
              children: [
                Text(
                  'Matriz $matrixNumber',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
                const Spacer(),
                Text(
                  isCorrect ? 'Correcta' : 'Incorrecta',
                  style: TextStyle(
                    color: isCorrect ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            // Matrices side-by-side
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // User Matrix Label and Grid
                Expanded(
                  child: Column(
                    children: [
                      const Text('Tu Respuesta'),
                      const SizedBox(height: AppDimensions.paddingSmall / 2),
                      MatrixWidget(
                        initialMatrix: userMatrix,
                        isEditable: false,
                        showAsCorrect:
                            isCorrect, // Assuming MatrixWidget uses this
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingBetweenElements),
                // Target Matrix Label and Grid
                Expanded(
                  child: Column(
                    children: [
                      const Text('Respuesta Correcta'),
                      const SizedBox(height: AppDimensions.paddingSmall / 2),
                      MatrixWidget(
                        initialMatrix: targetMatrix,
                        isEditable: false,
                        showAsCorrect:
                            true, // Target is always shown as "correct"
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
