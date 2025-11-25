import '../constants/app_dimensions.dart';

class GridDimensions {
  final int columns;
  final int rows;
  final double cellSize;
  final int mineCount;

  const GridDimensions({
    required this.columns,
    required this.rows,
    required this.cellSize,
    required this.mineCount,
  });

  int get totalCells => columns * rows;
  double get gridWidth => columns * cellSize;
  double get gridHeight => rows * cellSize;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GridDimensions &&
        other.columns == columns &&
        other.rows == rows &&
        other.cellSize == cellSize &&
        other.mineCount == mineCount;
  }

  @override
  int get hashCode => Object.hash(columns, rows, cellSize, mineCount);
}

class GridCalculator {
  GridCalculator._();

  /// Calculate grid dimensions based on available screen space.
  /// Uses target cell size to determine grid count, then adjusts cell size
  /// slightly to fill the screen exactly.
  static GridDimensions calculate({
    required double availableWidth,
    required double availableHeight,
  }) {
    final targetCellSize = AppDimensions.cellSize;

    // Calculate how many cells fit in each direction using target size
    int columns = (availableWidth / targetCellSize).floor();
    int rows = (availableHeight / targetCellSize).floor();

    // Ensure at least 5x5 grid
    columns = columns.clamp(5, 100);
    rows = rows.clamp(5, 100);

    // Fudge cell size to fill screen exactly (use smaller dimension to keep square)
    final cellSizeX = availableWidth / columns;
    final cellSizeY = availableHeight / rows;
    final cellSize = cellSizeX < cellSizeY ? cellSizeX : cellSizeY;

    // Calculate mine count (15% density, but leave room for first-click safety)
    int totalCells = columns * rows;
    int mineCount = (totalCells * AppDimensions.mineDensity).round();
    mineCount = mineCount.clamp(1, totalCells - 9);

    return GridDimensions(
      columns: columns,
      rows: rows,
      cellSize: cellSize,
      mineCount: mineCount,
    );
  }
}
