import 'package:flutter/material.dart';
import '../models/matrix.dart';
import '../models/square.dart';

/// A callback function type for when the matrix is changed.
typedef OnMatrixChangedCallback = void Function(Matrix newMatrix);

/// A widget that displays a matrix grid that can be either editable or read-only.
/// When editable, tapping on a square toggles its state between Active and Inactive.
/// The size of the squares is responsive to the available space and matrix dimensions.
class MatrixWidget extends StatefulWidget {
  /// The initial matrix to display.
  /// The widget manages its own copy internally when editable.
  final Matrix initialMatrix;

  /// Whether the matrix is editable or read-only.
  final bool isEditable;

  /// A callback that is called whenever the internal matrix state changes.
  /// Only used when isEditable is true.
  final OnMatrixChangedCallback? onMatrixChanged;

  /// Whether to show the matrix as correct or incorrect.
  /// Only used when isEditable is false.
  final bool showAsCorrect;

  /// Creates a MatrixWidget.
  const MatrixWidget({
    super.key,
    required this.initialMatrix,
    this.isEditable = false,
    this.onMatrixChanged,
    this.showAsCorrect = true,
  });

  @override
  State<MatrixWidget> createState() => _MatrixWidgetState();
}

class _MatrixWidgetState extends State<MatrixWidget> {
  /// The matrix managed by this widget's state.
  /// Only used when isEditable is true.
  late Matrix _matrix;

  @override
  void initState() {
    super.initState();
    // Create a copy of the initial matrix for internal state management.
    _matrix = widget.initialMatrix.copy();
  }

  @override
  void didUpdateWidget(covariant MatrixWidget oldWidget) {
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
        final maxWidth =
            constraints.maxWidth > 0 ? constraints.maxWidth * 0.8 : 300.0;
        final maxHeight =
            constraints.maxHeight > 0 ? constraints.maxHeight * 0.6 : 300.0;

        // Calculate cell size based on matrix dimensions and available space
        // Ensure a minimum cell size for very small matrices or large screens
        final double cellSize = (maxWidth / widget.initialMatrix.columns)
            .clamp(15.0, 100.0); // Clamp between 15 and 100 pixels
        final double calculatedHeightCellSize =
            (maxHeight / widget.initialMatrix.rows).clamp(15.0, 100.0);
        // Use the smaller of the two to ensure it fits both width and height
        final double finalCellSize = cellSize < calculatedHeightCellSize
            ? cellSize
            : calculatedHeightCellSize;

        final double borderWidth = finalCellSize * 0.03; // 3% of cell size

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

        // Determine border color based on showAsCorrect flag
        // Only used when isEditable is false
        Color getBorderColor() {
          // Use red border if the matrix representation is for an incorrect answer
          return widget.showAsCorrect ? Colors.grey : Colors.red;
        }

        // Build the grid of cells
        List<Widget> buildRows() {
          return List.generate(widget.initialMatrix.rows, (y) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.initialMatrix.columns, (x) {
                final square = widget.isEditable ? _matrix.get(x, y) : widget.initialMatrix.get(x, y);
                final color = getCellColor(square);

                Widget cell = Container(
                  width: finalCellSize,
                  height: finalCellSize,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border(
                      right: BorderSide(
                        color: widget.isEditable ? Colors.grey : getBorderColor(),
                        width: borderWidth,
                      ),
                      bottom: BorderSide(
                        color: widget.isEditable ? Colors.grey : getBorderColor(),
                        width: borderWidth,
                      ),
                    ),
                  ),
                );

                // Add gesture detector for editable mode
                if (widget.isEditable) {
                  cell = GestureDetector(
                    onTap: () {
                      final newMatrix = _matrix.toggle(x, y);
                      setState(() {
                        _matrix = newMatrix;
                      });
                      widget.onMatrixChanged?.call(_matrix);
                    },
                    child: cell,
                  );
                }

                return cell;
              }),
            );
          });
        }

        return Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isEditable ? Colors.grey : getBorderColor(),
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
