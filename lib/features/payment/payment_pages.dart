import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/ui.dart';
import '../booking/booking_pages.dart';
import '../booking/map_view.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({super.key});
  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  String code = '';
  static const promos = [
    '10% Off the base rate on your next rental',
    'Save up to 30% off the base rate of weekly rental',
    'Save \$5 per day up to \$15 on your next rental',
  ];
  @override
  Widget build(BuildContext context) => PageShell(
    title: 'Add promo code',
    close: true,
    bottom: PrimaryButton(
      'Use this code',
      onPressed: () {
        context.app.update(() => context.app.promoApplied = true);
        context.go(AppPage.service);
        context.message('Promotion applied to your fare.');
      },
    ),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (v) => code = v,
                decoration: const InputDecoration(
                  hintText: 'Enter your promotion code',
                  filled: true,
                  fillColor: line,
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {
                if (code.toUpperCase().trim() == 'CARGO10') {
                  context.app.update(() {
                    context.app.promoApplied = true;
                    context.app.promoIndex = 0;
                  });
                  context.message('CARGO10 applied: 10% off.');
                } else {
                  context.message('Demo code: CARGO10');
                }
              },
              child: const Text('Apply', style: TextStyle(color: muted)),
            ),
          ],
        ),
        const SizedBox(height: 30),
        for (var i = 0; i < promos.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: InkWell(
              onTap: () => context.app.update(() => context.app.promoIndex = i),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: pale,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_offer, color: cyan, size: 45),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            promos[i],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Demo offer · valid on your next ride',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      context.app.promoIndex == i
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 22,
                      color: context.app.promoIndex == i ? cyan : line,
                    ),
                  ],
                ),
              ),
            ),
          ),
        const Text(
          'Demo offers: 10% off, 30% off or US\$5 off per ride.',
          style: TextStyle(color: muted, fontSize: 11),
        ),
      ],
    ),
  );
}

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
    title: 'Payment',
    subtitle: 'Choose your desired payment method for everyday rides.',
    close: true,
    action: TextButton(
      onPressed: () => context.go(AppPage.addCard),
      child: const Text('＋ Add'),
    ),
    bottom: PrimaryButton(
      'Done',
      onPressed: () => context.go(context.app.paymentReturn),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Payment methods'),
        ...List.generate(
          context.app.cards.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () =>
                  context.app.update(() => context.app.paymentIndex = i),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.app.paymentIndex == i ? cyan : line,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 54,
                      child: i == 0
                          ? const CardBrand(master: true)
                          : i == 2
                          ? const Icon(
                              Icons.paypal,
                              color: Color(0xFF0067AB),
                              size: 34,
                            )
                          : i == 3
                          ? const Icon(
                              Icons.payments,
                              color: Color(0xFFFFBC00),
                              size: 34,
                            )
                          : const CardBrand(),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            i == 2
                                ? 'freeslab88@gmail.com'
                                : context.app.cards[i],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (i != 2 && i != 3) ...[
                            const SizedBox(height: 6),
                            const Text(
                              'Expires 10/30',
                              style: TextStyle(color: muted, fontSize: 11),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (context.app.paymentIndex == i)
                      const Icon(Icons.check_circle, color: cyan, size: 23),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});
  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final form = GlobalKey<FormState>();
  String number = '', name = 'Travis Reeves';
  @override
  Widget build(BuildContext context) => PageShell(
    title: 'Add credit card',
    bottom: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Debit cards are accepted at some locations',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 15),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CardBrand(),
            CardBrand(master: true),
            Text(
              'DISCOVER',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            Text(
              'AMEX',
              style: TextStyle(
                color: Color(0xFF007BC3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          'Save',
          onPressed: () {
            if (!form.currentState!.validate()) return;
            final digits = number.replaceAll(RegExp(r'\D'), '');
            context.app.cards.add(
              'Visa •••• ${digits.substring(digits.length - 4)}',
            );
            context.app.paymentIndex = context.app.cards.length - 1;
            context.go(AppPage.payment);
            context.message('Demo card saved. No payment was processed.');
          },
        ),
      ],
    ),
    child: Form(
      key: form,
      child: Column(
        children: [
          const SizedBox(height: 16),
          LabeledField(
            'Name',
            initial: name,
            onChanged: (v) => name = v,
            validator: (v) =>
                v!.trim().isEmpty ? 'Enter the cardholder name' : null,
          ),
          LabeledField(
            'Credit card number',
            hint: '•••• - •••• - •••• - ••••',
            keyboard: TextInputType.number,
            onChanged: (v) => number = v,
            validator: (v) =>
                _validCard(v ?? '') ? null : 'Enter a valid card number',
            suffix: IconButton(
              tooltip: 'Scan card',
              onPressed: () => context.go(AppPage.scanCard),
              icon: const Icon(Icons.document_scanner_outlined, color: ink),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LabeledField(
                  'Expires',
                  hint: 'MM/YYYY',
                  keyboard: TextInputType.datetime,
                  validator: _expiry,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LabeledField(
                  'CVV',
                  hint: '•••',
                  secret: true,
                  keyboard: TextInputType.number,
                  validator: (v) => RegExp(r'^\d{3,4}$').hasMatch(v ?? '')
                      ? null
                      : '3–4 digits',
                ),
              ),
            ],
          ),
          const Text(
            'Demo only. Do not enter real payment information.',
            style: TextStyle(color: muted, fontSize: 11),
          ),
        ],
      ),
    ),
  );
  bool _validCard(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 13 || digits.length > 19) return false;
    var sum = 0, doubleDigit = false;
    for (var i = digits.length - 1; i >= 0; i--) {
      var d = int.parse(digits[i]);
      if (doubleDigit) {
        d *= 2;
        if (d > 9) d -= 9;
      }
      sum += d;
      doubleDigit = !doubleDigit;
    }
    return sum % 10 == 0;
  }

  String? _expiry(String? value) {
    final parts = (value ?? '').split('/');
    if (parts.length != 2) return 'Use MM/YYYY';
    final month = int.tryParse(parts[0]), year = int.tryParse(parts[1]);
    if (month == null ||
        year == null ||
        month < 1 ||
        month > 12 ||
        year < 2000) {
      return 'Invalid expiry';
    }
    return DateTime(year, month + 1).isAfter(DateTime.now())
        ? null
        : 'Card expired';
  }
}

class ScanCardPage extends StatelessWidget {
  const ScanCardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        const Asset('scan-background', fit: BoxFit.cover),
        Container(color: ink.withValues(alpha: .35)),
        SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: context.app.back,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              const Spacer(flex: 2),
              const Text(
                'Hold your card inside the frame',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 75),
              Container(
                width: 280,
                height: 182,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Asset('credit-card', fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 80,
                      child: Container(width: 4, color: cyan),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              const Text(
                'Camera preview · demo',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              TextButton(
                onPressed: () => context.go(AppPage.addCard),
                child: const Text(
                  'Enter card manually',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    ),
  );
}

class PickupPage extends StatelessWidget {
  const PickupPage({super.key});
  @override
  Widget build(BuildContext context) => MapShell(
    dim: true,
    sheet: SheetPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pick-up Time',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _option(
            context,
            false,
            'IMMEDIATE PICK-UP',
            'Get a ride in a minute',
          ),
          const SizedBox(height: 10),
          _option(
            context,
            true,
            'SCHEDULE RIDE',
            'Schedule your ride from 60 minutes in advance',
          ),
          SizedBox(
            height: 190,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 350,
                height: 190,
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontFamily: 'CargoSans',
                        fontSize: 18,
                        color: ink,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: context.app.pickupTime,
                    minimumDate: DateTime.now().add(
                      const Duration(minutes: 59),
                    ),
                    onDateTimeChanged: (time) => context.app.pickupTime = time,
                  ),
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Your driver will arrive around the selected time',
              style: TextStyle(fontSize: 11),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            'Set pickup time',
            onPressed: () {
              if (context.app.scheduled &&
                  context.app.pickupTime.isBefore(
                    DateTime.now().add(const Duration(minutes: 59)),
                  )) {
                context.message('Select a time at least 60 minutes from now.');
                return;
              }
              context.go(AppPage.service);
            },
          ),
        ],
      ),
    ),
  );
  Widget _option(
    BuildContext context,
    bool selected,
    String title,
    String subtitle,
  ) => InkWell(
    onTap: () => context.app.update(() => context.app.scheduled = selected),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: pale,
        border: Border.all(
          color: context.app.scheduled == selected ? cyan : line,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: context.app.scheduled == selected ? cyan : ink,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subtitle,
                  style: const TextStyle(color: muted, fontSize: 10),
                ),
              ],
            ),
          ),
          Icon(
            context.app.scheduled == selected
                ? Icons.check_circle
                : Icons.circle_outlined,
            color: context.app.scheduled == selected ? cyan : line,
            size: 23,
          ),
        ],
      ),
    ),
  );
}
