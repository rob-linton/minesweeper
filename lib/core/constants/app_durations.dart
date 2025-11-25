class AppDurations {
  AppDurations._();

  // Splash screen
  static const Duration splashFadeIn = Duration(milliseconds: 800);
  static const Duration splashHold = Duration(milliseconds: 1200);
  static const Duration splashFadeOut = Duration(milliseconds: 500);
  static const Duration splashTotal = Duration(milliseconds: 2500);

  // Cell animations
  static const Duration cellTap = Duration(milliseconds: 100);
  static const Duration cellReveal = Duration(milliseconds: 200);
  static const Duration cascadeDelay = Duration(milliseconds: 30);

  // Explosion
  static const Duration explosion = Duration(milliseconds: 600);
  static const Duration explosionShake = Duration(milliseconds: 300);
  static const Duration explosionParticle = Duration(milliseconds: 500);

  // Board animations
  static const Duration boardAppear = Duration(milliseconds: 400);
  static const Duration boardStaggerDelay = Duration(milliseconds: 15);

  // UI animations
  static const Duration counterChange = Duration(milliseconds: 200);
  static const Duration buttonPress = Duration(milliseconds: 100);

  // Win celebration
  static const Duration winReveal = Duration(milliseconds: 800);
}
