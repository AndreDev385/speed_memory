import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/colored_figure.dart';
import '../models/figure_color.dart';

/// A widget that displays a single colored figure.
class ColoredFigureWidget extends StatelessWidget {
  final ColoredFigure? figure;
  final double size;

  const ColoredFigureWidget({
    super.key,
    this.figure,
    this.size = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: figure != null
          ? CustomPaint(
              painter: _FigurePainter(figure!),
            )
          : Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(
                child: Text(
                  'Sin figura',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
    );
  }
}

/// A custom painter that draws the figure based on its type and color.
class _FigurePainter extends CustomPainter {
  final ColoredFigure figure;

  _FigurePainter(this.figure);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = _getColor(figure.color); // Use the figure's color for fill

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black // Always use black border
      ..strokeWidth = 2.0; // Slightly thinner border

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.7; // Make it a bit smaller to fit better

    // Draw the figure based on its type
    if (figure is Circle) {
      canvas.drawCircle(center, radius, paint);
      canvas.drawCircle(center, radius, borderPaint);
    } else if (figure is Triangle) {
      final path = Path()
        ..moveTo(center.dx, center.dy - radius)
        ..lineTo(center.dx - radius, center.dy + radius)
        ..lineTo(center.dx + radius, center.dy + radius)
        ..close();
      canvas.drawPath(path, paint);
      canvas.drawPath(path, borderPaint);
    } else if (figure is Square) {
      final rect = Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: radius * 2,
      );
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, borderPaint);
    }  else if (figure is Pentagon) {
      final path = _createPolygonPath(center, radius, 5);
      canvas.drawPath(path, paint);
      canvas.drawPath(path, borderPaint);
    } else if (figure is Hexagon) {
      final path = _createPolygonPath(center, radius, 6);
      canvas.drawPath(path, paint);
      canvas.drawPath(path, borderPaint);
    } else if (figure is Heptagon) {
      final path = _createPolygonPath(center, radius, 7);
      canvas.drawPath(path, paint);
      canvas.drawPath(path, borderPaint);
    } else if (figure is Rectangle) {
      // Rectangle with vertical longer sides
      final rect = Rect.fromCenter(
        center: center,
        width: radius * 1, // Wider rectangle
        height: radius * 2, // Taller rectangle
      );
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, borderPaint);
    } else if (figure is Star) {
      final path = _createStarPath(center, radius * 0.9); // Slightly larger star
      canvas.drawPath(path, paint);
      canvas.drawPath(path, borderPaint);
    }
  }

  /// Creates a path for a regular polygon with the specified number of sides.
  Path _createPolygonPath(Offset center, double radius, int sides) {
    final path = Path();
    final angle = (math.pi * 2) / sides;

    for (int i = 0; i < sides; i++) {
      final x = center.dx + radius * math.cos(angle * i - math.pi / 2);
      final y = center.dy + radius * math.sin(angle * i - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  /// Creates a path for a 5-pointed star.
  Path _createStarPath(Offset center, double radius) {
    final path = Path();
    final outerRadius = radius;
    final innerRadius = radius * 0.4;
    const angle = (math.pi * 2) / 10;

    for (int i = 0; i < 10; i++) {
      final r = i % 2 == 0 ? outerRadius : innerRadius;
      final x = center.dx + r * math.cos(angle * i - math.pi / 2);
      final y = center.dy + r * math.sin(angle * i - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  /// Converts a FigureColor to a Flutter Color.
  Color _getColor(FigureColor figureColor) {
    switch (figureColor) {
      case FigureColor.black:
        return Colors.black;
      case FigureColor.brown:
        return Colors.brown;
      case FigureColor.red:
        return Colors.red;
      case FigureColor.orange:
        return Colors.orange;
      case FigureColor.green:
        return Colors.green;
      case FigureColor.yellow:
        return Colors.yellow;
      case FigureColor.blue:
        return Colors.blue;
      case FigureColor.purple:
        return Colors.purple;
      case FigureColor.grey:
        return Colors.grey;
      case FigureColor.white:
        return Colors.white;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
