import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/ui.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        const Asset('splash', fit: BoxFit.cover),
        SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              GestureDetector(
                onLongPress: () => showGallery(context),
                child: const Asset('brand', width: 118, height: 175),
              ),
              const Spacer(flex: 7),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 36, 46),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        'Sign up',
                        height: 46,
                        onPressed: () => context.go(AppPage.signUp),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: OutlinedButton(
                          onPressed: () => context.go(AppPage.login),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Log in'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.page});
  final AppPage page;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  late String email, password, phone;
  @override
  void initState() {
    super.initState();
    final filled =
        widget.page == AppPage.signUpFilled || widget.page == AppPage.forgot;
    email = filled ? 'freeslab88@gmail.com' : '';
    password = filled ? 'cargo123' : '';
    phone = filled ? '080-744-5078' : '';
  }

  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized && widget.page != AppPage.signUpFilled) {
      if (context.app.email.isNotEmpty) email = context.app.email;
      if (context.app.phone.isNotEmpty) phone = context.app.phone;
      if (context.app.password.isNotEmpty) password = context.app.password;
    }
    initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final login = widget.page == AppPage.login;
    final forgot = widget.page == AppPage.forgot;
    final title = forgot
        ? 'Forgot your password'
        : login
        ? 'Welcome back, Guy!'
        : 'Create your account';
    return PageShell(
      title: title,
      subtitle: forgot
          ? 'Please enter your email address below to receive your password reset instructions.'
          : login
          ? 'Sign in to your account'
          : null,
      child: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!forgot && !login) ...[
              Row(
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
                  InkWell(
                    onTap: () => context.go(AppPage.login),
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: cyan, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ] else
              const SizedBox(height: 12),
            LabeledField(
              'Email',
              initial: email,
              hint: 'Enter your email',
              keyboard: TextInputType.emailAddress,
              onChanged: (v) {
                email = v;
                context.app.email = v;
              },
              validator: (v) =>
                  v != null && RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)
                  ? null
                  : 'Enter a valid email address',
            ),
            if (!forgot)
              LabeledField(
                'Password',
                initial: password,
                hint: 'Enter your password',
                secret: true,
                onChanged: (v) {
                  password = v;
                  context.app.password = v;
                },
                validator: (v) =>
                    (v?.length ?? 0) >= 6 ? null : 'Use at least 6 characters',
              ),
            if (!forgot && !login) ...[
              const Text(
                'Phone number',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 52,
                    child: TextButton(
                      onPressed: () => context.go(AppPage.country),
                      child: Text(
                        context.app.country,
                        style: const TextStyle(color: ink),
                      ),
                    ),
                  ),
                  Expanded(
                    child: LabeledField(
                      '',
                      hint: 'Mobile number',
                      initial: phone,
                      keyboard: TextInputType.phone,
                      onChanged: (v) {
                        phone = v;
                        context.app.phone = v;
                      },
                      validator: (v) =>
                          (v?.replaceAll(RegExp(r'\D'), '').length ?? 0) >= 6
                          ? null
                          : 'Enter your phone number',
                    ),
                  ),
                ],
              ),
            ],
            if (login)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go(AppPage.forgot),
                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(color: cyan, fontSize: 13),
                  ),
                ),
              ),
            const SizedBox(height: 26),
            PrimaryButton(
              forgot
                  ? 'Sent'
                  : login
                  ? 'Sign in'
                  : 'Sign up',
              onPressed: () {
                if (!form.currentState!.validate()) return;
                context.app.email = email;
                context.app.password = password;
                context.app.phone = phone;
                if (forgot) {
                  context.message('Password reset instructions sent (demo).');
                  context.go(AppPage.login);
                } else {
                  context.go(login ? AppPage.home : AppPage.verify);
                }
              },
            ),
            if (forgot) ...[
              const SizedBox(height: 44),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppPage.login),
                  child: const Text('Back to Sign in'),
                ),
              ),
            ] else ...[
              SizedBox(height: login ? 112 : 52),
              Center(
                child: Text(
                  'Or sign ${login ? 'in' : 'up'} with social account',
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
              ),
              const SizedBox(height: 28),
              const SocialButtons(),
              const SizedBox(height: 32),
              Center(
                child: login
                    ? TextButton(
                        onPressed: () => context.go(AppPage.signUp),
                        child: const Text(
                          "Don’t have an account? Sign up",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : const Text(
                        'By clicking “Sign Up” you agree to our terms and conditions as well as our privacy policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, height: 1.6),
                      ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key, this.vertical = false});
  final bool vertical;
  @override
  Widget build(BuildContext context) {
    Widget button(String label, Color color, Widget icon) => SizedBox(
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        onPressed: () =>
            context.message('$label sign-in is a demo. Please use email.'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              vertical ? 'Connect with $label' : label,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
    final fb = button(
      'Facebook',
      const Color(0xFF405D9B),
      const Icon(Icons.facebook, color: Colors.white, size: 22),
    );
    final tw = button(
      'Twitter',
      cyan,
      const Asset('twitter', width: 22, height: 22),
    );
    return vertical
        ? Column(children: [fb, const SizedBox(height: 12), tw])
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: fb),
                const SizedBox(width: 20),
                Expanded(child: tw),
              ],
            ),
          );
  }
}

class CountryPage extends StatefulWidget {
  const CountryPage({super.key});
  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  String query = '';
  static const countries = [
    ('Afghanistan', '+93', '🇦🇫'),
    ('Albania', '+355', '🇦🇱'),
    ('Algeria', '+213', '🇩🇿'),
    ('American samoa', '+1684', '🇦🇸'),
    ('Andorra', '+376', '🇦🇩'),
    ('Angola', '+244', '🇦🇴'),
    ('Anguilla', '+1264', '🇦🇮'),
    ('Antarctica', '+6721', '🇦🇶'),
    ('Antigua & Barbuda', '+1268', '🇦🇬'),
    ('Argentina', '+54', '🇦🇷'),
    ('Armenia', '+374', '🇦🇲'),
    ('Australia', '+61', '🇦🇺'),
    ('China', '+86', '🇨🇳'),
    ('Japan', '+81', '🇯🇵'),
    ('United Kingdom', '+44', '🇬🇧'),
    ('United States', '+1', '🇺🇸'),
  ];
  @override
  Widget build(BuildContext context) => PageShell(
    title: 'Select a country',
    child: Column(
      children: [
        TextField(
          onChanged: (v) => setState(() => query = v),
          decoration: const InputDecoration(
            hintText: 'Search for a country',
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: line,
          ),
        ),
        const SizedBox(height: 24),
        ...countries
            .where(
              (c) =>
                  '${c.$1} ${c.$2}'.toLowerCase().contains(query.toLowerCase()),
            )
            .map(
              (c) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: c.$1,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: ' (${c.$2})',
                        style: const TextStyle(color: muted),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  context.app.update(
                    () => context.app.country = '${c.$3} ${c.$2}',
                  );
                  context.app.back();
                },
              ),
            ),
      ],
    ),
  );
}

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});
  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final digits = List.filled(4, '');
  final focus = List.generate(4, (_) => FocusNode());
  @override
  void dispose() {
    for (final node in focus) {
      node.dispose();
    }
    super.dispose();
  }

  bool resent = false;
  @override
  Widget build(BuildContext context) => PageShell(
    title: 'Verify phone number',
    subtitle:
        'Check your SMS messages. We’ve sent you the PIN at ${context.app.country} ${context.app.phone.isEmpty ? '080-744-5078' : context.app.phone}',
    child: Column(
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (i) => SizedBox(
              width: 64,
              height: 64,
              child: TextField(
                key: Key('verification-$i'),
                focusNode: focus[i],
                maxLength: 1,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: '3247'[i],
                  hintStyle: const TextStyle(
                    fontSize: 32,
                    color: ink,
                    fontWeight: FontWeight.bold,
                  ),
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: cyan),
                  ),
                ),
                onChanged: (value) {
                  digits[i] = value;
                  if (value.isNotEmpty && i < 3) focus[i + 1].requestFocus();
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
        PrimaryButton(
          'Verify',
          onPressed: () {
            if (digits.join() != '3247') {
              context.message('Enter the demo PIN: 3247');
              return;
            }
            context.go(AppPage.location);
          },
        ),
        const SizedBox(height: 36),
        TextButton(
          onPressed: () {
            setState(() => resent = true);
            context.message('Demo code resent: 3247');
          },
          child: Text(
            resent ? 'Code resent · 3247' : 'Didn’t receive SMS? Resend Code',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => context.go(AppPage.home),
              icon: const Icon(Icons.close),
            ),
          ),
          const Spacer(),
          const Asset('location', width: 226, height: 226),
          const SizedBox(height: 48),
          const Text(
            'Enable Location',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(40, 14, 40, 0),
            child: Text(
              'Choose your location to start find the request around you.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 13, height: 1.6),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryButton(
              'Allow access',
              onPressed: () {
                context.go(AppPage.home);
                context.message('Using the design’s demo location.');
              },
            ),
          ),
          const SizedBox(height: 28),
          TextButton(
            onPressed: () => context.go(AppPage.home),
            child: const Text('Skip for now', style: TextStyle(fontSize: 12)),
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}
