import 'package:flutter/material.dart';
import 'app_state.dart';

const cyan = Color(0xFF35CFF0);
const ink = Color(0xFF222B45);
const muted = Color(0xFF8F9BB3);
const pale = Color(0xFFF7F8FC);
const line = Color(0xFFEDF0F5);

ThemeData cargoTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: cyan,
    primary: cyan,
    onPrimary: Colors.white,
    surface: Colors.white,
  ),
  fontFamily: 'CargoSans',
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: ink, fontSize: 14),
    bodySmall: TextStyle(color: muted, fontSize: 12),
  ),
  dividerColor: line,
  dividerTheme: const DividerThemeData(color: line, thickness: 1),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(color: Color(0xFFADB3C0), fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: cyan),
    ),
  ),
);

class Asset extends StatelessWidget {
  const Asset(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });
  final String name;
  final double? width, height;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.png',
    width: width,
    height: height,
    fit: fit,
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.outline = false,
    this.height = 56,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool outline;
  final double height;
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(11),
      boxShadow: outline || onPressed == null
          ? []
          : [
              BoxShadow(
                color: cyan.withValues(alpha: .25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
    ),
    child: SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: outline ? Colors.white : cyan,
          foregroundColor: outline ? cyan : Colors.white,
          disabledBackgroundColor: cyan.withValues(alpha: .35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
            side: BorderSide(color: outline ? cyan : Colors.transparent),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

class PageShell extends StatelessWidget {
  const PageShell({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.action,
    this.bottom,
    this.close = false,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? action, bottom;
  final bool close;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Back',
                  onPressed: context.app.back,
                  icon: Icon(
                    close ? Icons.close : Icons.arrow_back,
                    color: ink,
                  ),
                ),
                const Spacer(),
                ?action,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
          if (bottom != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              child: bottom,
            ),
        ],
      ),
    ),
  );
}

class LabeledField extends StatefulWidget {
  const LabeledField(
    this.label, {
    super.key,
    this.hint,
    this.initial,
    this.onChanged,
    this.secret = false,
    this.keyboard,
    this.suffix,
    this.validator,
    this.maxLines = 1,
  });
  final String label;
  final String? hint, initial;
  final ValueChanged<String>? onChanged;
  final bool secret;
  final TextInputType? keyboard;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final int maxLines;
  @override
  State<LabeledField> createState() => _LabeledFieldState();
}

class _LabeledFieldState extends State<LabeledField> {
  bool hidden = true;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
        ],
        TextFormField(
          initialValue: widget.initial,
          onChanged: widget.onChanged,
          validator: widget.validator,
          obscureText: widget.secret && hidden,
          keyboardType: widget.keyboard,
          maxLines: widget.maxLines,
          style: const TextStyle(fontSize: 14, color: ink),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: widget.secret
                ? IconButton(
                    tooltip: 'Show password',
                    onPressed: () => setState(() => hidden = !hidden),
                    icon: Icon(
                      hidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: muted,
                    ),
                  )
                : widget.suffix,
          ),
        ),
      ],
    ),
  );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    ),
  );
}

class AppTile extends StatelessWidget {
  const AppTile(
    this.title, {
    super.key,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
  });
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: cyan, size: 22),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          trailing ?? const Icon(Icons.chevron_right, size: 20, color: muted),
        ],
      ),
    ),
  );
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.driver = false, this.size = 48});
  final bool driver;
  final double size;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(driver ? 9 : size),
    child: Asset(
      driver ? 'driver' : 'avatar',
      width: size,
      height: size,
      fit: BoxFit.cover,
    ),
  );
}

void showGallery(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.white,
  builder: (sheet) => SafeArea(
    child: SizedBox(
      height: MediaQuery.sizeOf(sheet).height * .85,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'CARGO · All 30 screens',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: AppPage.values
                  .map(
                    (page) => ListTile(
                      leading: Text(
                        page.number,
                        style: const TextStyle(color: cyan),
                      ),
                      title: Text(page.title),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(sheet);
                        context.go(page);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    ),
  ),
);
