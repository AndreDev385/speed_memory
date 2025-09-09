import 'package:flutter/material.dart';
import 'package:speed_memory/modules/colored_figures/colored_figures_game_manager.dart';
import 'package:speed_memory/modules/colored_figures/components/colored_figure_widget.dart';
import 'package:speed_memory/modules/colored_figures/components/colored_figure_answer_preview_widget.dart';
import 'package:speed_memory/modules/colored_figures/models/colored_figure.dart';
import 'package:speed_memory/modules/colored_figures/models/figure_color.dart';
import 'package:speed_memory/shared/theme/dimensions.dart';
import 'results_screen.dart';

/// A screen that allows the user to input the figures they remember.
class UserInputScreen extends StatefulWidget {
  final ColoredFiguresGameManager gameManager;

  const UserInputScreen({super.key, required this.gameManager});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  late ColoredFiguresGameManager _gameManager;
  ColoredFigure? _selectedFigure;
  FigureColor? _selectedColor;

  @override
  void initState() {
    super.initState();
    _gameManager = widget.gameManager;
    if (_gameManager.currentFigureIndex < _gameManager.userSequences.length) {
      final selectedFigure =
          _gameManager.userSequences[_gameManager.currentFigureIndex];
      _selectedFigure = selectedFigure;
      _selectedColor = selectedFigure?.color;
    } else {
      _selectedFigure = null;
      _selectedColor = null;
    }
  }

  void _selectFigureType(ColoredFigure figure) {
    setState(() {
      _selectedFigure = figure;
    });
    _updateCurrentFigureInPreview();
  }

  void _selectColor(FigureColor color) {
    setState(() {
      _selectedColor = color;
    });
    _updateCurrentFigureInPreview();
  }

  void _updateCurrentFigureInPreview() {
    if (_selectedFigure != null && _selectedColor != null) {
      final figureToSave =
          _createFigureWithColor(_selectedFigure!, _selectedColor!);
      _gameManager.userSequences[_gameManager.currentFigureIndex] =
          figureToSave;
    } else {
      _gameManager.userSequences[_gameManager.currentFigureIndex] = null;
    }
  }

  void _saveFigure() {
    if (_selectedFigure != null && _selectedColor != null) {
      _gameManager.nextFigure();

      if (_gameManager.state == ColoredFiguresGameState.results) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(gameManager: _gameManager),
          ),
        );
      } else {
        setState(() {
          _selectedFigure = null;
          _selectedColor = null;
        });
      }
    }
  }

  void _onPreviewItemTapped(int index) {
    if (index != _gameManager.currentFigureIndex) {
      _gameManager.goToUserFigureIndex(index);
      setState(() {
        if (index < _gameManager.userSequences.length) {
          final selectedFigure = _gameManager.userSequences[index];
          _selectedFigure = selectedFigure;
          _selectedColor = selectedFigure?.color;
        } else {
          _selectedFigure = null;
          _selectedColor = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Respuesta'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Preview
          Container(
            height: AppDimensions.previewSectionHeight,
            padding:
                const EdgeInsets.all(AppDimensions.previewContainerPadding),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _gameManager.userSequences.length,
                  (index) => ColoredFigureAnswerPreviewWidget(
                    figure: _gameManager.userSequences[index],
                    index: index,
                    isCurrent: index == _gameManager.currentFigureIndex,
                    onTap: () => _onPreviewItemTapped(index),
                  ),
                ),
              ),
            ),
          ),
          // Placeholder
          Expanded(
            child: Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: _selectedFigure != null && _selectedColor != null
                      ? ColoredFigureWidget(
                          figure: _createFigureWithColor(
                              _selectedFigure!, _selectedColor!),
                          size: 150,
                        )
                      : const Text(
                          'Sin selección',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
            ),
          ),
          // Options
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Tu selección actual:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    height: 80,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFigureTypeOption(
                            const Circle(FigureColor.white), 'Círculo'),
                        _buildFigureTypeOption(
                            const Square(FigureColor.white), 'Cuadrado'),
                        _buildFigureTypeOption(
                            const Triangle(FigureColor.white), 'Triángulo'),
                        _buildFigureTypeOption(
                            const Pentagon(FigureColor.white), 'Pentágono'),
                        _buildFigureTypeOption(
                            const Hexagon(FigureColor.white), 'Hexágono'),
                        _buildFigureTypeOption(
                            const Heptagon(FigureColor.white), 'Heptágono'),
                        _buildFigureTypeOption(
                            const Rectangle(FigureColor.white), 'Rectángulo'),
                        _buildFigureTypeOption(
                            const Star(FigureColor.white), 'Estrella'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        _buildColorOption(FigureColor.black),
                        _buildColorOption(FigureColor.brown),
                        _buildColorOption(FigureColor.red), // 3rd from left
                        _buildColorOption(FigureColor.orange), // After red
                        _buildColorOption(FigureColor.green),
                        _buildColorOption(FigureColor.yellow),
                        _buildColorOption(FigureColor.blue),
                        _buildColorOption(FigureColor.purple),
                        _buildColorOption(FigureColor.grey),
                        _buildColorOption(FigureColor.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: (_selectedFigure != null &&
                                _selectedColor != null)
                            ? _saveFigure
                            : null,
                        child: _gameManager.currentFigureIndex <
                                _gameManager.config.numberOfFigures - 1
                            ? const Text('Siguiente')
                            : const Text('Finalizar'),
                      ),
                    ),
                  ],
                ),
                if (_gameManager.currentFigureIndex > 0) ...[
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        _gameManager.previousFigure();
                        setState(() {
                          if (_gameManager.currentFigureIndex <
                              _gameManager.userSequences.length) {
                            final selectedFigure = _gameManager.userSequences[
                                _gameManager.currentFigureIndex];
                            _selectedFigure = selectedFigure;
                            _selectedColor = selectedFigure?.color;
                          } else {
                            _selectedFigure = null;
                            _selectedColor = null;
                          }
                        });
                      },
                      child: const Text('Volver a la figura anterior'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFigureTypeOption(ColoredFigure figure, String label) {
    final bool isSelected = _selectedFigure?.runtimeType == figure.runtimeType;

    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 5),
      child: GestureDetector(
        onTap: () => _selectFigureType(figure),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.transparent,
              width: isSelected ? 3 : 0,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: ColoredFigureWidget(
              figure: figure,
              size: 54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(FigureColor color) {
    final bool isSelected = _selectedColor == color;

    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(right: 5),
      child: GestureDetector(
        onTap: () => _selectColor(color),
        child: Container(
          decoration: BoxDecoration(
            color: figureColorToColor(color),
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.grey,
              width: isSelected ? 3 : 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  ColoredFigure _createFigureWithColor(
      ColoredFigure figure, FigureColor color) {
    if (figure is Circle) {
      return Circle(color);
    } else if (figure is Square) {
      return Square(color);
    } else if (figure is Triangle) {
      return Triangle(color);
    } else if (figure is Pentagon) {
      return Pentagon(color);
    } else if (figure is Hexagon) {
      return Hexagon(color);
    } else if (figure is Heptagon) {
      return Heptagon(color);
    } else if (figure is Rectangle) {
      return Rectangle(color);
    } else if (figure is Star) {
      return Star(color);
    } else {
      return Circle(color);
    }
  }
}
