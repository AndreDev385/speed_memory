import 'package:flutter/material.dart';
import 'package:speed_memory/modules/colored_figures/colored_figures_game_manager.dart';
import 'package:speed_memory/modules/colored_figures/components/colored_figure_widget.dart';
import 'package:speed_memory/modules/colored_figures/models/colored_figure.dart';
import 'package:speed_memory/screens/colored_figures/colored_figures_screen.dart';

/// A screen to display the results of the colored figures game.
/// Shows user figures and target figures, indicating correct matches and errors.
class ResultsScreen extends StatelessWidget {
  final ColoredFiguresGameManager gameManager;

  const ResultsScreen({super.key, required this.gameManager});

  @override
  Widget build(BuildContext context) {
    final int numberOfFigures = gameManager.config.numberOfFigures;
    final List<ColoredFigure?> userFigures = gameManager.userSequences;
    final List<ColoredFigure> targetFigures = gameManager.generatedSequences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
            // Scrollable list of figure comparisons
            Expanded(
              child: ListView.builder(
                itemCount: numberOfFigures,
                itemBuilder: (context, figureIndex) {
                  final ColoredFigure? userFigure = userFigures[figureIndex];
                  final ColoredFigure targetFigure = targetFigures[figureIndex];

                  return _buildFigureComparisonRow(
                    context,
                    figureIndex + 1, // 1-based index for display
                    userFigure,
                    targetFigure,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Back to main menu button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the ColoredFiguresScreen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ColoredFiguresScreen()),
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

  /// Builds a single row comparing a user figure to a target figure.
  Widget _buildFigureComparisonRow(
    BuildContext context,
    int figureNumber,
    ColoredFigure? userFigure,
    ColoredFigure targetFigure,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Figure number
            Text(
              'Figura $figureNumber',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            // Figures side-by-side
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // User Figure Label and Figure
                Expanded(
                  child: Column(
                    children: [
                      const Text('Tu Respuesta'),
                      const SizedBox(height: 5),
                      _buildFigureWithIndicator(userFigure, targetFigure, true),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Target Figure Label and Figure
                Expanded(
                  child: Column(
                    children: [
                      const Text('Respuesta Correcta'),
                      const SizedBox(height: 5),
                      _buildFigureWithIndicator(targetFigure, targetFigure, false),
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

  /// Builds a figure with an indicator for correct/incorrect matches.
  Widget _buildFigureWithIndicator(
    ColoredFigure? figure,
    ColoredFigure targetFigure,
    bool isUserFigure,
  ) {
    final bool isCorrect = figure == targetFigure;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Figure widget
        SizedBox(
          width: 80,
          height: 80,
          child: ColoredFigureWidget(
            figure: figure,
            size: 80,
          ),
        ),
        const SizedBox(width: 10),
        // Correctness indicator (only for user figure)
        if (isUserFigure) ...[
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
            size: 30,
          ),
        ],
      ],
    );
  }
}
