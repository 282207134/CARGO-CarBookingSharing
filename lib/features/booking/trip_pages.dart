import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/ui.dart';
import 'booking_pages.dart';
import 'map_view.dart';

class ProcessingPage extends StatelessWidget {
  const ProcessingPage({super.key});
  @override
  Widget build(BuildContext context) => MapShell(
    dim: true,
    sheet: SheetPanel(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(color: cyan, strokeWidth: 3),
          ),
          const SizedBox(height: 28),
          const Text(
            'WE ARE PROCESSING YOUR BOOKING…',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          const Text(
            'Your ride will start soon',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            'Track driver',
            height: 44,
            onPressed: () => context.go(AppPage.driver),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: context.app.cancelRide,
            child: const Text('Cancel booking', style: TextStyle(color: muted)),
          ),
        ],
      ),
    ),
  );
}

class DriverPage extends StatelessWidget {
  const DriverPage({super.key, required this.page});
  final AppPage page;
  @override
  Widget build(BuildContext context) {
    final expanded = page != AppPage.driver,
        payment = page == AppPage.driverPayment;
    return MapShell(
      dim: expanded,
      sheet: SheetPanel(
        onExpand: () =>
            context.go(expanded ? AppPage.driver : AppPage.driverFull),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Your driver is coming in 2:35',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(AppPage.cancel),
                  child: const Text(
                    'Cancel ride',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            const DriverInfo(),
            const SizedBox(height: 16),
            if (expanded) ...[
              if (!payment) ...[
                const SectionLabel('Passengers'),
                const AppTile(
                  'You',
                  subtitle: '2 passengers',
                  trailing: Avatar(size: 36),
                ),
                const AppTile(
                  'Selena',
                  subtitle: '1 passenger',
                  icon: Icons.person_outline,
                  trailing: SizedBox.shrink(),
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Icon(Icons.info, size: 20, color: muted),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You’re sharing your ride with others going your way. Other passengers may be added.',
                        style: TextStyle(
                          color: muted,
                          fontSize: 10,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Expanded(child: SectionLabel('Trip')),
                  TextButton(
                    onPressed: () => context.go(AppPage.destination),
                    child: const Text(
                      'Edit ride',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
              const TripRoute(detailed: true),
              if (payment) ...[
                const SectionLabel('Payment'),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.app.fareLabel,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.message(
                        'Demo split: ${context.app.fare / 2} per passenger.',
                      ),
                      child: const Text('Split cost'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => context.go(AppPage.payment),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: cyan),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CardBrand(master: context.app.paymentIndex == 0),
                        const SizedBox(width: 12),
                        Text(
                          context.app.cards[context.app.paymentIndex],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
            ],
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    'MESSAGE',
                    height: 44,
                    onPressed: () => _messageDriver(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    'CALL',
                    height: 44,
                    outline: true,
                    onPressed: () =>
                        context.message('Demo driver: +1 555 010 2048'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context.go(
                    payment ? AppPage.driverFull : AppPage.driverPayment,
                  ),
                  child: Text(
                    payment ? 'Passengers' : 'Trip & payment',
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(AppPage.rating),
                  child: const Text(
                    'Finish demo trip →',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _messageDriver(BuildContext context) {
    var text = '';
    showDialog<void>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Message Evan'),
        content: TextField(
          onChanged: (v) => text = v,
          decoration: const InputDecoration(
            hintText: 'I’m at the pick-up point…',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialog);
              context.message(
                text.trim().isEmpty
                    ? 'Enter a message first.'
                    : 'Demo message saved: $text',
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

class DriverInfo extends StatelessWidget {
  const DriverInfo({super.key, this.summary = false});
  final bool summary;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Avatar(driver: true, size: 45),
      const SizedBox(width: 12),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evan Guzman',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            SizedBox(height: 5),
            Text(
              '★ 4.8',
              style: TextStyle(color: Color(0xFFFFBA00), fontSize: 11),
            ),
            SizedBox(height: 3),
            Text('⌖ 3 mins', style: TextStyle(color: muted, fontSize: 10)),
          ],
        ),
      ),
      if (summary)
        Column(
          children: [
            const Text(
              'Final cost',
              style: TextStyle(color: muted, fontSize: 9),
            ),
            const SizedBox(height: 5),
            Text(
              context.app.fareLabel,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
            ),
            const Text('45:05', style: TextStyle(color: muted, fontSize: 10)),
          ],
        )
      else
        const Column(
          children: [
            Asset('driver-car', width: 78, height: 40),
            SizedBox(height: 4),
            Text(
              'Toyota Vios · 8CF4829',
              style: TextStyle(color: muted, fontSize: 9),
            ),
          ],
        ),
    ],
  );
}

class CancelPage extends StatelessWidget {
  const CancelPage({super.key});
  @override
  Widget build(BuildContext context) => MapShell(
    dim: true,
    sheet: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SheetPanel(
          child: Column(
            children: [
              const SizedBox(height: 14),
              const Icon(
                Icons.warning_rounded,
                color: Color(0xFFFFB800),
                size: 74,
              ),
              const SizedBox(height: 24),
              const Text(
                'CANCEL THIS RIDE?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you want to cancel this ride?\nA US\$2 fee applies',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, height: 1.7, fontSize: 13),
              ),
              const SizedBox(height: 34),
              PrimaryButton(
                'CANCEL RIDE (US\$ 2 FEE)',
                height: 46,
                onPressed: () {
                  context.app.cancelRide();
                  context.message(
                    'Ride canceled. Demo cancellation fee: US\$2.',
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: ink,
              padding: const EdgeInsets.all(19),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => context.go(AppPage.driver),
            child: const Text('Don’t cancel ride'),
          ),
        ),
      ],
    ),
  );
}

class RatingPage extends StatelessWidget {
  const RatingPage({super.key, this.tip = false});
  final bool tip;
  @override
  Widget build(BuildContext context) => MapShell(
    sheet: SheetPanel(
      child: Column(
        children: [
          Row(
            children: [
              if (tip)
                IconButton(
                  onPressed: () => context.go(AppPage.rating),
                  icon: const Icon(Icons.arrow_back, size: 19),
                )
              else
                const SizedBox(width: 40),
              Expanded(
                child: Text(
                  tip ? 'AWESOME !' : 'YOU ARRIVED',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Close',
                onPressed: () => context.go(AppPage.home),
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!tip) ...[
            const DriverInfo(summary: true),
            const SizedBox(height: 18),
            const Align(
              alignment: Alignment.centerLeft,
              child: SectionLabel('Trip'),
            ),
            const TripRoute(),
            const SizedBox(height: 36),
            const Text(
              'HOW IS YOUR TRIP?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your feedback will help us improve driving experience better.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 24),
          ] else ...[
            Text(
              'You rated Evan ${context.app.stars} stars',
              style: const TextStyle(color: muted, fontSize: 13),
            ),
            const SizedBox(height: 22),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 48,
                  height: 48,
                ),
                tooltip: '${i + 1} stars',
                onPressed: () {
                  context.app.update(() => context.app.stars = i + 1);
                  if (!tip) context.go(AppPage.tip);
                },
                icon: Icon(
                  Icons.star_rounded,
                  color: tip && i < context.app.stars
                      ? const Color(0xFFFFB600)
                      : const Color(0xFFE4E7EE),
                  size: 39,
                ),
              ),
            ),
          ),
          if (tip) ...[
            const SizedBox(height: 22),
            TextFormField(
              initialValue: context.app.feedback,
              onChanged: (v) => context.app.feedback = v,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Say something about Evan service?',
                filled: true,
                fillColor: pale,
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Add a tip for Evan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                for (final value in [1.0, 2.0, 3.0, 5.0])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: context.app.tip == value
                              ? cyan
                              : ink,
                          side: BorderSide(
                            color: context.app.tip == value ? cyan : line,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            context.app.update(() => context.app.tip = value),
                        child: Text(
                          'US\$${value.toInt()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _customTip(context),
              child: const Text(
                'Enter custom amount',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              'Submit',
              onPressed: () {
                context.app.completeRide();
                context.message(
                  'Thanks for your feedback. Tip: US\$${context.app.tip.toStringAsFixed(2)}',
                );
              },
            ),
          ] else
            const SizedBox(height: 20),
        ],
      ),
    ),
  );
  void _customTip(BuildContext context) {
    var amount = '';
    showDialog<void>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Custom tip'),
        content: TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (v) => amount = v,
          decoration: const InputDecoration(prefixText: 'US\$ '),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(amount);
              if (value == null ||
                  !value.isFinite ||
                  value < 0 ||
                  value > 500) {
                context.message('Enter an amount between 0 and 500.');
                return;
              }
              context.app.update(() => context.app.tip = value);
              Navigator.pop(dialog);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
