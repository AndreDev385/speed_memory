import 'package:flutter/material.dart';
import '../models/matrix.dart';
import '../models/square.dart';

/// A callback function type for when the matrix is changed.
typedef OnMatrixChangedCallback = void Function(Matrix newMatrix);

/// A widget that displays an editable matrix grid for user input.
/// Tapping on a square toggles its state between Active and Inactive.
/// The size of the squares is responsive to the available space and matrix dimensions.
class InputMatrix extends StatefulWidget {
  /// The initial matrix to display and edit.
  /// The widget manages its own copy internally.
  final Matrix initialMatrix;

  /// A callback that is called whenever the internal matrix state changes.
  final OnMatrixChangedCallback? onMatrixChanged;

  /// Creates an InputMatrix widget.
  const InputMatrix({super.key, required this.initialMatrix, this.onMatrixChanged});

  @override
  State<InputMatrix> createState() => _InputMatrixState();
}

class _InputMatrixState extends State<InputMatrix> {
  /// The matrix managed by this widget's state.
  late Matrix _matrix;

  @override
  void initState() {
    super.initState();
    // Create a copy of the initial matrix for internal state management.
    _matrix = widget.initialMatrix.copy();
  }

  @override
  void didUpdateWidget(covariant InputMatrix oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the initial matrix configuration has changed (rows or columns)
    // We compare dimensions as the identity of the Matrix object might change even with same dims
    if (widget.initialMatrix.rows != oldWidget.initialMatrix.rows ||
        widget.initialMatrix.columns != oldWidget.initialMatrix.columns) {
      // Update the internal state matrix to match the new initial configuration
      setState(() {
        _matrix = widget.initialMatrix.copy();
      });
    }
    // Check if the initial matrix content has changed (e.g., when navigating in UserInputScreen)
    // This comparison relies on the Matrix's == operator being correctly implemented.
    else if (widget.initialMatrix != oldWidget.initialMatrix) {
       // Update the internal state matrix to match the new initial content
       setState(() {
         _matrix = widget.initialMatrix.copy();
       });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate max available width and height for the grid
        // Subtract a small padding/margin to avoid edge-to-edge rendering
        final maxWidth = constraints.maxWidth > 0 ? constraints.maxWidth * 0.8 : 300.0;
        final maxHeight = constraints.maxHeight > 0 ? constraints.maxHeight * 0.6 : 300.0;

        // Calculate cell size based on matrix dimensions and available space
        // Ensure a minimum cell size for very small matrices or large screens
        final double cellSize = (maxWidth / widget.initialMatrix.columns)
            .clamp(20.0, 100.0); // Clamp between 20 and 100 pixels
        final double calculatedHeightCellSize = (maxHeight / widget.initialMatrix.rows)
            .clamp(20.0, 100.0);
        // Use the smaller of the two to ensure it fits both width and height
        final double finalCellSize = cellSize < calculatedHeightCellSize ? cellSize : calculatedHeightCellSize;

        // Margin and border width relative to cell size for better responsiveness
        final double margin = finalCellSize * 0.05; // 5% of cell size
        final double borderWidth = finalCellSize * 0.03; // 3% of cell size

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Shrink to fit content
            children: List.generate(_matrix.rows, (y) {
              return Row(
                mainAxisSize: MainAxisSize.min, // Shrink to fit content
                children: List.generate(_matrix.columns, (x) {
                  final square = _matrix.get(x, y);
                  // Use Tailwind's blue-800 for active squares
                  final color = square is Active ? const Color(0xFF1e40af) : Colors.white;

                  return GestureDetector(
                    onTap: () {
                      final newMatrix = _matrix.toggle(x, y);
                      setState(() {
                        // Toggle the square state in the internal matrix
                        _matrix = newMatrix;
                      });
                      // Notify parent widget of the change, if a callback was provided
                      widget.onMatrixChanged?.call(_matrix);
                    },
                    child: Container(
                      width: finalCellSize - 2 * margin,
                      height: finalCellSize - 2 * margin,
                      margin: EdgeInsets.all(margin),
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(color: Colors.grey, width: borderWidth),
                      ),
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