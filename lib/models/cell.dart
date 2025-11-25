import 'cell_state.dart';

class Cell {
  final int row;
  final int column;
  final bool isMine;
  final int adjacentMines;
  final CellState state;
  final int revealOrder; // For cascade animation timing

  const Cell({
    required this.row,
    required this.column,
    this.isMine = false,
    this.adjacentMines = 0,
    this.state = CellState.hidden,
    this.revealOrder = 0,
  });

  Cell copyWith({
    bool? isMine,
    int? adjacentMines,
    CellState? state,
    int? revealOrder,
  }) {
    return Cell(
      row: row,
      column: column,
      isMine: isMine ?? this.isMine,
      adjacentMines: adjacentMines ?? this.adjacentMines,
      state: state ?? this.state,
      revealOrder: revealOrder ?? this.revealOrder,
    );
  }

  bool get canReveal => state == CellState.hidden;
  bool get canFlag => state == CellState.hidden || state == CellState.flagged;
  bool get isRevealed => state == CellState.revealed || state == CellState.exploded;
  bool get isFlagged => state == CellState.flagged;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cell &&
        other.row == row &&
        other.column == column &&
        other.isMine == isMine &&
        other.adjacentMines == adjacentMines &&
        other.state == state &&
        other.revealOrder == revealOrder;
  }

  @override
  int get hashCode {
    return Object.hash(row, column, isMine, adjacentMines, state, revealOrder);
  }
}
