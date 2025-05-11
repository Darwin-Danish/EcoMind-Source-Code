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
  late Animation<double> _waveAnimation;

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
      'colors': [Color(0xFF64FFDA), Color(0xFF052118)], // Darker background
    },
    {
      'title': 'Track Your\nDaily Impact',
      'desc': 'Monitor your carbon footprint and see your positive environmental changes.',
      'image': 'show_chart',
      'colors': [Color(0xFF1DE9B6), Color(0xFF052118)], // Darker background
    },
    {
      'title': 'Join The Green\nMovement',
      'desc': 'Be part of a global community working towards a sustainable future.',
      'image': 'group',
      'colors': [Color(0xFF08D9D6), Color(0xFF052118)], // Darker background
    },
  ];

  final List<Color> _greenGradients = [
    Color(0xFF64FFDA),
    Color(0xFF00E676),
    Color(0xFF1DE9B6),
    Color(0xFF00BFA5),
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
      duration: const Duration(milliseconds: 4000),
    )..addListener(_updateCircles);

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_animationController);

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
          // Animated Wave Background
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  wavePhase: _waveAnimation.value,
                  gradientColors: _greenGradients,
                ),
                size: MediaQuery.of(context).size,
              );
            },
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07), // Reduced top padding by 30%
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(28.0, 0, 28.0, 60.0),
                          child: _buildPageContent(index),
                        );
                      },
                    ),
                  ),

                  // Updated navigation section
                  Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Column(
                      children: [
                        _buildPageIndicators(),
                        SizedBox(height: 24),
                        Row(
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
                                  foregroundColor: Colors.white,
                                ),
                                child: Text('Previous'),
                              )
                            else
                              SizedBox(width: 80),
                            _currentPage < _pages.length - 1
                                ? _buildNextButton()
                                : _buildLoginButton(context),
                          ],
                        ),
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

  Widget _buildPageContent(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simplified icon container without animations
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: (_pages[index]['colors'][0] as Color).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            _pages[index]['image'] == 'eco'
                ? Icons.eco
                : _pages[index]['image'] == 'show_chart'
                    ? Icons.show_chart
                    : Icons.group,
            size: 40,
            color: _pages[index]['colors'][0],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          _pages[index]['title']!,
          style: TextStyle(
            fontSize: 40,
            height: 1.2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _pages[index]['desc']!,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.9),
            height: 1.5,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 4,
          width: _currentPage == index ? 24 : 12,
          decoration: BoxDecoration(
            color: _currentPage == index 
                ? _pages[_currentPage]['colors'][0]
                : _pages[_currentPage]['colors'][0].withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        _controller.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _pages[_currentPage]['colors'][0],
        foregroundColor: Color(0xFF052118),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      child: const Text(
        'Next',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _pages[_currentPage]['colors'][0],
        foregroundColor: Color(0xFF052118),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Get Started',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 20),
        ],
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
          pageColors[0].withOpacity(0.3), // Increased opacity
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

class WavePainter extends CustomPainter {
  final double wavePhase;
  final List<Color> gradientColors;

  WavePainter({required this.wavePhase, required this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
        transform: GradientRotation(wavePhase * 0.5),
      ).createShader(Offset.zero & size);

    final path = Path();
    var y = size.height;
    path.moveTo(0, y);

    for (var x = 0.0; x < size.width; x++) {
      y = size.height * 0.8 +
          math.sin(x / 50 + wavePhase) * 20 +
          math.cos(x / 30 + wavePhase) * 15;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
