import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/grid_calculator.dart';
import '../../providers/game_provider.dart';
import 'cell_widget.dart';

class GameBoard extends ConsumerWidget {
  final GridDimensions dimensions;

  const GameBoard({
    super.key,
    required this.dimensions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProviderFamily(dimensions));

    return SizedBox(
      width: dimensions.gridWidth,
      height: dimensions.gridHeight,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: dimensions.columns,
          childAspectRatio: 1.0,
        ),
        itemCount: dimensions.totalCells,
        itemBuilder: (context, index) {
          final row = index ~/ dimensions.columns;
          final col = index % dimensions.columns;
          final cell = gameState.grid[row][col];

          return CellWidget(
            key: ValueKey('cell_${row}_$col'),
            cell: cell,
            cellSize: dimensions.cellSize,
            boardPosition: row + col,
            onTap: () {
              ref.read(gameProviderFamily(dimensions).notifier).revealCell(row, col);
            },
            onLongPress: () {
              ref.read(gameProviderFamily(dimensions).notifier).toggleFlag(row, col);
            },
          );
        },
      ),
    );
  }
}
