import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_screen.dart';
import 'config_screen.dart';
import '../../shared/providers/colored_figures_config_provider.dart';
import '../../modules/colored_figures/colored_figures_game_manager.dart';
import '../../modules/colored_figures/components/colored_figure_widget.dart';
import '../../modules/colored_figures/models/colored_figure.dart';
import '../../modules/colored_figures/models/figure_color.dart';
import '../../shared/theme/dimensions.dart';

class ColoredFiguresScreen extends StatefulWidget {
  const ColoredFiguresScreen({super.key});

  @override
  State<ColoredFiguresScreen> createState() => _ColoredFiguresScreenState();
}

class _ColoredFiguresScreenState extends State<ColoredFiguresScreen> {
  late ColoredFiguresGameManager _gameManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Figuras de Colores'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ColoredFiguresConfigScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimensions.spacingBetweenElements),
            // Example figures
            SizedBox(
              height: 100,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: const [
                  ColoredFigureWidget(
                    figure: Circle(FigureColor.red),
                    size: 80,
                  ),
                  SizedBox(width: AppDimensions.paddingSmall),
                  ColoredFigureWidget(
                    figure: Square(FigureColor.blue),
                    size: 80,
                  ),
                  SizedBox(width: AppDimensions.paddingSmall),
                  ColoredFigureWidget(
                    figure: Triangle(FigureColor.green),
                    size: 80,
                  ),
                  SizedBox(width: AppDimensions.paddingSmall),
                  ColoredFigureWidget(
                    figure: Star(FigureColor.yellow),
                    size: 80,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingBetweenElements),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppDimensions.maxWidthConstraint),
                child: ElevatedButton(
                  onPressed: () {
                    // Get the latest config
                    final configProvider = Provider.of<ColoredFiguresConfigProvider>(
                        context,
                        listen: false);
                    final config = configProvider.config;

                    // Create a new game manager based on the current configuration
                    _gameManager = ColoredFiguresGameManager(config: config);
                    
                    // Start the game
                    _gameManager.startGame();

                    // Navigate to the game screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        ColoredFiguresGameScreen(gameManager: _gameManager),
                      ),
                    );
                  },
                  child: const Text('Empezar a jugar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
