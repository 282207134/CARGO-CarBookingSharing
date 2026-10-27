import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/ui.dart';
import '../auth/auth_pages.dart';
import '../booking/map_view.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const Positioned.fill(child: MapView(route: true)),
        Positioned.fill(
          child: GestureDetector(
            onTap: context.app.back,
            child: Container(color: ink.withValues(alpha: .35)),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.sizeOf(context).width * .77,
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 35, 22, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => context.go(AppPage.profile),
                      child: Row(
                        children: [
                          const Avatar(size: 60),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.app.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  'Edit profile',
                                  style: TextStyle(color: cyan, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    const Divider(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _item(
                              context,
                              'Your trips',
                              () => context.go(AppPage.trips),
                            ),
                            _item(
                              context,
                              'Payment',
                              () => context.go(AppPage.payment),
                            ),
                            _item(
                              context,
                              'Notifications',
                              () => _info(
                                context,
                                'Notifications',
                                'Your driver updates will appear here. No new notifications.',
                              ),
                            ),
                            _item(
                              context,
                              'Promos',
                              () => context.go(AppPage.promo),
                            ),
                            _item(
                              context,
                              'Help',
                              () => _info(
                                context,
                                'How can we help?',
                                'Choose a destination, select a ride and tap BOOK NOW. This build uses local demo data.',
                              ),
                            ),
                            _item(
                              context,
                              'Free trips',
                              () => _info(
                                context,
                                'Invite friends',
                                'Demo invite code: CARGO-TRAVIS',
                              ),
                            ),
                            _item(
                              context,
                              'Settings',
                              () => context.go(AppPage.profile),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => showGallery(context),
                      child: const Text(
                        'All 30 screens',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: context.app.logout,
                      style: TextButton.styleFrom(foregroundColor: muted),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  Widget _item(BuildContext context, String label, VoidCallback onTap) =>
      SizedBox(
        height: 55,
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: ink,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
  void _info(BuildContext context, String title, String body) =>
      showDialog<void>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog),
              child: const Text('Done'),
            ),
          ],
        ),
      );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => MapShell(
    dim: true,
    sheet: SheetPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Avatar(size: 60),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.app.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      '${context.app.country} ${context.app.phone.isEmpty ? '080-744-5078' : context.app.phone}',
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit profile',
                onPressed: () => _edit(context),
                icon: const Icon(Icons.edit_outlined, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionLabel('Favourites'),
          AppTile(
            'Add home',
            icon: Icons.home_outlined,
            onTap: () => context.go(AppPage.addPlace),
          ),
          AppTile(
            'Add work',
            icon: Icons.work_outline,
            onTap: () => context.go(AppPage.addPlace),
          ),
          const SectionLabel('Settings'),
          AppTile(
            'Notifications',
            trailing: Switch.adaptive(
              value: context.app.notifications,
              activeTrackColor: cyan,
              onChanged: (v) =>
                  context.app.update(() => context.app.notifications = v),
            ),
          ),
          AppTile('Payment Method', onTap: () => context.go(AppPage.payment)),
          AppTile('My Rewards', onTap: () => context.go(AppPage.promo)),
          const SectionLabel('Social network'),
          const SocialButtons(vertical: true),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
  void _edit(BuildContext context) {
    var name = context.app.name;
    showDialog<void>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Edit profile'),
        content: TextFormField(
          initialValue: name,
          onChanged: (v) => name = v,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (name.trim().isEmpty) return;
              context.app.update(() => context.app.name = name.trim());
              Navigator.pop(dialog);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class TripsPage extends StatefulWidget {
  const TripsPage({super.key, this.initialTab = 0});
  final int initialTab;
  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  late int tab = widget.initialTab;
  @override
  Widget build(BuildContext context) {
    final state = context.app;
    final status = ['Upcoming', 'Complete', 'Canceled'][tab];
    final actual = state.trips.where((t) => t.status == status).toList();
    if (tab == 0 && state.bookingStatus != null) {
      actual.insert(0, TripRecord(state.destination, state.fare, 'Upcoming'));
    }
    final demo = state.trips.isEmpty && state.bookingStatus == null;
    final trips = demo && tab != 2
        ? [
            const TripRecord('27 Sawayn Square', 35.5, 'Complete'),
            const TripRecord('501 Ortiz Cove Suite 961', 17.02, 'Complete'),
          ]
        : actual;
    return PageShell(
      title: 'My Trips',
      action: const Padding(
        padding: EdgeInsets.only(right: 12),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 14, color: muted),
            SizedBox(width: 8),
            Text(
              'Your trip history',
              style: TextStyle(fontSize: 11, color: muted),
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: InkWell(
                  onTap: () => setState(() {
                    tab = i;
                    context.app.tripTab = i;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: tab == i ? cyan : line,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      ['UPCOMING', 'COMPLETE', 'CANCELED'][i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: tab == i ? cyan : muted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (demo)
            const Padding(
              padding: EdgeInsets.only(top: 14),
              child: Text(
                'Sample trips · start a booking to create your own',
                style: TextStyle(color: muted, fontSize: 10),
              ),
            ),
          const SizedBox(height: 24),
          if (trips.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 85),
              child: Column(
                children: [
                  const Icon(Icons.route, color: cyan, size: 52),
                  const SizedBox(height: 20),
                  Text(
                    'No ${status.toLowerCase()} trips yet',
                    style: const TextStyle(color: muted),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    'Book a ride',
                    onPressed: () => context.go(AppPage.home),
                  ),
                ],
              ),
            ),
          for (var i = 0; i < trips.length; i++) _trip(context, trips[i], i),
        ],
      ),
    );
  }

  Widget _trip(BuildContext context, TripRecord trip, int index) => Padding(
    padding: const EdgeInsets.only(bottom: 26),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          index == 0 ? 'Today, 08:30 AM' : 'Today, 07:25 AM',
          style: const TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            context.app.destination = trip.destination;
            context.go(
              trip.status == 'Upcoming' ? AppPage.driver : AppPage.rating,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: pale,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: cyan),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        '874 Hildegard Crossing',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '7:15 PM',
                      style: TextStyle(color: muted, fontSize: 9),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('⋮', style: TextStyle(color: muted)),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.square, size: 9, color: ink),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        trip.destination,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Text(
                      '9:30 PM',
                      style: TextStyle(color: muted, fontSize: 9),
                    ),
                  ],
                ),
                const Divider(height: 30),
                Row(
                  children: [
                    const Avatar(driver: true, size: 35),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index == 0 ? 'Evan Guzman' : 'Johnny Erickson',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '★ 4.8',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFFFFBC00),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          trip.status == 'Canceled'
                              ? 'Cancel fee'
                              : 'Final cost',
                          style: const TextStyle(color: muted, fontSize: 9),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'US\$${trip.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      children: [
                        Text(
                          'Arrival time',
                          style: TextStyle(color: muted, fontSize: 9),
                        ),
                        SizedBox(height: 7),
                        Text(
                          '45:05',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
