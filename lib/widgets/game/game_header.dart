import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_durations.dart';
import '../../core/utils/grid_calculator.dart';
import '../../providers/game_provider.dart';
import '../../models/game_state.dart';

class GameHeader extends ConsumerWidget {
  final GridDimensions dimensions;

  const GameHeader({
    super.key,
    required this.dimensions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProviderFamily(dimensions));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.headerPadding),
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        height: AppDimensions.headerHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mine counter
            _CounterDisplay(
              icon: Icons.brightness_7,
              iconColor: AppColors.mine,
              value: gameState.remainingMines,
            ),
            // New game button
            _NewGameButton(
              dimensions: dimensions,
              status: gameState.status,
            ),
            // Flag counter
            _CounterDisplay(
              icon: Icons.flag,
              iconColor: AppColors.flag,
              value: gameState.flagCount,
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterDisplay extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int value;

  const _CounterDisplay({
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: AppDimensions.headerIconSize,
        ),
        const SizedBox(width: 6),
        AnimatedSwitcher(
          duration: AppDurations.counterChange,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            value.toString().padLeft(2, '0'),
            key: ValueKey(value),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ),
      ],
    );
  }
}

class _NewGameButton extends ConsumerStatefulWidget {
  final GridDimensions dimensions;
  final GameStatus status;

  const _NewGameButton({
    required this.dimensions,
    required this.status,
  });

  @override
  ConsumerState<_NewGameButton> createState() => _NewGameButtonState();
}

class _NewGameButtonState extends ConsumerState<_NewGameButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        ref.read(gameProviderFamily(widget.dimensions).notifier).newGame();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: AppDurations.buttonPress,
        curve: Curves.easeOut,
        child: Container(
          width: AppDimensions.newGameButtonSize,
          height: AppDimensions.newGameButtonSize,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.newGameButtonSize / 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            widget.status == GameStatus.won
                ? Icons.celebration
                : Icons.refresh,
            color: widget.status == GameStatus.won
                ? AppColors.winAccent
                : AppColors.textPrimary,
            size: AppDimensions.newGameIconSize,
          ),
        ),
      )
          .animate(target: widget.status == GameStatus.won ? 1 : 0)
          .shake(duration: 500.ms, hz: 3),
    );
  }
}
