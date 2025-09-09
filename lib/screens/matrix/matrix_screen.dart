import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'matrix_config_screen.dart';
import 'game_screen.dart'; // Import the game screen
import '../../shared/providers/matrix_config_provider.dart';
import '../../modules/matrix/models/matrix.dart';
// Import the game manager from its correct location
import '../../modules/matrix/matrix_game_manager.dart';
import '../../modules/matrix/components/matrix_widget.dart'; // Import MatrixWidget
import '../../shared/theme/dimensions.dart';

class MatrixScreen extends StatefulWidget {
  const MatrixScreen({super.key});

  @override
  State<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends State<MatrixScreen> {
  late Matrix _matrix;

  @override
  void initState() {
    super.initState();
    // Initialize matrix based on the current config when the state is first created
    _initializeMatrix();
  }

  void _initializeMatrix() {
    final configProvider = context.read<
        MatrixConfigProvider>(); // Safe to use read in initState for initial value
    final config = configProvider.config;
    _matrix = Matrix(config.columns, config.rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrices'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MatrixConfigScreen(),
                ),
              ).then((_) {
                setState(() {
                  _initializeMatrix();
                });
              });
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
                  flex: 1,
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
                        'Memoriza matrices',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Matrix section
                Expanded(
                  flex: 3,
                  child: Center(
                    child: MatrixWidget(initialMatrix: _matrix, isEditable: true),
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
                          final configProvider = Provider.of<MatrixConfigProvider>(
                              context,
                              listen: false);
                          final config = configProvider.config;

                          // Create a new game manager based on the current configuration
                          final gameManager = MatrixGameManager(config: config);

                          // Start the game
                          gameManager.startGame();

                          // Navigate to the game screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameScreen(gameManager: gameManager),
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
