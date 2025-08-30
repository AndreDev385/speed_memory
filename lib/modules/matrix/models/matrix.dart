import 'dart:math';
import 'square.dart';

/// Represents a 2D Matrix of Squares with a fixed number of columns and rows.
class Matrix {
  final int columns;
  final int rows;
  final List<List<Square>> _grid;

  /// Private constructor to initialize the grid.
  Matrix._(this.columns, this.rows, this._grid);

  /// Factory constructor to create a Matrix with all squares initialized to Inactive.
  factory Matrix(int columns, int rows) {
    final grid = List<List<Square>>.generate(
      rows,
      (y) => List<Square>.generate(columns, (x) => const Inactive()),
      growable: false,
    );
    return Matrix._(columns, rows, grid);
  }

  /// Factory constructor to create a Matrix with random Active/Inactive squares.
  factory Matrix.random(int columns, int rows, {Random? random}) {
    final rng = random ?? Random();
    final grid = List<List<Square>>.generate(
      rows,
      (y) => List<Square>.generate(
        columns,
        (x) => rng.nextBool() ? const Active() : const Inactive(),
      ),
      growable: false,
    );
    return Matrix._(columns, rows, grid);
  }

  /// Gets the square at the specified position.
  /// Throws an exception if the indices are out of bounds.
  Square get(int x, int y) {
    if (x < 0 || x >= columns || y < 0 || y >= rows) {
      throw RangeError('Index out of bounds: ($x, $y)');
    }
    return _grid[y][x];
  }

  /// Returns a new Matrix with the square at the specified position toggled.
  /// If the square was Active, it becomes Inactive, and vice versa.
  Matrix toggle(int x, int y) {
    if (x < 0 || x >= columns || y < 0 || y >= rows) {
      throw RangeError('Index out of bounds: ($x, $y)');
    }

    final newGrid = List<List<Square>>.generate(
      rows,
      (yIndex) => List<Square>.generate(
        columns,
        (xIndex) => _grid[yIndex][xIndex],
        growable: false,
      ),
      growable: false,
    );

    final currentSquare = _grid[y][x];
    newGrid[y][x] = currentSquare is Active ? const Inactive() : const Active();

    return Matrix._(columns, rows, newGrid);
  }

  /// Creates a copy of this Matrix.
  Matrix copy() {
    return Matrix._(columns, rows, _grid);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Matrix &&
          runtimeType == other.runtimeType &&
          columns == other.columns &&
          rows == other.rows &&
          _deepGridEquals(_grid, other._grid);

  /// Performs a deep equality check on the 2D grid of Squares.
  bool _deepGridEquals(List<List<Square>> grid1, List<List<Square>> grid2) {
    if (grid1.length != grid2.length) return false;
    for (int i = 0; i < grid1.length; i++) {
      final List<Square> row1 = grid1[i];
      final List<Square> row2 = grid2[i];
      if (row1.length != row2.length) return false;
      for (int j = 0; j < row1.length; j++) {
        if (row1[j] != row2[j]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    int hash = columns.hashCode ^ rows.hashCode;
    for (var row in _grid) {
      for (var square in row) {
        hash = hash ^ square.hashCode;
      }
    }
    return hash;
  }
}
