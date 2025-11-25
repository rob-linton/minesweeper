import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cell.dart';
import '../models/cell_state.dart';
import '../models/game_state.dart';
import '../core/utils/grid_calculator.dart';

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier(GridDimensions dimensions) : super(_createInitialState(dimensions));

  static GameState _createInitialState(GridDimensions dimensions) {
    // Create empty grid (mines placed on first click for safety)
    final grid = List.generate(
      dimensions.rows,
      (row) => List.generate(
        dimensions.columns,
        (col) => Cell(row: row, column: col),
      ),
    );

    return GameState(
      grid: grid,
      mineCount: dimensions.mineCount,
      flagCount: 0,
      revealedCount: 0,
      explodedCount: 0,
      status: GameStatus.playing,
      isFirstClick: true,
      dimensions: dimensions,
      revealCounter: 0,
    );
  }

  /// Handle cell tap - reveal cell
  void revealCell(int row, int col) {
    if (state.status != GameStatus.playing) return;

    final cell = state.grid[row][col];
    if (!cell.canReveal) return;

    if (state.isFirstClick) {
      _placeMines(row, col);
    }

    final updatedCell = state.grid[row][col];

    if (updatedCell.isMine) {
      _handleMineClick(row, col);
    } else {
      _revealCellAndCascade(row, col);
    }

    _checkWinCondition();
  }

  /// Handle long press - toggle flag
  void toggleFlag(int row, int col) {
    if (state.status != GameStatus.playing) return;

    final cell = state.grid[row][col];
    if (!cell.canFlag) return;

    final newState = cell.state == CellState.flagged
        ? CellState.hidden
        : CellState.flagged;

    final newGrid = _copyGrid();
    newGrid[row][col] = cell.copyWith(state: newState);

    final flagDelta = newState == CellState.flagged ? 1 : -1;

    state = state.copyWith(
      grid: newGrid,
      flagCount: state.flagCount + flagDelta,
    );
  }

  /// Place mines avoiding the first clicked cell and its neighbors
  void _placeMines(int safeRow, int safeCol) {
    final random = Random();
    final safeZone = _getNeighbors(safeRow, safeCol).toSet()
      ..add((safeRow, safeCol));

    final newGrid = _copyGrid();
    int minesPlaced = 0;

    while (minesPlaced < state.mineCount) {
      final row = random.nextInt(state.dimensions.rows);
      final col = random.nextInt(state.dimensions.columns);

      if (!safeZone.contains((row, col)) && !newGrid[row][col].isMine) {
        newGrid[row][col] = newGrid[row][col].copyWith(isMine: true);
        minesPlaced++;
      }
    }

    // Calculate adjacent mines for all cells
    for (int r = 0; r < state.dimensions.rows; r++) {
      for (int c = 0; c < state.dimensions.columns; c++) {
        if (!newGrid[r][c].isMine) {
          final count = _getNeighbors(r, c)
              .where((pos) => newGrid[pos.$1][pos.$2].isMine)
              .length;
          newGrid[r][c] = newGrid[r][c].copyWith(adjacentMines: count);
        }
      }
    }

    state = state.copyWith(
      grid: newGrid,
      isFirstClick: false,
    );
  }

  /// Reveal cell and cascade if empty (flood fill algorithm)
  void _revealCellAndCascade(int row, int col) {
    final cellsToReveal = <(int, int, int)>[]; // (row, col, order)
    final visited = <(int, int)>{};
    int order = state.revealCounter;

    void flood(int r, int c) {
      if (visited.contains((r, c))) return;
      if (r < 0 || r >= state.dimensions.rows) return;
      if (c < 0 || c >= state.dimensions.columns) return;

      final cell = state.grid[r][c];
      if (cell.state != CellState.hidden) return;
      if (cell.isMine) return;

      visited.add((r, c));
      cellsToReveal.add((r, c, order++));

      // If empty (0 adjacent mines), cascade to neighbors
      if (cell.adjacentMines == 0) {
        for (final (nr, nc) in _getNeighbors(r, c)) {
          flood(nr, nc);
        }
      }
    }

    flood(row, col);

    if (cellsToReveal.isEmpty) return;

    final newGrid = _copyGrid();

    for (final (r, c, revealOrder) in cellsToReveal) {
      newGrid[r][c] = newGrid[r][c].copyWith(
        state: CellState.revealed,
        revealOrder: revealOrder,
      );
    }

    state = state.copyWith(
      grid: newGrid,
      revealedCount: state.revealedCount + cellsToReveal.length,
      revealCounter: order,
    );
  }

  /// Handle mine click - show explosion but continue game
  void _handleMineClick(int row, int col) {
    final newGrid = _copyGrid();
    final cell = newGrid[row][col];

    newGrid[row][col] = cell.copyWith(
      state: CellState.exploded,
      revealOrder: state.revealCounter,
    );

    state = state.copyWith(
      grid: newGrid,
      explodedCount: state.explodedCount + 1,
      revealCounter: state.revealCounter + 1,
    );
  }

  /// Get all valid neighbor positions (8 directions)
  List<(int, int)> _getNeighbors(int row, int col) {
    final neighbors = <(int, int)>[];
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final nr = row + dr;
        final nc = col + dc;
        if (nr >= 0 &&
            nr < state.dimensions.rows &&
            nc >= 0 &&
            nc < state.dimensions.columns) {
          neighbors.add((nr, nc));
        }
      }
    }
    return neighbors;
  }

  /// Check if player has won
  void _checkWinCondition() {
    if (state.hasWon) {
      state = state.copyWith(status: GameStatus.won);
    }
  }

  /// Start a new game with same dimensions
  void newGame() {
    state = _createInitialState(state.dimensions);
  }

  /// Create a deep copy of the grid
  List<List<Cell>> _copyGrid() {
    return state.grid.map((row) => row.toList()).toList();
  }
}

/// Provider for grid dimensions - set after measuring screen
final gridDimensionsProvider = StateProvider<GridDimensions?>((ref) => null);

/// Provider family for game state based on dimensions
final gameProviderFamily =
    StateNotifierProvider.family<GameNotifier, GameState, GridDimensions>(
  (ref, dimensions) => GameNotifier(dimensions),
);
