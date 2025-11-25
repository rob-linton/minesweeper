import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/utils/grid_calculator.dart';
import '../models/game_state.dart';
import '../providers/game_provider.dart';
import '../widgets/game/game_header.dart';
import '../widgets/game/game_board.dart';
import '../widgets/game/win_overlay.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  GridDimensions? _dimensions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final topPadding = MediaQuery.of(context).padding.top;

          // Calculate grid dimensions - full width, remaining height after header
          final availableWidth = constraints.maxWidth;
          final availableHeight = constraints.maxHeight -
              AppDimensions.headerHeight -
              topPadding;

          final dimensions = GridCalculator.calculate(
            availableWidth: availableWidth,
            availableHeight: availableHeight,
          );

          // Only rebuild if dimensions changed
          if (_dimensions != dimensions) {
            _dimensions = dimensions;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(gridDimensionsProvider.notifier).state = dimensions;
            });
          }

          if (_dimensions == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              Column(
                children: [
                  // Top safe area
                  SizedBox(height: topPadding),
                  // Grid at top, goes edge-to-edge
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: GameBoard(dimensions: _dimensions!),
                    ),
                  ),
                  // Status bar at very bottom
                  GameHeader(
                    dimensions: _dimensions!,
                  ),
                ],
              ),
              // Win overlay
              Consumer(
                builder: (context, ref, child) {
                  final gameState =
                      ref.watch(gameProviderFamily(_dimensions!));
                  if (gameState.status == GameStatus.won) {
                    return WinOverlay(
                      onNewGame: () {
                        ref
                            .read(gameProviderFamily(_dimensions!).notifier)
                            .newGame();
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
