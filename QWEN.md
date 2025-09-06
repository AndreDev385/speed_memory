# Contexto de QWEN para el proyecto `speed_memory`

## Descripción general del proyecto

Este es un proyecto Flutter llamado **Speed Memory**. La aplicación está diseñada
para ayudar a los usuarios a mejorar sus habilidades de memorización.
Se inspira en el software [speed-memory](https://www.speed-memory.com/) y en las
técnicas de Ramón Campayo, campeón mundial de memoria en múltiples ocasiones.

La aplicación pretende incluir ejercicios como:

- **Matrices:** Memorizar cuadrículas con filas, columnas, tiempo de
  visualización y tiempo en blanco configurables.
- **Figuras de colores:** Memorizar formas geométricas de diferentes colores que
  se muestran de forma secuencial.

El sistema de puntuación se basa en la cantidad de elementos o celdas de la
cuadrícula recordadas correctamente.

## Tecnologías

- **Lenguaje:** Dart
- **Framework:** Flutter
- **Dependencias (desde `pubspec.yaml`):**
  - `flutter` (SDK principal)
  - `cupertino_icons` (para iconos estilo iOS)
- **Dependencias de desarrollo:**
  - `flutter_test` (para pruebas)
  - `flutter_lints` (para análisis de código/verificación de estilo)

## Compilación y ejecución

Estos son comandos estándar de Flutter inferidos de la estructura del proyecto
y `pubspec.yaml`.

- **Obtener dependencias:**

  ```bash
  flutter pub get
  ```

- **Ejecutar la aplicación (desarrollo):**

  ```bash
  flutter run
  ```

  Esto normalmente se ejecutará en un dispositivo conectado o emulador.

- **Compilar la aplicación (para despliegue):**

  - Para Android:

    ```bash
    flutter build apk
    ```

  - Para iOS (requiere macOS):

    ```bash
    flutter build ios
    ```

  - Para Web:

    ```bash
    flutter build web
    ```

  - Los objetivos de compilación específicos se pueden encontrar usando
    `flutter build --help`.

- **Analizar el código:**

  ```bash
  flutter analyze
  ```

  Esto utiliza las reglas definidas en `analysis_options.yaml` que incluye `flutter_lints`.

- **Ejecutar pruebas:**

  ```bash
  flutter test
  ```

  Las pruebas se encuentran en el directorio `test/` (por ejemplo, `test/widget_test.dart`).

## Convenciones de desarrollo

- **Estilo de código:** El proyecto utiliza `flutter_lints` para análisis estático,
  aplicando buenas prácticas de codificación recomendadas para aplicaciones Flutter.
  La configuración del linter está en `analysis_options.yaml`.

- **Estructura del proyecto:**
  - El código fuente reside en el directorio `lib/`. El punto de entrada es `lib/main.dart`.
  - Las pruebas se encuentran en el directorio `test/`. Se sigue el enfoque estándar
    de pruebas de Flutter usando `flutter_test` y `WidgetTester` (como se ve en `test/widget_test.dart`).
  - El código específico de plataforma (si es necesario) iría en
    `android/`, `ios/`, `web/`, etc.
  - **Arquitectura:** El proyecto sigue una estructura modular:
    - `lib/main.dart`: Punto de entrada de la aplicación.
    - `lib/shared/`: Contiene recursos compartidos como temas (`theme/`) y
      rutas (`routes/`).
    - `lib/screens/`: Contiene las pantallas (widgets) de la aplicación,
      organizadas por módulo (por ejemplo, `matrix/`, `colored_figures/`).
    - `lib/modules/`: Contiene la lógica del dominio de la aplicación, incluyendo
      modelos y tipos, organizados por módulo (por ejemplo, `matrix/models/`).
  - **Programación Funcional:** Se utiliza un enfoque funcional para definir modelos
    inmutables. Los tipos algebraicos de datos (ADTs) se utilizan para
    representar el estado de los elementos del dominio (por ejemplo, `Square` como
    `Active` o `Inactive`).
- **Gestión de Estilos:**
  - Para evitar valores codificados directamente en los widgets, se ha creado
    un archivo `lib/shared/theme/dimensions.dart` que contiene constantes para
    dimensiones comunes (paddings, margins, tamaños).
  - Se recomienda utilizar estas constantes en lugar de valores fijos para
    facilitar el mantenimiento y la consistencia visual.
- **Activos:** La gestión de activos (imágenes, fuentes) parece estar
  configurada en `pubspec.yaml`, pero actualmente no se incluyen activos.

## Historial de Cambios (Resumen)

- **Configuración Inicial:** Proyecto Flutter básico creado.
- **Tema Centralizado:** Se implementó un tema centralizado en
  `lib/shared/theme/app_theme.dart` para gestionar estilos de manera consistente.
- **Navegación Basada en Widgets:** Se configuró la navegación para usar widgets
  directamente en lugar de strings de rutas, mejorando la seguridad y mantenibilidad.
- **Modelos del Dominio para Matrices:** Se crearon los modelos `Square` y
  `Matrix` en `lib/modules/matrix/models/` siguiendo principios de programación
  funcional con tipos algebraicos de datos y estructuras de datos inmutables.
- **Centralización de Dimensiones:** Se creó `lib/shared/theme/dimensions.dart`
  para centralizar valores de espaciado y se actualizaron los widgets existentes
  para usar estas constantes.

## Programación Funcional

El proyecto adopta principios de programación funcional, especialmente en la
definición de modelos de datos.

- **Tipos Algebraicos de Datos (ADTs):** Se utilizan para representar datos
  inmutables con un conjunto fijo de formas.
  - En `lib/modules/matrix/models/square.dart`, `Square` es una clase sellada
    (`sealed class`) con subtipos `Active` e `Inactive`. Esto garantiza que cualquier
    `Square` debe ser uno de estos dos tipos, lo que facilita el manejo exhaustivo
    de casos (por ejemplo, con sentencias `switch`).
- **Inmutabilidad:** Los modelos como `Matrix` en
  `lib/modules/matrix/models/matrix.dart` son inmutables. Las operaciones como
  `toggle` devuelven una _nueva_ instancia de `Matrix` en lugar de modificar el
  estado interno de la existente. Esto facilita razonar sobre el código y evitar
  efectos secundarios no deseados.
