import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_state.dart';
import 'core/ui.dart';
import 'features/auth/auth_pages.dart';
import 'features/booking/booking_pages.dart';
import 'features/booking/trip_pages.dart';
import 'features/payment/payment_pages.dart';
import 'features/account/account_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  const screen = int.fromEnvironment('SCREEN', defaultValue: 1);
  final webScreen = int.tryParse(Uri.base.queryParameters['screen'] ?? '');
  final index = (webScreen ?? screen).clamp(1, AppPage.values.length) - 1;
  runApp(CargoApp(state: AppState(initial: AppPage.values[index])));
}

class CargoApp extends StatelessWidget {
  const CargoApp({super.key, required this.state});
  final AppState state;
  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: MaterialApp(
      title: 'Cargo',
      debugShowCheckedModeBanner: false,
      theme: cargoTheme(),
      home: AnimatedBuilder(
        animation: state,
        builder: (context, _) => PopScope(
          canPop: state.page == AppPage.splash,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) state.back();
          },
          child: KeyedSubtree(
            key: ValueKey(state.page),
            child: _page(state.page),
          ),
        ),
      ),
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFE8ECF2),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child!,
          ),
        ),
      ),
    ),
  );
  Widget _page(AppPage page) => switch (page) {
    AppPage.splash => const SplashPage(),
    AppPage.signUp ||
    AppPage.signUpFilled ||
    AppPage.login ||
    AppPage.forgot => AuthPage(page: page),
    AppPage.country => const CountryPage(),
    AppPage.verify => const VerifyPage(),
    AppPage.location => const LocationPage(),
    AppPage.home => const HomePage(),
    AppPage.destination => const DestinationPage(),
    AppPage.mapDestination => const MapDestinationPage(),
    AppPage.favorites => const FavoritesPage(),
    AppPage.addPlace => const AddPlacePage(),
    AppPage.service => const ServicePage(),
    AppPage.serviceFull => const ServicePage(full: true),
    AppPage.promo => const PromoPage(),
    AppPage.payment => const PaymentPage(),
    AppPage.addCard => const AddCardPage(),
    AppPage.scanCard => const ScanCardPage(),
    AppPage.pickup => const PickupPage(),
    AppPage.processing => const ProcessingPage(),
    AppPage.driver ||
    AppPage.driverFull ||
    AppPage.driverPayment => DriverPage(page: page),
    AppPage.cancel => const CancelPage(),
    AppPage.rating => const RatingPage(),
    AppPage.tip => const RatingPage(tip: true),
    AppPage.menu => const MenuPage(),
    AppPage.profile => const ProfilePage(),
    AppPage.trips => TripsPage(initialTab: state.tripTab),
  };
}
