import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/ui.dart';
import 'map_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => MapShell(
    route: false,
    onLocate: () => context.message('Centered on 874 Hildegard Crossing'),
    sheet: Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Material(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => context.go(AppPage.destination),
          borderRadius: BorderRadius.circular(10),
          child: const Padding(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(Icons.search, color: cyan, size: 20),
                SizedBox(width: 12),
                Text(
                  'Where are you going?',
                  style: TextStyle(color: muted, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class DestinationPage extends StatefulWidget {
  const DestinationPage({super.key});
  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  String query = '';
  static const suggestions = [
    SavedPlace('University of Washington', '056 Carole Mountains Apt. 567'),
    SavedPlace('Woodland Park', '371 Keshawn Knolls Suite 703'),
    SavedPlace('27 Sawayn Square', '27 Sawayn Square, Bryan, TX'),
    SavedPlace('Tiffany Park', '3890 Copperfield Dr, Bryan, TX'),
  ];
  @override
  Widget build(BuildContext context) => PageShell(
    title: '',
    close: true,
    child: Column(
      children: [
        Row(
          children: [
            const Column(
              children: [
                Icon(Icons.circle, color: cyan, size: 11),
                Text('⋮'),
                Icon(Icons.square, color: ink, size: 11),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '874 Hildegard Crossing',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Divider(height: 26),
                  TextField(
                    key: const Key('destination-input'),
                    onChanged: (v) => setState(() => query = v),
                    onSubmitted: (v) {
                      if (v.trim().isNotEmpty) {
                        context.app.destination = v;
                        context.go(AppPage.service);
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter Destination',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AppTile(
          'Pick on map',
          icon: Icons.map_outlined,
          onTap: () => context.go(AppPage.mapDestination),
        ),
        AppTile(
          'My favorites',
          icon: Icons.star_border,
          onTap: () => context.go(AppPage.favorites),
        ),
        const SizedBox(height: 16),
        ...suggestions
            .where(
              (p) => '${p.name} ${p.address}'.toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .map(
              (p) => AppTile(
                p.name,
                subtitle: p.address,
                icon: Icons.location_on_outlined,
                onTap: () {
                  context.app.destination = p.name;
                  context.go(AppPage.service);
                },
              ),
            ),
        if (query.isNotEmpty)
          AppTile(
            'Use “$query”',
            icon: Icons.add_location_alt_outlined,
            onTap: () {
              context.app.destination = query;
              context.go(AppPage.service);
            },
          ),
      ],
    ),
  );
}

class MapDestinationPage extends StatelessWidget {
  const MapDestinationPage({super.key});
  @override
  Widget build(BuildContext context) => MapShell(
    route: false,
    topBack: true,
    onLocate: () => context.message('Demo map centered'),
    sheet: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.location_on, size: 55, color: ink),
        const SizedBox(height: 110),
        PrimaryButton(
          'Set destination',
          onPressed: () {
            context.app.destination = '27 Sawayn Square';
            context.go(AppPage.service);
          },
        ),
        const SizedBox(height: 30),
      ],
    ),
  );
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
    title: 'My favorites',
    action: TextButton(
      onPressed: () => context.go(AppPage.addPlace),
      child: const Text('＋ Add'),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTile(
          'Home',
          icon: Icons.home_outlined,
          onTap: () => context.go(AppPage.addPlace),
        ),
        AppTile(
          'Work',
          icon: Icons.work_outline,
          onTap: () => context.go(AppPage.addPlace),
        ),
        const SectionLabel('Other places'),
        ...context.app.places.map(
          (p) => AppTile(
            p.name,
            subtitle: p.address,
            icon: Icons.location_on_outlined,
            onTap: () {
              context.app.destination = p.address;
              context.go(AppPage.service);
            },
          ),
        ),
      ],
    ),
  );
}

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});
  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final form = GlobalKey<FormState>();
  String name = 'Tiffany Park', address = '3890 Copperfield Dr, Bryan, TX';
  @override
  Widget build(BuildContext context) => PageShell(
    title: 'Add new place',
    child: Form(
      key: form,
      child: Column(
        children: [
          const SizedBox(height: 18),
          LabeledField(
            'Place name',
            initial: name,
            onChanged: (v) => name = v,
            validator: (v) => v!.trim().isEmpty ? 'Enter a place name' : null,
          ),
          LabeledField(
            'Place address',
            initial: address,
            onChanged: (v) => address = v,
            validator: (v) => v!.trim().isEmpty ? 'Enter an address' : null,
            suffix: IconButton(
              tooltip: 'Pick on map',
              onPressed: () => context.go(AppPage.mapDestination),
              icon: const Icon(Icons.map_outlined),
            ),
          ),
          const SizedBox(height: 46),
          PrimaryButton(
            'Save this place',
            onPressed: () {
              if (form.currentState!.validate()) {
                context.app.places.add(SavedPlace(name, address));
                context.go(AppPage.favorites);
              }
            },
          ),
        ],
      ),
    ),
  );
}

class ServicePage extends StatelessWidget {
  const ServicePage({super.key, this.full = false});
  final bool full;
  @override
  Widget build(BuildContext context) => MapShell(
    dim: full,
    onLocate: () => context.message('Centered on your route'),
    sheet: SheetPanel(
      onExpand: () => context.go(full ? AppPage.service : AppPage.serviceFull),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripRoute(onTap: () => context.go(AppPage.destination)),
          Row(
            children: [
              const Expanded(child: SectionLabel('Suggested rides')),
              IconButton(
                tooltip: full ? 'Compact view' : 'All rides',
                onPressed: () =>
                    context.go(full ? AppPage.service : AppPage.serviceFull),
                icon: Icon(
                  full ? Icons.expand_more : Icons.expand_less,
                  size: 20,
                  color: muted,
                ),
              ),
            ],
          ),
          if (full)
            ...List.generate(
              services.length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _RideOption(index: i, full: true),
              ),
            )
          else
            SizedBox(
              height: 118,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, i) =>
                    SizedBox(width: 94, child: _RideOption(index: i)),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => context.go(AppPage.payment),
                  child: Row(
                    children: [
                      const CardBrand(),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          context.app.cards[context.app.paymentIndex]
                              .split(' ')
                              .last,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Promo code',
                onPressed: () => context.go(AppPage.promo),
                icon: Icon(
                  Icons.discount_outlined,
                  color: context.app.promoApplied ? cyan : ink,
                  size: 19,
                ),
              ),
              IconButton(
                tooltip: 'All screens',
                onPressed: () => showGallery(context),
                icon: const Icon(Icons.more_horiz, size: 20),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  'BOOK NOW',
                  height: 46,
                  onPressed: context.app.book,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 46,
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: cyan),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    onPressed: () => context.go(AppPage.pickup),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: cyan,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (context.app.scheduled)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Scheduled · ${context.app.pickupTime.month}/${context.app.pickupTime.day} ${TimeOfDay.fromDateTime(context.app.pickupTime).format(context)}',
                style: const TextStyle(color: cyan, fontSize: 12),
              ),
            ),
        ],
      ),
    ),
  );
}

