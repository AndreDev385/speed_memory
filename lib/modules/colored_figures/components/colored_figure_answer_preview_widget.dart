import 'package:flutter/material.dart';
import '../models/colored_figure.dart';
import 'colored_figure_widget.dart';
import '../../../shared/theme/dimensions.dart';

/// A widget that displays a small preview of a user's colored figure answer with index number.
/// This is used in the horizontal scrollable preview section.
class ColoredFigureAnswerPreviewWidget extends StatelessWidget {
  /// The figure to display as preview (can be null for unanswered).
  final ColoredFigure? figure;

  /// The index number to display above the figure (1-based).
  final int index;

  /// Whether this preview item is currently being edited.
  final bool isCurrent;

  /// Callback when the preview item is tapped.
  final VoidCallback? onTap;

  const ColoredFigureAnswerPreviewWidget({
    super.key,
    required this.figure,
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
                color: isCurrent
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            // Figure preview
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
                child: figure != null
                    ? ColoredFigureWidget(
                        figure: figure,
                        size: AppDimensions.previewItemSize - 20,
                      )
                    : Center(
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

