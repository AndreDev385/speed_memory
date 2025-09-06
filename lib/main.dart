import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/matrix/matrix_screen.dart';
import 'screens/colored_figures/colored_figures_screen.dart';
import 'shared/theme/app_theme.dart';
import 'shared/providers/matrix_config_provider.dart';
import 'shared/providers/colored_figures_config_provider.dart';
import 'shared/theme/dimensions.dart'; // Importar las dimensiones

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MatrixConfigProvider()..loadConfig(),
        ),
        ChangeNotifierProvider(
          create: (context) => ColoredFiguresConfigProvider()..loadConfig(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: const MyHomePage(title: 'Speed Memory App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppDimensions.maxWidthConstraint),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MatrixScreen(),
                        ),
                      );
                    },
                    child: const Text('Matrices'),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingBetweenElements),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ColoredFiguresScreen(),
                        ),
                      );
                    },
                    child: const Text('Figuras de Colores'),
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
