import 'package:flutter/material.dart';
import 'package:speed_memory/shared/theme/dimensions.dart';
import '../models/colored_figure.dart';
import '../models/figure_color.dart';
import 'colored_figure_widget.dart';

/// A widget that displays a placeholder for a colored figure and allows the user
/// to select a figure type and color.
/// This widget is completely stateless and relies on props for its state.
class FigureSelector extends StatelessWidget {
  final ValueChanged<ColoredFigure?> onFigureSelected;
  final ColoredFigure? selectedFigure;

  const FigureSelector({
    super.key,
    required this.onFigureSelected,
    this.selectedFigure,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Placeholder for the selected figure
        Center(
          child: Container(
            color: Colors.white, // White background
            child: Center(
              // Mostrar la figura seleccionada o un placeholder si no hay figura
              child: selectedFigure != null
                  ? ColoredFigureWidget(
                      figure: selectedFigure,
                      size: 300,
                    )
                  : Container(
                      height: 300,
                      width: 300,
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          'Sin figura',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Figure type selection
        const Text('Seleccione una figura:'),
        const SizedBox(height: 10),
        Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxWidthConstraint,
              maxHeight: 60,
            ),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                _buildFigureTypeChip(Circle, selectedFigure),
                _buildFigureTypeChip(Square, selectedFigure),
                _buildFigureTypeChip(Triangle, selectedFigure),
                _buildFigureTypeChip(Pentagon, selectedFigure),
                _buildFigureTypeChip(Hexagon, selectedFigure),
                _buildFigureTypeChip(Heptagon, selectedFigure),
                _buildFigureTypeChip(Rectangle, selectedFigure),
                _buildFigureTypeChip(Star, selectedFigure),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Color selection
        const Text('Seleccione un color:'),
        const SizedBox(height: 10),
        Center(
          child: Container(
            height: 40,
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxWidthConstraint,
            ),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: FigureColor.values.map((color) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      // Si ya hay una figura seleccionada, actualizar su color
                      if (selectedFigure != null) {
                        ColoredFigure newFigure;
                        if (selectedFigure is Circle) {
                          newFigure = Circle(color);
                        } else if (selectedFigure is Square) {
                          newFigure = Square(color);
                        } else if (selectedFigure is Triangle) {
                          newFigure = Triangle(color);
                        } else if (selectedFigure is Pentagon) {
                          newFigure = Pentagon(color);
                        } else if (selectedFigure is Hexagon) {
                          newFigure = Hexagon(color);
                        } else if (selectedFigure is Heptagon) {
                          newFigure = Heptagon(color);
                        } else if (selectedFigure is Rectangle) {
                          newFigure = Rectangle(color);
                        } else if (selectedFigure is Star) {
                          newFigure = Star(color);
                        } else {
                          // Default to circle if unknown type
                          newFigure = Circle(color);
                        }
                        onFigureSelected(newFigure);
                      } else {
                        // Si no hay figura seleccionada, crear un círculo con el color seleccionado
                        onFigureSelected(Circle(color));
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: _getChipBackgroundColor(color),
                          border: selectedFigure?.color == color
                              ? Border.all(color: Colors.blue, width: 2)
                              : Border.all(color: Colors.black, width: 2)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a choice chip for a figure type.
  Widget _buildFigureTypeChip(Type figureType, ColoredFigure? selectedFigure) {
    // Create a figure with the selected color or default to white
    FigureColor color = selectedFigure?.color ?? FigureColor.white;
    ColoredFigure figure = _createFigure(figureType, color);

    return GestureDetector(
      onTap: () {
        // Si ya hay un color seleccionado, crear la figura con ese color
        // Si no, usar el color por defecto (blanco)
        ColoredFigure newFigure;
        if (selectedFigure != null) {
          newFigure = _createFigure(figureType, selectedFigure.color);
        } else {
          newFigure = _createFigure(figureType, FigureColor.white);
        }
        onFigureSelected(newFigure);
      },
      child: Container(
        decoration: BoxDecoration(
          border: selectedFigure?.runtimeType == figureType
              ? Border.all(color: Colors.blue, width: 3)
              : null,
        ),
        child: Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: ColoredFigureWidget(
              figure: figure,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a figure based on the figure type and color
  ColoredFigure _createFigure(Type figureType, FigureColor color) {
    if (figureType == Circle) {
      return Circle(color);
    } else if (figureType == Square) {
      return Square(color);
    } else if (figureType == Triangle) {
      return Triangle(color);
    } else if (figureType == Pentagon) {
      return Pentagon(color);
    } else if (figureType == Hexagon) {
      return Hexagon(color);
    } else if (figureType == Heptagon) {
      return Heptagon(color);
    } else if (figureType == Rectangle) {
      return Rectangle(color);
    } else if (figureType == Star) {
      return Star(color);
    } else {
      // Default to circle if unknown type
      return Circle(color);
    }
  }

  /// Converts a FigureColor to a Flutter Color.
  Color _getChipBackgroundColor(FigureColor color) {
    switch (color) {
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
}
