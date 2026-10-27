import 'package:cargo/main.dart';
import 'package:cargo/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Capture all 30 implemented screens on Android', (tester) async {
    final state = AppState();
    await tester.pumpWidget(CargoApp(state: state));
    await tester.runAsync(() async {
      final context = tester.element(find.byType(Scaffold).first);
      for (final name in [
        'splash',
        'brand',
        'location',
        'twitter',
        'map-home',
        'map-route',
        'avatar',
        'driver',
        'driver-car',
        'car-shared',
        'car-standard',
        'car-deluxe',
        'car-premium',
        'car-supreme',
        'scan-background',
        'credit-card',
      ]) {
        await precacheImage(AssetImage('assets/images/$name.png'), context);
      }
    });
    await binding.convertFlutterSurfaceToImage();
    for (final page in AppPage.values) {
      state.go(page);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(tester.takeException(), isNull, reason: page.title);
      for (final image in tester.widgetList<RawImage>(find.byType(RawImage))) {
        expect(
          image.image,
          isNotNull,
          reason: '${page.title}: image must be decoded before capture',
        );
      }
      await binding.takeScreenshot('${page.number}-${page.name}');
    }
    state.go(AppPage.home);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Where are you going?'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('destination-input')),
      'Woodland',
    );
    await tester.pump();
    await tester.tap(find.text('Woodland Park'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('BOOK NOW'));
    await tester.pump(const Duration(seconds: 1));
    expect(state.page, AppPage.processing);
    await tester.tap(find.text('Track driver'));
    await tester.pumpAndSettle();
    expect(state.page, AppPage.driver);
    expect(tester.takeException(), isNull);
  });
}
