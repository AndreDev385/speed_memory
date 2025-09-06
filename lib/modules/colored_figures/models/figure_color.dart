import 'package:flutter/material.dart';

enum FigureColor {
  black,
  brown,
  orange,
  red,
  green,
  yellow,
  blue,
  purple,
  grey,
  white,
}

figureColorToColor(FigureColor figureColor) {
  switch (figureColor) {
    case FigureColor.black:
      return Colors.black;
    case FigureColor.brown:
      return Colors.brown;
    case FigureColor.orange:
      return Colors.orange;
    case FigureColor.red:
      return Colors.red;
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
    default:
      return Colors.white;
  } 
}
