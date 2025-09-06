import 'package:speed_memory/modules/colored_figures/models/figure_color.dart';
import 'dart:math';

/// Represents a colored geometric figure.
/// This is an abstract base class for all specific figure types.
sealed class ColoredFigure {
  final FigureColor color;

  const ColoredFigure(this.color);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ColoredFigure && other.color == color;
  }

  @override
  int get hashCode => Object.hash(runtimeType, color);

  @override
  String toString() {
    return "$runtimeType $color";
  }
}

class Circle extends ColoredFigure {
  const Circle(super.color);
}

class Triangle extends ColoredFigure {
  const Triangle(super.color);
}

class Square extends ColoredFigure {
  const Square(super.color);
}

class Pentagon extends ColoredFigure {
  const Pentagon(super.color);
}

class Hexagon extends ColoredFigure {
  const Hexagon(super.color);
}

class Heptagon extends ColoredFigure {
  const Heptagon(super.color);
}

class Rectangle extends ColoredFigure {
  const Rectangle(super.color);
}

class Star extends ColoredFigure {
  const Star(super.color);
}

/// Creates a random colored figure.
/// Selects randomly from all classes that extend ColoredFigure
/// and all colors from the FigureColor enum.
ColoredFigure randomColoredFigure() {
  final random = Random();
  
  final figureCreators = [
    (FigureColor color) => Circle(color),
    (FigureColor color) => Triangle(color),
    (FigureColor color) => Square(color),
    (FigureColor color) => Pentagon(color),
    (FigureColor color) => Hexagon(color),
    (FigureColor color) => Heptagon(color),
    (FigureColor color) => Rectangle(color),
    (FigureColor color) => Star(color),
  ];
  
  const colors = FigureColor.values;
  
  final randomCreator = figureCreators[random.nextInt(figureCreators.length)];
  final randomColor = colors[random.nextInt(colors.length)];
  
  return randomCreator(randomColor);
}
