import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // REMOVE or COMMENT OUT
import 'splash_screen.dart';

void main() {
  // REMOVE or COMMENT OUT Firebase initialization
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const WearWiseApp());
}

class WearWiseApp extends StatelessWidget {
  const WearWiseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WearWise',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00E676),
          surface: const Color(0xFF10281B),
          background: const Color(0xFF1A1A1A),
        ),
        scaffoldBackgroundColor: const Color(0xFF10281B),
        useMaterial3: true,
        fontFamily: 'Montserrat',
      ),
      home: const SplashScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Icon(Icons.eco, size: 120, color: Colors.green.shade400),
                // Replace with your SVG/illustration
              ),
              const SizedBox(height: 32),
              Text(
                'Set Your Sustainability Goals',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Track progress and learn how to make more sustainable fashion choices. Start your journey to a greener wardrobe!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(180, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google Sign-In pressed (no auth logic)')),
                    );
                  },
                  child: const Text('Get Started →', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/44.jpg'),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hiya, Maya!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey.shade900)),
                Text('Stay sustainable', style: TextStyle(fontSize: 13, color: Colors.green.shade400)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: ListView(
          children: [
            // Footprint Tracker
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Footprint Tracker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey.shade900)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _FootprintStat(
                          icon: Icons.map,
                          label: 'Map Score',
                          value: '72',
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(width: 16),
                        _FootprintStat(
                          icon: Icons.flag,
                          label: 'Ex. Fashion Goals',
                          value: '3',
                          color: Colors.orange.shade400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Calculate Your Footprint
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.calculate, color: Colors.green.shade400, size: 36),
                title: const Text('Clothing Footprint Calculator', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('See your clothing\'s carbon impact'),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 32),
            // Bottom info
            Center(
              child: Text(
                'Reduce Your Clothing\'s Carbon Footprint with WearWise',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green.shade400,
        unselectedItemColor: Colors.grey.shade400,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Goals'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _FootprintStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _FootprintStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color green = const Color(0xFF00E676);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: green,
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                    Row(
                      children: [
                        Text(
                          'Ecofy',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('♻️🌱🌍', style: TextStyle(fontSize: 28)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: green),
                        const SizedBox(width: 4),
                        Text(
                          'Daily Tracker',
                          style: TextStyle(color: green, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Welcome Card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF10281B),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, User!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Track your environmental impact and make a difference.',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Tree Planting Progress
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.eco, color: green),
                        const SizedBox(width: 8),
                        Text(
                          'Tree Planting Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '0.0 kg',
                      style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'CO₂ Saved',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.0,
                      backgroundColor: Colors.grey[800],
                      color: green,
                      minHeight: 6,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('0 Trees',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text('Equivalent Planted',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 13)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('1 Trees',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text('Next Goal',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save 22 more kg of CO₂ to plant your next virtual tree!',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Today's Impact
                Row(
                  children: [
                    Icon(Icons.signal_cellular_alt, color: green),
                    const SizedBox(width: 8),
                    Text(
                      "Today's Impact",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Complete today's tracker to see your impact!",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: const [
                      _TabButton(label: 'Activities', selected: true),
                      _TabButton(label: 'Tips'),
                      _TabButton(label: 'Achievements'),
                    ],
                  ),
                ),
                const SizedBox(height: 80), // For bottom nav bar spacing
              ],
            ),
            // Bottom Navigation Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Banner Ad
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.flight, color: Colors.blue, size: 36),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Traveloka', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('4.9 ★  FREE', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Get'),
                        ),
                      ],
                    ),
                  ),
                  // Navigation Bar
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _NavBarIcon(icon: Icons.home, label: 'Home', selected: true),
                        _NavBarIcon(icon: Icons.flag, label: 'Challenges'),
                        _NavBarIcon(icon: Icons.signal_cellular_alt, label: 'Track'),
                        _NavBarIcon(icon: Icons.pie_chart, label: 'Analytics'),
                        _NavBarIcon(icon: Icons.emoji_events, label: 'Leaderboard'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  const _TabButton({required this.label, this.selected = false});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: selected
            ? BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey[400],
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  const _NavBarIcon({required this.icon, required this.label, this.selected = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: selected ? Colors.blue : Colors.grey, size: 28),
        Text(
          label,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}