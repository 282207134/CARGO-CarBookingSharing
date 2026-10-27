import 'package:cargo/main.dart';
import 'package:cargo/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    final fonts = FontLoader('CargoSans')
      ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Roboto-Medium.ttf'));
    await fonts.load();
  });
  testWidgets('All 30 pages render on compact and standard phones', (
    tester,
  ) async {
    for (final size in [const Size(375, 812), const Size(320, 650)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      for (final page in AppPage.values) {
        final state = AppState(initial: page);
        await tester.pumpWidget(CargoApp(key: UniqueKey(), state: state));
        await tester.pump(const Duration(milliseconds: 300));
        expect(
          tester.takeException(),
          isNull,
          reason: '${page.title} at $size',
        );
        await tester.pumpWidget(const SizedBox());
        state.dispose();
      }
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Login validates input and navigates to home', (tester) async {
    final state = AppState(initial: AppPage.login);
    await tester.pumpWidget(CargoApp(state: state));
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'demo@cargo.app');
    await tester.enterText(find.byType(TextFormField).at(1), 'cargo123');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(state.page, AppPage.home);
    expect(find.text('Where are you going?'), findsOneWidget);
  });

  testWidgets('Destination, fare selection and booking flow', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    final state = AppState(initial: AppPage.home);
    await tester.pumpWidget(CargoApp(state: state));
    await tester.tap(find.text('Where are you going?'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('destination-input')),
      'Woodland',
    );
    await tester.pump();
    await tester.tap(find.text('Woodland Park'));
    await tester.pumpAndSettle();
    expect(state.destination, 'Woodland Park');
    await tester.tap(find.text('STANDARD'));
    await tester.pump();
    expect(state.fare, 50);
    await tester.tap(find.text('BOOK NOW'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(state.page, AppPage.processing);
    await tester.tap(find.text('Track driver'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Finish demo trip →'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('5 stars'));
    await tester.pumpAndSettle();
    expect(state.stars, 5);
    await tester.ensureVisible(find.text('Submit'));
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(state.trips.single.status, 'Complete');
    expect(state.trips.single.price, 53);
    expect(tester.takeException(), isNull);
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Country selection and favorites are interactive', (
    tester,
  ) async {
    final state = AppState(initial: AppPage.country);
    await tester.pumpWidget(CargoApp(state: state));
    await tester.enterText(find.byType(TextField), 'Japan');
    await tester.pump();
    await tester.tap(find.textContaining('Japan').last);
    await tester.pumpAndSettle();
    expect(state.country, '🇯🇵 +81');
    state.go(AppPage.addPlace);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Studio');
    await tester.tap(find.text('Save this place'));
    await tester.pumpAndSettle();
    expect(state.places.last.name, 'Studio');
    expect(find.text('Studio'), findsOneWidget);
  });

  testWidgets(
    'Country navigation retains sign-up data and PIN verification works',
    (tester) async {
      final state = AppState(initial: AppPage.signUp);
      await tester.pumpWidget(CargoApp(state: state));
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'demo@cargo.app',
      );
      await tester.tap(find.text('🇺🇸 +1'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Japan');
      await tester.pump();
      await tester.tap(find.textContaining('Japan').last);
      await tester.pumpAndSettle();
      expect(find.text('demo@cargo.app'), findsOneWidget);
      state.go(AppPage.verify);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Verify'));
      await tester.pump();
      expect(state.page, AppPage.verify);
      for (var i = 0; i < 4; i++) {
        await tester.enterText(find.byKey(Key('verification-$i')), '3247'[i]);
      }
      await tester.tap(find.text('Verify'));
      await tester.pumpAndSettle();
      expect(state.page, AppPage.location);
    },
  );

  testWidgets('Card form rejects invalid values and saves a valid demo card', (
    tester,
  ) async {
    final state = AppState(initial: AppPage.addCard);
    await tester.pumpWidget(CargoApp(state: state));
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Enter a valid card number'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).at(1),
      '4111111111111111',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '12/2099');
    await tester.enterText(find.byType(TextFormField).at(3), '123');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(state.cards.last, 'Visa •••• 1111');
    expect(state.paymentIndex, 4);
    expect(state.page, AppPage.payment);
  });

  test('Discount, cancellation and navigation keep consistent state', () {
    final state = AppState(initial: AppPage.service);
    state.serviceIndex = 1;
    state.promoApplied = true;
    expect(state.fare, 45);
    state.book();
    expect(state.bookingStatus, 'Upcoming');
    state.go(AppPage.driver);
    state.back();
    expect(state.page, AppPage.processing);
    state.cancelRide();
    expect(state.trips.single.status, 'Canceled');
    expect(state.trips.single.price, 2);
    expect(state.bookingStatus, isNull);
    state.logout();
    expect(state.page, AppPage.splash);
  });
}
