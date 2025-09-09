import 'package:flutter/material.dart';
import '../models/matrix.dart';
import 'matrix_widget.dart';
import '../../../shared/theme/dimensions.dart';

/// A widget that displays a small preview of a user's matrix answer with index number.
/// This is used in the horizontal scrollable preview section.
class MatrixAnswerPreviewWidget extends StatelessWidget {
  /// The matrix to display as preview.
  final Matrix matrix;
  
  /// The index number to display above the matrix (1-based).
  final int index;
  
  /// Whether this preview item is currently being edited.
  final bool isCurrent;
  
  /// Callback when the preview item is tapped.
  final VoidCallback? onTap;

  const MatrixAnswerPreviewWidget({
    super.key,
    required this.matrix,
    required this.index,
    this.isCurrent = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.previewItemSize,
        margin: const EdgeInsets.only(right: AppDimensions.previewSpacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Index number
            Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: AppDimensions.previewIndexFontSize,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCurrent ? Theme.of(context).primaryColor : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            // Matrix preview
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isCurrent 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey[400]!,
                    width: isCurrent ? 2.0 : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  color: isCurrent 
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : null,
                ),
                child: MatrixWidget(
                  initialMatrix: matrix,
                  isEditable: false,
                  showAsCorrect: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