class _RideOption extends StatelessWidget {
  const _RideOption({required this.index, this.full = false});
  final int index;
  final bool full;
  @override
  Widget build(BuildContext context) {
    final service = services[index],
        selected = context.app.serviceIndex == index;
    final color = selected ? ink : ink;
    return InkWell(
      onTap: () => context.app.update(() => context.app.serviceIndex = index),
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? cyan : pale,
          borderRadius: BorderRadius.circular(9),
        ),
        child: full
            ? Row(
                children: [
                  Asset(service.asset, width: 78, height: 43),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                service.name,
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              'US\$${service.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: selected ? Colors.white : muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          service.description,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 9,
                            color: selected ? ink.withValues(alpha: .6) : muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Asset(service.asset, width: 78, height: 45),
                  const Spacer(),
                  Text(
                    service.name,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'US\$${service.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: selected ? Colors.white : muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CardBrand extends StatelessWidget {
  const CardBrand({super.key, this.master = false});
  final bool master;
  @override
  Widget build(BuildContext context) => master
      ? const SizedBox(
          width: 44,
          height: 26,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: Color(0xFFFE3030),
                ),
              ),
              Positioned(
                left: 17,
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: Color(0xFFFFB600),
                ),
              ),
            ],
          ),
        )
      : Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF1459D9),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Text(
            'VISA',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
}
