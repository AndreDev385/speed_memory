import 'package:flutter/material.dart';
import '../../modules/matrix/matrix_game_manager.dart';
import '../../modules/matrix/models/matrix.dart';
// Assuming DisplayMatrix is in this path, adjust if necessary
import '../../modules/matrix/components/display_matrix.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Final Score
            Text(
              'Puntaje Final: ${gameManager.calculateScore()}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            // Back to main menu button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Volver al Menú'),
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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
                const SizedBox(width: 10),
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
            const SizedBox(height: 10),
            // Matrices side-by-side
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // User Matrix Label and Grid
                Expanded(
                  child: Column(
                    children: [
                      const Text('Tu Respuesta'),
                      const SizedBox(height: 5),
                      DisplayMatrix(
                        matrix: userMatrix,
                        showAsCorrect: isCorrect, // Assuming DisplayMatrix uses this
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Target Matrix Label and Grid
                Expanded(
                  child: Column(
                    children: [
                      const Text('Respuesta Correcta'),
                      const SizedBox(height: 5),
                      DisplayMatrix(
                        matrix: targetMatrix,
                        showAsCorrect: true, // Target is always shown as "correct"
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
