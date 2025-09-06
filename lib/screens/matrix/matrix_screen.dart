import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'matrix_config_screen.dart';
import 'game_screen.dart'; // Import the game screen
import '../../shared/providers/matrix_config_provider.dart';
import '../../modules/matrix/models/matrix.dart';
// Import the game manager from its correct location
import '../../modules/matrix/matrix_game_manager.dart';
import '../../modules/matrix/components/matrix_widget.dart'; // Import MatrixWidget

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use the MatrixWidget widget with the dynamically created matrix
            MatrixWidget(initialMatrix: _matrix, isEditable: true),
            const SizedBox(height: 20),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: ElevatedButton(
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
