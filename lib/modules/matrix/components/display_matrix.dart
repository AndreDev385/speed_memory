import 'package:flutter/material.dart';
import '../models/matrix.dart'; // Adjust import path as needed
import '../models/square.dart'; // Adjust import path as needed

/// A widget to display a Matrix.
/// Can visually indicate if the matrix is part of a correct answer.
class DisplayMatrix extends StatelessWidget {
  final Matrix matrix;
  final bool showAsCorrect;

  const DisplayMatrix({
    super.key,
    required this.matrix,
    this.showAsCorrect = true, // Default to showing as correct
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing logic similar to InputMatrix
        final maxWidth = constraints.maxWidth > 0 ? constraints.maxWidth * 0.8 : 200.0;
        final maxHeight = constraints.maxHeight > 0 ? constraints.maxHeight * 0.8 : 200.0;

        final double cellSize = (maxWidth / matrix.columns).clamp(15.0, 50.0);
        final double calculatedHeightCellSize = (maxHeight / matrix.rows).clamp(15.0, 50.0);
        final double finalCellSize = cellSize < calculatedHeightCellSize ? cellSize : calculatedHeightCellSize;

        final double margin = finalCellSize * 0.05;
        final double borderWidth = finalCellSize * 0.03;

        // Determine cell color based on Square state and showAsCorrect flag
        Color getCellColor(Square square) {
          if (square is Active) {
            // If the matrix is shown as correct, use the standard active color.
            // If it's shown as incorrect, use the same active color for the cell itself
            // The main visual indicator of correctness will be the border color.
            return const Color(0xFF1e40af); // Tailwind's blue-800
          } else {
            // Inactive squares are usually white
            return Colors.white;
          }
        }

        // Determine border color based on showAsCorrect flag
        Color getBorderColor() {
          // Use red border if the matrix representation is for an incorrect answer
          return showAsCorrect ? Colors.grey : Colors.red;
        }

        return SizedBox(
          width: matrix.columns * (finalCellSize + 2 * margin),
          height: matrix.rows * (finalCellSize + 2 * margin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(matrix.rows, (y) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(matrix.columns, (x) {
                  final square = matrix.get(x, y);
                  final color = getCellColor(square);
                  final borderColor = getBorderColor();

                  return Container(
                    width: finalCellSize - 2 * margin,
                    height: finalCellSize - 2 * margin,
                    margin: EdgeInsets.all(margin),
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(color: borderColor, width: borderWidth),
                    ),
                  );
                }),
              );
            }),
          ),
        );
      },
    );
  }
}
