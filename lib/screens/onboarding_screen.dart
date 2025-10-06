import 'package:flutter/material.dart';
import '../theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  void _next() {
    if (_index < 3) {
      _page.nextPage(
          duration: const Duration(milliseconds: 320), curve: Curves.easeOut);
    }
  }

  void _goLogin() => Navigator.pushReplacementNamed(context, '/login');
  void _goSignup() => Navigator.pushReplacementNamed(context, '/signup');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C3930), Color(0xFF3F4F44)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                child: Row(
                  children: [
                    const Text('PWC Tracker',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .3,
                        )),
                    const Spacer(),
                    TextButton(
                      onPressed: _goLogin,
                      child: const Text('Skip',
                          style: TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
              ),

              // pages
              Expanded(
                child: PageView(
                  controller: _page,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: const [
                    _OnboardPage(
                      title: 'Quick check-in',
                      message:
                          'Students are detected at campus entry points—no manual scanning needed.',
                      art: _CheckinArt(),
                    ),
                    _OnboardPage(
                      title: 'Live zone view',
                      message:
                          'See where a student is in real time: room, library, or activity area.',
                      art: _MapArt(),
                    ),
                    _OnboardPage(
                      title: 'Smart alerts',
                      message:
                          'Get friendly notifications on arrivals, zone changes, and dismissals.',
                      art: _AlertArt(),
                    ),
                    _OnboardPage(
                      title: 'Parent access',
                      message:
                          'Parents can securely check the current zone anytime for peace of mind.',
                      art: _AccountArt(),
                    ),
                  ],
                ),
              ),

              // dots + CTA(s)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Row(
                  children: [
                    _Dots(count: 4, index: _index),
                    const Spacer(),
                    if (_index < 3)
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.clay, // #A27B5C
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                          ),
                          child: const Text('Continue',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      )
                    else
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: _goSignup,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 14),
                            ),
                            child: const Text('Sign up'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _goLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.clay,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                            ),
                            child: const Text('Login',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------- shared widgets ---------- */

class _Dots extends StatelessWidget {
  final int count;
  final int index;
  const _Dots({required this.count, required this.index});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(right: 8),
          height: 10,
          width: active ? 28 : 10,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final String title;
  final String message;
  final Widget art;
  const _OnboardPage(
      {required this.title, required this.message, required this.art});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.95),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: art,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: .2,
              )),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

/* ---------- simple vector-ish arts to match the style ---------- */

class _BackdropCircle extends StatelessWidget {
  const _BackdropCircle();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Palette.sand.withOpacity(.95), Colors.white],
          radius: .8,
        ),
      ),
    );
  }
}

class _Platform extends StatelessWidget {
  const _Platform();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }
}

class _GatePillar extends StatelessWidget {
  const _GatePillar();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Icon(Icons.sensors, color: Palette.forest, size: 18),
    );
  }
}

class _CheckinArt extends StatelessWidget {
  const _CheckinArt();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const _BackdropCircle(),
          const Positioned(bottom: 32, child: _Platform()),
          Transform.rotate(
            angle: -.15,
            child: Container(
              width: 160,
              height: 96,
              decoration: BoxDecoration(
                color: Palette.clay,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Palette.clay.withOpacity(.35),
                      blurRadius: 18,
                      offset: const Offset(0, 10))
                ],
              ),
              child: const Icon(Icons.badge, color: Colors.white, size: 46),
            ),
          ),
          const Positioned(left: 28, bottom: 44, child: _GatePillar()),
          const Positioned(right: 28, bottom: 44, child: _GatePillar()),
        ],
      ),
    );
  }
}

class _MapArt extends StatelessWidget {
  const _MapArt();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const _BackdropCircle(),
          const Positioned(bottom: 28, child: _Platform()),
          Positioned(
            bottom: 68,
            child: Container(
              width: 140,
              height: 76,
              decoration: BoxDecoration(
                  color: Palette.sand, borderRadius: BorderRadius.circular(18)),
            ),
          ),
          Positioned(
            bottom: 96,
            child: Container(
              width: 110,
              height: 54,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const Icon(Icons.location_pin, color: Palette.forest, size: 64),
        ],
      ),
    );
  }
}

class _AlertArt extends StatelessWidget {
  const _AlertArt();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const _BackdropCircle(),
          const Positioned(bottom: 28, child: _Platform()),
          Transform.translate(
            offset: const Offset(-34, -8),
            child: Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: CustomPaint(
                  painter: _GraphPainter(), child: const SizedBox.expand()),
            ),
          ),
          Transform.translate(
            offset: const Offset(70, -4),
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                  color: Palette.clay, shape: BoxShape.circle),
              child: const Icon(Icons.notifications_none,
                  color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountArt extends StatelessWidget {
  const _AccountArt();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const _BackdropCircle(),
          const Positioned(bottom: 28, child: _Platform()),
          Container(
            width: 150,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 14)
              ],
            ),
            child: const Icon(Icons.verified_user,
                color: Palette.forest, size: 40),
          ),
          Positioned(
            right: 40,
            top: 24,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Palette.clay, shape: BoxShape.circle),
              child: const Icon(Icons.lock_open, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Palette.forest
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    final path = Path()
      ..moveTo(8, size.height * .7)
      ..cubicTo(size.width * .25, size.height * .5, size.width * .45,
          size.height * .9, size.width * .62, size.height * .55)
      ..cubicTo(size.width * .78, size.height * .25, size.width * .9,
          size.height * .55, size.width - 8, size.height * .35);
    canvas.drawPath(path, p);

    canvas.drawCircle(Offset(size.width - 10, size.height * .35), 4.8,
        Paint()..color = Palette.clay);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
