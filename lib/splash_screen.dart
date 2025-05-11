import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late List<Particle> _particles;

  void _initializeParticles(Size size) {
    _particles = List.generate(
      45, // Increased for more particles
      (index) => Particle(
        position: Offset(
          math.Random().nextDouble() * size.width,
          math.Random().nextDouble() * size.height,
        ),
        speed: math.Random().nextDouble() * 1.0 + 0.5,
        radius: math.Random().nextDouble() * 2 + 0.5,
        opacity: math.Random().nextDouble() * 0.5 + 0.1,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _initializeParticles(size); // Initialize particles with actual screen size

    return Scaffold(
      backgroundColor: const Color(0xFF0A1F15),
      body: Stack(
        children: [
          // Animated particles
          CustomPaint(
            painter: ParticlePainter(
              particles: _particles,
              color: Colors.white.withOpacity(0.1),
            ),
            size: MediaQuery.of(context).size,
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                letterSpacing: 1.5,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Eco',
                                  style: TextStyle(
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: [Colors.white, Color(0xFF64FFDA)],
                                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                  ),
                                ),
                                TextSpan(
                                  text: 'Mind',
                                  style: TextStyle(
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: [Color(0xFF64FFDA), Color(0xFF1DE9B6)],
                                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                // Modern loading indicator
                SizedBox(
                  width: 160,
                  child: LoadingIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Particle {
  Offset position;
  final double speed;
  final double radius;
  final double opacity; // Added opacity property

  Particle({
    required this.position,
    required this.speed,
    required this.radius,
    required this.opacity,
  });

  void update(Size size) {
    // Add slight horizontal movement
    position = Offset(
      (position.dx + math.sin(position.dy / 30) * 0.5) % size.width,
      (position.dy + speed) % size.height,
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;

  ParticlePainter({required this.particles, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update(size);
      final paint = Paint()
        ..color = color.withOpacity(particle.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LoadingIndicator extends StatefulWidget {
  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Match total loading time
    );

    _progressAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.3)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.3, end: 0.6)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.6, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30.0,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF64FFDA).withOpacity(0.2),
                blurRadius: 16,
                spreadRadius: -4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF64FFDA),
              ),
            ),
          ),
        );
      },
    );
  }
}