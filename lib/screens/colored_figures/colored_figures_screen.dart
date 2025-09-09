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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              children: [
                // Welcome section
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¡Bienvenido!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Text(
                        'Memoriza figuras y colores',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Example figures section
                const Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ColoredFigureWidget(
                            figure: Circle(FigureColor.red),
                            size: 70,
                          ),
                          ColoredFigureWidget(
                            figure: Square(FigureColor.blue),
                            size: 70,
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.paddingMedium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ColoredFigureWidget(
                            figure: Triangle(FigureColor.green),
                            size: 70,
                          ),
                          ColoredFigureWidget(
                            figure: Star(FigureColor.yellow),
                            size: 70,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppDimensions.paddingLarge),
                
                // Start button section
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingLarge,
                            horizontal: AppDimensions.paddingExtraLarge,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                          ),
                          elevation: 4,
                        ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              size: 24,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            const SizedBox(width: AppDimensions.paddingSmall),
                            Text(
                              'Empezar a jugar',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
