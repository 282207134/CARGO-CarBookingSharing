import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/ui.dart';

class MapView extends StatelessWidget {
  const MapView({super.key, this.route = false});
  final bool route;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final scale = box.maxWidth / 375;
      return ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: route ? -19 * scale : 0,
              top: route ? -37 * scale : -517 * scale,
              width: (route ? 908 : 945) * scale,
              height: (route ? 882 : 1329) * scale,
              child: Asset(route ? 'map-route' : 'map-home', fit: BoxFit.fill),
            ),
            if (route)
              Positioned(
                left: 0,
                top: 0,
                width: box.maxWidth,
                height: 812 * scale,
                child: CustomPaint(painter: RoutePainter()),
              ),
            for (final car
                in route
                    ? [
                        (173.0, 65.0, .1),
                        (105.0, 207.0, 1.3),
                        (260.0, 191.0, 1.4),
                        (172.0, 355.0, .1),
                        (303.0, 259.0, 1.4),
                      ]
                    : <(double, double, double)>[])
              Positioned(
                left: car.$1 * scale,
                top: car.$2 * scale,
                child: Transform.rotate(
                  angle: car.$3,
                  child: const Icon(Icons.directions_car, size: 20, color: ink),
                ),
              ),
            Positioned(
              left: (route ? 115 : 170) * scale,
              top: (route ? 99 : 360) * scale,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: cyan,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: cyan.withValues(alpha: .35),
                      blurRadius: 8,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: (route ? 194 : 76) * scale,
              top: (route ? 203 : 295) * scale,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                elevation: 5,
                shadowColor: Colors.black26,
                child: InkWell(
                  onTap: () =>
                      context.go(route ? AppPage.service : AppPage.destination),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          route ? Icons.flag : Icons.directions_walk,
                          color: ink,
                          size: 21,
                        ),
                        const SizedBox(width: 9),
                        SizedBox(
                          width: route ? 108 : 112,
                          child: Text(
                            route ? context.app.destination : '874 Hildegard…',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: muted, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (route)
              Positioned(
                left: 241 * scale,
                top: 281 * scale,
                child: Container(
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    color: ink,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            const Positioned(
              bottom: 3,
              right: 4,
              child: Text(
                'Map imagery from Pixso reference',
                style: TextStyle(fontSize: 8, color: Color(0xFF66727A)),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 375);
    final path = Path()
      ..moveTo(127, 111)
      ..lineTo(124, 151)
      ..lineTo(151, 159)
      ..lineTo(164, 340)
      ..lineTo(245, 325)
      ..lineTo(250, 290);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFF9298).withValues(alpha: .4)
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFF737D)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(RoutePainter oldDelegate) => false;
}

class MapShell extends StatelessWidget {
  const MapShell({
    super.key,
    this.route = true,
    this.dim = false,
    this.sheet,
    this.header,
    this.topBack = false,
    this.onLocate,
  });
  final bool route, dim, topBack;
  final Widget? sheet, header;
  final VoidCallback? onLocate;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Positioned.fill(child: MapView(route: route)),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (header != null)
                  Expanded(child: header!)
                else
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: IconButton(
                      tooltip: topBack ? 'Back' : 'Menu',
                      onPressed: topBack
                          ? context.app.back
                          : () => context.go(AppPage.menu),
                      icon: Icon(
                        topBack ? Icons.arrow_back : Icons.menu,
                        color: ink,
                        size: 22,
                      ),
                    ),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.go(AppPage.profile),
                  child: const Avatar(),
                ),
              ],
            ),
          ),
        ),
        if (onLocate != null)
          Positioned(
            right: 18,
            top: math.max(160, MediaQuery.sizeOf(context).height * .39),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              elevation: 3,
              child: IconButton(
                tooltip: 'Current location',
                onPressed: onLocate,
                icon: const Icon(Icons.near_me, color: ink),
              ),
            ),
          ),
        if (dim)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: ColoredBox(color: ink.withValues(alpha: .32)),
            ),
          ),
        if (sheet != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: sheet!,
            ),
          ),
      ],
    ),
  );
}

class SheetPanel extends StatelessWidget {
  const SheetPanel({
    super.key,
    required this.child,
    this.onExpand,
    this.maxHeight,
  });
  final Widget child;
  final VoidCallback? onExpand;
  final double? maxHeight;
  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(
      maxHeight: maxHeight ?? MediaQuery.sizeOf(context).height * .86,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, -4)),
      ],
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onExpand,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              height: 26,
              width: double.infinity,
              child: Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            child: child,
          ),
        ],
      ),
    ),
  );
}

class TripRoute extends StatelessWidget {
  const TripRoute({super.key, this.detailed = false, this.onTap});
  final bool detailed;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final names = [
      '874 Hildegard Crossing',
      if (detailed) ...['Picking up Selena', 'Dropping off Selena'],
      context.app.destination,
    ];
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          for (var i = 0; i < names.length; i++)
            SizedBox(
              height: 43,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Column(
                      children: [
                        Container(
                          width: i == 0 ? 10 : 9,
                          height: i == 0 ? 10 : 9,
                          decoration: BoxDecoration(
                            color: i == 0 ? cyan : ink,
                            borderRadius: BorderRadius.circular(
                              i == 0 ? 10 : 0,
                            ),
                          ),
                        ),
                        if (i < names.length - 1)
                          const Expanded(
                            child: Text(
                              '⋮',
                              style: TextStyle(
                                fontSize: 22,
                                height: 1,
                                color: muted,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      names[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: i == 0 || i == names.length - 1
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (detailed)
                    Text(
                      i == 0
                          ? '7:15 PM'
                          : i == names.length - 1
                          ? '9:30 PM'
                          : i == 1
                          ? 'Pick-up'
                          : 'Drop-off',
                      style: const TextStyle(color: muted, fontSize: 10),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
