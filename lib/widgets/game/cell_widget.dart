import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_durations.dart';
import '../../models/cell.dart';
import '../../models/cell_state.dart';

class CellWidget extends StatefulWidget {
  final Cell cell;
  final double cellSize;
  final int boardPosition;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CellWidget({
    super.key,
    required this.cell,
    required this.cellSize,
    required this.boardPosition,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _showExplosion = false;
  late AnimationController _explosionController;

  @override
  void initState() {
    super.initState();
    _explosionController = AnimationController(
      vsync: this,
      duration: AppDurations.explosion,
    );
  }

  @override
  void dispose() {
    _explosionController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger explosion animation when cell becomes exploded
    if (widget.cell.state == CellState.exploded &&
        oldWidget.cell.state != CellState.exploded) {
      setState(() => _showExplosion = true);
      _explosionController.forward().then((_) {
        if (mounted) {
          setState(() => _showExplosion = false);
          _explosionController.reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.cell.canReveal ? widget.onTap : null,
      onLongPress: widget.cell.canFlag ? widget.onLongPress : null,
      child: AnimatedScale(
        scale: _isPressed && widget.cell.canReveal ? 0.95 : 1.0,
        duration: AppDurations.cellTap,
        curve: Curves.easeOut,
        child: _buildCell(),
      ),
    );
  }

  Widget _buildCell() {
    return Stack(
      children: [
        // Main cell content
        _buildCellContent(),
        // Explosion overlay
        if (_showExplosion) _buildExplosionOverlay(),
      ],
    );
  }

  Widget _buildCellContent() {
    final isRevealed = widget.cell.isRevealed;
    final isFlagged = widget.cell.isFlagged;
    final isExploded = widget.cell.state == CellState.exploded;

    Widget content = Container(
      width: widget.cellSize,
      height: widget.cellSize,
      decoration: BoxDecoration(
        color: _getCellColor(),
        border: Border.all(
          color: AppColors.cellBorder,
          width: AppDimensions.cellBorderWidth,
        ),
      ),
      child: Center(
        child: _buildCellIcon(),
      ),
    );

    // Add reveal animation for newly revealed cells
    if (isRevealed && !isExploded) {
      final delay = (widget.cell.revealOrder * 30).clamp(0, 500);
      content = content
          .animate()
          .fadeIn(
            duration: AppDurations.cellReveal,
            delay: Duration(milliseconds: delay),
          )
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
            duration: AppDurations.cellReveal,
            delay: Duration(milliseconds: delay),
            curve: Curves.easeOutBack,
          );
    }

    // Add flag animation
    if (isFlagged) {
      content = content
          .animate()
          .scale(
            begin: const Offset(1.2, 1.2),
            end: const Offset(1.0, 1.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
          );
    }

    return content;
  }

  Color _getCellColor() {
    switch (widget.cell.state) {
      case CellState.hidden:
        return AppColors.cellHidden;
      case CellState.flagged:
        return AppColors.cellFlagged;
      case CellState.revealed:
        return AppColors.cellRevealed;
      case CellState.exploded:
        return AppColors.cellExploded;
    }
  }

  Widget? _buildCellIcon() {
    final iconSize = widget.cellSize * 0.5;

    switch (widget.cell.state) {
      case CellState.hidden:
        return null;
      case CellState.flagged:
        return Icon(
          Icons.flag,
          color: AppColors.flag,
          size: iconSize,
        );
      case CellState.exploded:
        return Icon(
          Icons.brightness_7,
          color: AppColors.mine,
          size: iconSize,
        );
      case CellState.revealed:
        if (widget.cell.isMine) {
          return Icon(
            Icons.brightness_7,
            color: AppColors.mine,
            size: iconSize,
          );
        }
        if (widget.cell.adjacentMines > 0) {
          return Text(
            widget.cell.adjacentMines.toString(),
            style: TextStyle(
              fontSize: iconSize,
              fontWeight: FontWeight.bold,
              color: AppColors.numberColors[widget.cell.adjacentMines],
            ),
          );
        }
        return null;
    }
  }

  Widget _buildExplosionOverlay() {
    return AnimatedBuilder(
      animation: _explosionController,
      builder: (context, child) {
        return SizedBox(
          width: widget.cellSize,
          height: widget.cellSize,
          child: CustomPaint(
            painter: ExplosionPainter(
              progress: _explosionController.value,
              color: AppColors.explosion,
            ),
          ),
        );
      },
    );
  }
}

class ExplosionPainter extends CustomPainter {
  final double progress;
  final Color color;

  ExplosionPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.8;
    final random = math.Random(42); // Fixed seed for consistent particles

    // Draw particles
    final particlePaint = Paint()
      ..color = color.withValues(alpha: (1 - progress) * 0.8)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * math.pi + random.nextDouble() * 0.5;
      final distance = maxRadius * progress * (0.5 + random.nextDouble() * 0.5);
      final particleSize = 4.0 * (1 - progress * 0.5);

      final particleCenter = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      canvas.drawCircle(particleCenter, particleSize, particlePaint);
    }

    // Draw central glow
    if (progress < 0.5) {
      final glowPaint = Paint()
        ..color = AppColors.explosionGlow.withValues(alpha: (0.5 - progress) * 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, size.width * 0.3 * (1 + progress), glowPaint);
    }
  }

  @override
  bool shouldRepaint(ExplosionPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
