import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_durations.dart';
import 'game_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  void _startSplashSequence() async {
    await Future.delayed(AppDurations.splashTotal);
    if (mounted && !_navigating) {
      _navigating = true;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const GameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: AppDurations.splashFadeOut,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mine icon grid animation
            _buildAnimatedLogo(),
            const SizedBox(height: 32),
            // Title
            Text(
              'MINESWEEPER',
              style: Theme.of(context).textTheme.headlineLarge,
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 8),
            // Subtitle
            Text(
              'A modern classic',
              style: Theme.of(context).textTheme.bodyMedium,
            )
                .animate(delay: 600.ms)
                .fadeIn(duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background grid pattern
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final delay = index * 50;
              final isCenterCell = index == 4;

              return Container(
                decoration: BoxDecoration(
                  color: isCenterCell
                      ? AppColors.cellExploded
                      : AppColors.cellHidden,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isCenterCell
                    ? Center(
                        child: Icon(
                          Icons.brightness_7,
                          color: AppColors.mine,
                          size: 24,
                        )
                            .animate(delay: 800.ms)
                            .fadeIn(duration: 300.ms)
                            .scale(
                              begin: const Offset(0.5, 0.5),
                              end: const Offset(1.0, 1.0),
                              curve: Curves.easeOutBack,
                            ),
                      )
                    : Center(
                        child: _buildCellContent(index),
                      ),
              )
                  .animate(delay: Duration(milliseconds: delay))
                  .fadeIn(duration: 300.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeOutBack,
                  );
            },
          ),
          // Shimmer overlay
          SizedBox(
            width: 120,
            height: 120,
          )
              .animate(delay: 1000.ms)
              .shimmer(
                duration: 1200.ms,
                color: AppColors.flag.withValues(alpha: 0.3),
              ),
        ],
      ),
    );
  }

  Widget? _buildCellContent(int index) {
    // Display numbers around the center mine
    final numbers = [1, 1, 1, 1, -1, 1, 1, 1, 1];
    final num = numbers[index];

    if (num > 0) {
      return Text(
        num.toString(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.numberColors[num],
        ),
      )
          .animate(delay: Duration(milliseconds: 300 + index * 50))
          .fadeIn(duration: 300.ms);
    }
    return null;
  }
}
