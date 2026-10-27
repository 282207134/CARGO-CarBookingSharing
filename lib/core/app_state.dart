import 'package:flutter/material.dart';

enum AppPage {
  splash('Splash Screen'),
  signUp('Sign Up'),
  signUpFilled('Sign Up · Input'),
  country('Select a country'),
  login('Log In'),
  forgot('Forgot Password'),
  verify('Verify phone number'),
  location('Enable Location'),
  home('Home'),
  destination('Choose a Destination'),
  mapDestination('Set Destination on Map'),
  favorites('My favorites'),
  addPlace('Add new place'),
  service('Select Service'),
  serviceFull('Select Service · Full view'),
  promo('Add promo code'),
  payment('Payment Methods'),
  addCard('Add credit card'),
  scanCard('Scan credit card'),
  pickup('Pick-up Time'),
  processing('Processing booking'),
  driver('Driver coming'),
  driverFull('Driver coming · Full view'),
  driverPayment('Driver coming · Payment'),
  cancel('Cancel ride'),
  rating('Rating'),
  tip('Add a tip'),
  menu('Menu'),
  profile('My Profile'),
  trips('My trips');

  const AppPage(this.title);
  final String title;
  String get number => (index + 1).toString().padLeft(2, '0');
}

class RideService {
  const RideService(this.name, this.price, this.asset, this.description);
  final String name, asset, description;
  final double price;
}

const services = [
  RideService(
    'SHARED',
    35.50,
    'car-shared',
    'Shared rides with others going your way',
  ),
  RideService(
    'STANDARD',
    50,
    'car-standard',
    'Affordable rides, all to yourself',
  ),
  RideService('DELUXE', 95.30, 'car-deluxe', 'Newer cars with extra legroom'),
  RideService(
    'PREMIUM',
    120.50,
    'car-premium',
    'Luxury rides with professional drivers',
  ),
  RideService(
    'SUPREME',
    140,
    'car-supreme',
    'Luxury rides for 6 with professional drivers',
  ),
];

class SavedPlace {
  const SavedPlace(this.name, this.address);
  final String name, address;
}

class TripRecord {
  const TripRecord(this.destination, this.price, this.status);
  final String destination, status;
  final double price;
}

/// Local demo state; all booking mutations pass through this controller.
class AppState extends ChangeNotifier {
  AppState({AppPage initial = AppPage.splash}) : page = initial;
  AppPage page;
  AppPage paymentReturn = AppPage.service;
  final List<AppPage> _history = [];
  int tripTab = 0;
  int serviceIndex = 0, paymentIndex = 1, promoIndex = 0, stars = 4;
  double tip = 3;
  bool notifications = true, scheduled = false, promoApplied = false;
  DateTime pickupTime = DateTime.now().add(const Duration(hours: 1));
  String country = '🇺🇸 +1',
      destination = '27 Sawayn Square',
      name = 'Travis Reeves';
  String email = '', phone = '', password = '', feedback = '';
  String? bookingStatus;
  final places = <SavedPlace>[
    const SavedPlace('BMW of Bellevue', '13424 NE 20th St Bellevue, WA 98005'),
    const SavedPlace("McDonald’s", '13841 NE 20th St Bellevue, WA 98005'),
    const SavedPlace('Highland Track Field', 'NE 16th St Bellevue, WA 98007'),
  ];
  final cards = <String>[
    'Master Card •••• 5967',
    'Visa •••• 7539',
    'PayPal',
    'Cash',
  ];
  final trips = <TripRecord>[];
  RideService get service => services[serviceIndex];
  double get fare {
    if (!promoApplied) return service.price;
    return switch (promoIndex) {
      1 => service.price * .7,
      2 => (service.price - 5).clamp(0, double.infinity),
      _ => service.price * .9,
    };
  }

  String get fareLabel => 'US\$${fare.toStringAsFixed(2)}';
  void go(AppPage target) {
    if (target == page) return;
    if (target == AppPage.pickup &&
        pickupTime.isBefore(DateTime.now().add(const Duration(hours: 1)))) {
      pickupTime = DateTime.now().add(const Duration(hours: 1));
    }
    if (target == AppPage.payment &&
        page != AppPage.addCard &&
        page != AppPage.scanCard) {
      paymentReturn = page;
    }
    _history.add(page);
    page = target;
    notifyListeners();
  }

  void back() {
    page = _history.isEmpty ? AppPage.home : _history.removeLast();
    notifyListeners();
  }

  void update(VoidCallback change) {
    change();
    notifyListeners();
  }

  void book() {
    bookingStatus = 'Upcoming';
    tripTab = 0;
    go(AppPage.processing);
  }

  void cancelRide() {
    trips.add(TripRecord(destination, 2, 'Canceled'));
    tripTab = 2;
    bookingStatus = null;
    go(AppPage.home);
  }

  void completeRide() {
    trips.add(TripRecord(destination, fare + tip, 'Complete'));
    tripTab = 1;
    bookingStatus = null;
    go(AppPage.trips);
  }

  void logout() {
    _history.clear();
    email = phone = password = '';
    page = AppPage.splash;
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

extension CargoContext on BuildContext {
  AppState get app => AppScope.of(this);
  void go(AppPage page) {
    FocusManager.instance.primaryFocus?.unfocus();
    app.go(page);
  }

  void message(String text) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
}
