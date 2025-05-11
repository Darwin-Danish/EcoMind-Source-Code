import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  int _currentPage = 0;

  late AnimationController _animationController;
  final List<FloatingCircle> _floatingCircles = List.generate(
    6,
    (index) => FloatingCircle(
      position: Offset(
        math.Random().nextDouble() * 400,
        math.Random().nextDouble() * 800,
      ),
      radius: math.Random().nextDouble() * 100 + 50,
      speed: math.Random().nextDouble() * 2 + 1,
      direction: Offset(
        math.Random().nextDouble() * 2 - 1,
        math.Random().nextDouble() * 2 - 1,
      ),
    ),
  );

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Taking care of\nour planet is easy',
      'desc': 'Track your environmental impact and join a community of change-makers.',
      'image': 'eco',
      'colors': [Color(0xFF08D9D6), Color(0xFF252A34)], // Modern cyan to dark
    },
    {
      'title': 'Track Your\nDaily Impact',
      'desc': 'Monitor your carbon footprint and see your positive environmental changes.',
      'image': 'show_chart',
      'colors': [Color(0xFFFF2E63), Color(0xFF252A34)], // Modern pink to dark
    },
    {
      'title': 'Join The Green\nMovement',
      'desc': 'Be part of a global community working towards a sustainable future.',
      'image': 'group',
      'colors': [Color(0xFFEAEAEA), Color(0xFF252A34)], // Light to dark
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updateCircles);
    _animationController.repeat();
  }

  void _updateCircles() {
    for (var circle in _floatingCircles) {
      circle.updatePosition(MediaQuery.of(context).size);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _pages[_currentPage]['colors'],
              ),
            ),
          ),

          // Floating Circles
          CustomPaint(
            painter: FloatingCirclesPainter(
              circles: _floatingCircles,
              pageColors: _pages[_currentPage]['colors'],
            ),
            size: MediaQuery.of(context).size,
          ),

          // Content
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Icon(
                                  _pages[index]['image'] == 'eco'
                                      ? Icons.eco
                                      : _pages[index]['image'] == 'show_chart'
                                          ? Icons.show_chart
                                          : Icons.group,
                                  size: 64,
                                  color: _pages[index]['colors'][0] as Color,
                                ),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                _pages[index]['title']!,
                                style: const TextStyle(
                                  fontSize: 36,
                                  height: 1.2,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _pages[index]['desc']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Modern page indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? _pages[_currentPage]['colors'][0] as Color
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Navigation buttons
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: () {
                              _controller.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white.withOpacity(0.8),
                            ),
                            child: const Text('Previous'),
                          )
                        else
                          const SizedBox(width: 80),
                        _currentPage < _pages.length - 1
                            ? _buildNextButton()
                            : _buildLoginButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _pages[_currentPage]['colors'][0] as Color,
            const Color(0xFF64FFDA),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (_pages[_currentPage]['colors'][0] as Color).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          _controller.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text('Next', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF64FFDA), _pages[_currentPage]['colors'][0] as Color],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (_pages[_currentPage]['colors'][0] as Color).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class FloatingCircle {
  Offset position;
  final double radius;
  final double speed;
  Offset direction;

  FloatingCircle({
    required this.position,
    required this.radius,
    required this.speed,
    required this.direction,
  });

  void updatePosition(Size bounds) {
    position += direction * speed;

    if (position.dx < -radius || position.dx > bounds.width + radius) {
      direction = Offset(-direction.dx, direction.dy);
    }
    if (position.dy < -radius || position.dy > bounds.height + radius) {
      direction = Offset(direction.dx, -direction.dy);
    }
  }
}

class FloatingCirclesPainter extends CustomPainter {
  final List<FloatingCircle> circles;
  final List<Color> pageColors;

  FloatingCirclesPainter({required this.circles, required this.pageColors});

  @override
  void paint(Canvas canvas, Size size) {
    for (var circle in circles) {
      final gradient = RadialGradient(
        colors: [
          pageColors[0].withOpacity(0.2),
          pageColors[0].withOpacity(0.0),
        ],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: circle.position, radius: circle.radius),
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 32);

      canvas.drawCircle(circle.position, circle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
