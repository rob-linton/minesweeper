import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MinesweeperApp(),
      ),
    );

    // Pump once to render splash screen
    await tester.pump();

    // Verify splash screen shows title
    expect(find.text('MINESWEEPER'), findsOneWidget);

    // Pump through the splash screen duration to complete timers
    await tester.pump(const Duration(milliseconds: 3000));

    // Pump through the transition
    await tester.pumpAndSettle();
  });
}
