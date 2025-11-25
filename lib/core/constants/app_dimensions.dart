class AppDimensions {
  AppDimensions._();

  // Touch target minimum (smaller for more cells)
  static const double minCellSize = 34.0;
  static const double maxCellSize = 50.0;

  // Cell styling
  static const double cellBorderRadius = 4.0;
  static const double cellBorderWidth = 0.5;

  // Header
  static const double headerHeight = 78.0;
  static const double headerPadding = 16.0;
  static const double headerIconSize = 24.0;

  // Grid (no padding - goes to edges)
  static const double gridPadding = 0.0;

  // Mine density (percentage of cells that are mines)
  static const double mineDensity = 0.15;

  // Grid limits
  static const int minColumns = 5;
  static const int maxColumns = 25;
  static const int minRows = 5;
  static const int maxRows = 40;

  // New game button
  static const double newGameButtonSize = 48.0;
  static const double newGameIconSize = 24.0;
}
