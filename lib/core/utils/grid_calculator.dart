import '../constants/app_dimensions.dart';

class GridDimensions {
  final int columns;
  final int rows;
  final double cellWidth;
  final double cellHeight;
  final int mineCount;

  const GridDimensions({
    required this.columns,
    required this.rows,
    required this.cellWidth,
    required this.cellHeight,
    required this.mineCount,
  });

  int get totalCells => columns * rows;
  double get gridWidth => columns * cellWidth;
  double get gridHeight => rows * cellHeight;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GridDimensions &&
        other.columns == columns &&
        other.rows == rows &&
        other.cellWidth == cellWidth &&
        other.cellHeight == cellHeight &&
        other.mineCount == mineCount;
  }

  @override
  int get hashCode => Object.hash(columns, rows, cellWidth, cellHeight, mineCount);
}

class GridCalculator {
  GridCalculator._();

  /// Calculate optimal grid dimensions based on available screen space.
  /// Fills the entire available space - cells may be slightly non-square.
  static GridDimensions calculate({
    required double availableWidth,
    required double availableHeight,
  }) {
    // Calculate how many cells can fit with minimum size
    int columns = (availableWidth / AppDimensions.minCellSize).floor();
    int rows = (availableHeight / AppDimensions.minCellSize).floor();

    // Clamp to reasonable limits
    columns = columns.clamp(AppDimensions.minColumns, AppDimensions.maxColumns);
    rows = rows.clamp(AppDimensions.minRows, AppDimensions.maxRows);

    // Calculate cell dimensions to exactly fill available space
    // Cells will be slightly non-square to fill the entire screen
    double cellWidth = availableWidth / columns;
    double cellHeight = availableHeight / rows;

    // Calculate mine count (15% density, but leave room for first-click safety)
    int totalCells = columns * rows;
    int mineCount = (totalCells * AppDimensions.mineDensity).round();
    mineCount = mineCount.clamp(1, totalCells - 9);

    return GridDimensions(
      columns: columns,
      rows: rows,
      cellWidth: cellWidth,
      cellHeight: cellHeight,
      mineCount: mineCount,
    );
  }
}
