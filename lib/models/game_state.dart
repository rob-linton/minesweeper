import 'cell.dart';
import '../core/utils/grid_calculator.dart';

enum GameStatus {
  playing,
  won,
}

class GameState {
  final List<List<Cell>> grid;
  final int mineCount;
  final int flagCount;
  final int revealedCount;
  final int explodedCount;
  final GameStatus status;
  final bool isFirstClick;
  final GridDimensions dimensions;
  final int revealCounter; // Tracks reveal order for animations

  const GameState({
    required this.grid,
    required this.mineCount,
    required this.flagCount,
    required this.revealedCount,
    required this.explodedCount,
    required this.status,
    required this.isFirstClick,
    required this.dimensions,
    required this.revealCounter,
  });

  int get remainingMines => mineCount - flagCount;
  int get totalCells => dimensions.totalCells;
  int get safeCells => totalCells - mineCount;
  bool get hasWon => revealedCount >= safeCells;

  GameState copyWith({
    List<List<Cell>>? grid,
    int? mineCount,
    int? flagCount,
    int? revealedCount,
    int? explodedCount,
    GameStatus? status,
    bool? isFirstClick,
    GridDimensions? dimensions,
    int? revealCounter,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      mineCount: mineCount ?? this.mineCount,
      flagCount: flagCount ?? this.flagCount,
      revealedCount: revealedCount ?? this.revealedCount,
      explodedCount: explodedCount ?? this.explodedCount,
      status: status ?? this.status,
      isFirstClick: isFirstClick ?? this.isFirstClick,
      dimensions: dimensions ?? this.dimensions,
      revealCounter: revealCounter ?? this.revealCounter,
    );
  }
}
