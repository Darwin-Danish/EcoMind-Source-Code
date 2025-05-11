import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/add_activity_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _fabAnimController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabPositionAnimation;

  List<Widget> get _tabContents => [
    const HomeContent(),
    const ChallengeScreen(),
    const ChatScreen(),
    const LeaderboardScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Adjust animation to keep FAB size more stable
    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _fabAnimController, curve: Curves.easeInOut),
    );
    
    // Keep FAB at same height as nav icons
    _fabPositionAnimation = Tween<double>(begin: 16.0, end: 16.0).animate(
      CurvedAnimation(parent: _fabAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    super.dispose();
  }

  void _handleTabChange(int index) {
    setState(() => _selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF00E676);
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          _tabContents[_selectedTab],
          // Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF10281B).withOpacity(0.8),
                    Color(0xFF10281B),
                  ],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavBarIcon(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    selected: _selectedTab == 0,
                    onTap: () => _handleTabChange(0),
                  ),
                  _NavBarIcon(
                    icon: Icons.flag_rounded,
                    label: 'Challenge',
                    selected: _selectedTab == 1,
                    onTap: () => _handleTabChange(1),
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Center(
                      child: Transform.scale(
                        scale: _fabScaleAnimation.value,
                        child: Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [primary, primary.withGreen(200)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddActivityScreen(),
                                  ),
                                );
                                if (result != null) {
                                  print(result);
                                }
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Icon(
                                Icons.add_rounded,
                                size: 32,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _NavBarIcon(
                    icon: Icons.chat_bubble_rounded,
                    label: 'Chat',
                    selected: _selectedTab == 2,
                    onTap: () => _handleTabChange(2),
                  ),
                  _NavBarIcon(
                    icon: Icons.emoji_events_rounded,
                    label: 'Leaderboard',
                    selected: _selectedTab == 3,
                    onTap: () => _handleTabChange(3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  // Add static list to store activities temporarily 
  static List<Activity> tempActivities = [];
  static double totalCO2Saved = 0.0;
  
  // Modify tree progress system
  static int currentTrees = 0;
  static double currentTreeRequirement = 5.0; // First tree needs 5kg CO2
  
  // Calculate progress to next tree
  static double get progressToNextTree {
    double co2SinceLastTree = totalCO2Saved - (currentTrees * currentTreeRequirement);
    return co2SinceLastTree / currentTreeRequirement;
  }

  // Get CO2 remaining for next tree
  static double get co2RemainingForNextTree {
    double co2SinceLastTree = totalCO2Saved - (currentTrees * currentTreeRequirement);
    return currentTreeRequirement - co2SinceLastTree;
  }

  // Update tree progress check method
  static void checkTreeProgress() {
    // Calculate how many trees earned based on current requirement
    double totalPossibleTrees = totalCO2Saved / currentTreeRequirement;
    int newTreeCount = totalPossibleTrees.floor();
    
    if (newTreeCount > currentTrees) {
      // Award new trees
      currentTrees = newTreeCount;
      // Increase requirement for next tree (increase by 20% each time)
      currentTreeRequirement = 5.0 * (1 + (currentTrees * 0.2));
    }
  }

  const HomeContent({Key? key}) : super(key: key);

  @override 
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _selectedTab = 0;

  final List<Widget> _tabContents = [
    _ActivitiesTab(activities: HomeContent.tempActivities), // Pass temp activities
    const _TipsTab(),
    const _AchievementsTab(),
  ];

  // Add method to update UI
  void _updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color green = const Color(0xFF00E676);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 60), // Reduced padding
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4), // Reduced vertical padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: green,
                  radius: 18, // Smaller avatar
                  child: const Icon(Icons.person, color: Colors.black, size: 18),
                ),
                const Text(
                  'EcoMind',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20, // Smaller font
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Smaller padding
                  decoration: BoxDecoration(
                    color: green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12), // Smaller radius
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '5',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                          fontSize: 12, // Smaller font
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // Reduced spacing

          // Welcome Card with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF10281B),
                  const Color(0xFF10281B).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Track your impact today',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.eco, color: green, size: 32),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Tree Planting Progress with modern design
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF10281B).withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CO₂ Saved',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.eco, color: green, size: 16),
                          const SizedBox(width: 4),
                          // Update CO2 text to show total
                          Text(
                            '${HomeContent.totalCO2Saved.toStringAsFixed(2)} kg',
                            style: TextStyle(
                              color: green,
                              fontWeight: FontWeight.bold,  
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: HomeContent.progressToNextTree,
                    backgroundColor: Colors.grey[800],
                    color: green,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ProgressStat(
                      label: 'Current',
                      value: '${HomeContent.currentTrees}',
                      suffix: HomeContent.currentTrees == 1 ? 'Tree' : 'Trees',
                      color: green,
                    ),
                    _ProgressStat(
                      label: 'Next Tree In',
                      value: '${HomeContent.co2RemainingForNextTree.toStringAsFixed(1)}',
                      suffix: 'kg CO₂',
                      color: Colors.grey[400]!,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Add capacity text
                Text(
                  'Current Goal: ${HomeContent.currentTreeRequirement.toStringAsFixed(1)} kg CO₂ per tree',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Today's Impact section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF10281B).withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.insights, color: green, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      "Today's Impact",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Tabs with animation
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _TabButton(
                        label: 'Activities',
                        selected: _selectedTab == 0,
                        onTap: () => setState(() => _selectedTab = 0),
                      ),
                      _TabButton(
                        label: 'Tips',
                        selected: _selectedTab == 1,
                        onTap: () => setState(() => _selectedTab = 1),
                      ),
                      _TabButton(
                        label: 'Achievements',
                        selected: _selectedTab == 2,
                        onTap: () => setState(() => _selectedTab = 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Animated tab content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Container(
              key: ValueKey(_selectedTab),
              margin: const EdgeInsets.only(top: 24),
              child: _tabContents[_selectedTab],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;
  final Color color;

  const _ProgressStat({
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' $suffix',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.label, this.selected = false, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: selected
              ? BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey[400],
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
              child: Text(label),
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
  final VoidCallback? onTap;
  const _NavBarIcon({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF00E676);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72, // Increased from 64
        margin: const EdgeInsets.symmetric(horizontal: 4), // Added horizontal margin
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? primary : Colors.grey.withOpacity(0.5),
              size: 22, // Slightly smaller icon
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? primary : Colors.grey.withOpacity(0.5),
                fontSize: 11, // Slightly smaller text
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivitiesTab extends StatelessWidget {
  final List<Activity> activities;
  const _ActivitiesTab({required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Recent Activities',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: const Color(0xFF10281B).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey[800]!,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.eco_outlined, color: Colors.grey[700], size: 48),
                const SizedBox(height: 12),
                Text(
                  'No Activities Yet',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Start your eco-journey today',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Recent Activities',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10281B).withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFF00E676).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF00E676).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      activity.icon ?? Icons.eco,
                      color: Color(0xFF00E676),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          activity.date,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF00E676).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activity.amount,
                      style: TextStyle(
                        color: Color(0xFF00E676),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class Activity {
  final String title;
  final String date;
  final String amount;
  final IconData? icon;
  
  Activity({
    required this.title, 
    required this.date, 
    required this.amount,
    this.icon,
  });
}

class _TipsTab extends StatefulWidget {
  const _TipsTab({Key? key}) : super(key: key);

  @override
  State<_TipsTab> createState() => _TipsTabState();
}

class _TipsTabState extends State<_TipsTab> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_Tip> _tips = [
    _Tip(
      icon: Icons.lightbulb,
      iconColor: Color(0xFF00E676),
      title: 'Save Energy',
      subtitle: 'Turn off lights when leaving a room',
    ),
    _Tip(
      icon: Icons.water_drop,
      iconColor: Colors.blue,
      title: 'Save Water',
      subtitle: 'Take shorter showers to reduce water use',
    ),
    _Tip(
      icon: Icons.directions_bike,
      iconColor: Colors.orange,
      title: 'Use a Bike',
      subtitle: 'Bike or walk for short trips instead of driving',
    ),
    _Tip(
      icon: Icons.shopping_bag,
      iconColor: Colors.purple,
      title: 'Reusable Bags',
      subtitle: 'Bring reusable bags when shopping',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Tips of the Day',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Color(0xFF00E676).withOpacity(0.2), width: 1),
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1.9, // Adjust as needed for your design
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _tips.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, i) {
                    final tip = _tips[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(tip.icon, color: tip.iconColor, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            tip.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tip.subtitle,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_tips.length, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _currentPage ? Color(0xFF00E676) : Colors.grey[700],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tip {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  const _Tip({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}

class _AchievementsTab extends StatelessWidget {
  const _AchievementsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example data: first unlocked, rest locked
    final achievements = [
      _Achievement(
        icon: Icons.star,
        iconColor: Colors.yellow,
        title: 'Early Bird',
        unlocked: true,
        subtitle: 'Unlocked!',
        subtitleColor: Color(0xFF00E676),
      ),
      _Achievement(
        icon: Icons.shield,
        iconColor: Colors.grey,
        title: 'Eco Warrior',
        unlocked: false,
        subtitle: 'Locked',
      ),
      _Achievement(
        icon: Icons.public,
        iconColor: Colors.grey,
        title: 'Planet Protector',
        unlocked: false,
        subtitle: 'Locked',
      ),
      _Achievement(
        icon: Icons.energy_savings_leaf, // Changed from Icons.crown
        iconColor: Colors.grey,
        title: 'Green Champion',
        unlocked: false,
        subtitle: 'Locked',
      ),
      _Achievement(
        icon: Icons.star,
        iconColor: Colors.grey,
        title: 'Daily Hero',
        unlocked: false,
        subtitle: 'Locked',
      ),
      _Achievement(
        icon: Icons.emoji_events,
        iconColor: Colors.grey,
        title: 'Eco Champion', // Changed from Water Guardian
        unlocked: false,
        subtitle: 'Locked',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Your Achievements',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 32,
          crossAxisSpacing: 0,
          childAspectRatio: 1.2,
          children: achievements.map((a) => _AchievementTile(a)).toList(),
        ),
      ],
    );
  }
}

class _Achievement {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool unlocked;
  final String subtitle;
  final Color? subtitleColor;
  _Achievement({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.unlocked,
    required this.subtitle,
    this.subtitleColor,
  });
}

class _AchievementTile extends StatelessWidget {
  final _Achievement achievement;
  const _AchievementTile(this.achievement);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showAchievementDetails(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            achievement.icon,
            color: achievement.unlocked ? achievement.iconColor : Colors.grey,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            achievement.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            achievement.subtitle,
            style: TextStyle(
              color: achievement.unlocked
                  ? (achievement.subtitleColor ?? Color(0xFF00E676))
                  : Colors.grey,
              fontSize: 16,
              fontWeight: achievement.unlocked ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showAchievementDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle and close/share buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.share, color: Color(0xFF00E676)),
                      onPressed: () {
                        final String shareText = achievement.unlocked
                            ? "🎉 I just unlocked the '${achievement.title}' achievement in Ecofy! Join me in making a difference for our planet! 🌍"
                            : "I'm working towards unlocking the '${achievement.title}' achievement in Ecofy! Join my eco-journey! 🌱";
                        Share.share(shareText);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Achievement icon and title
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: achievement.unlocked 
                                        ? achievement.iconColor.withOpacity(0.2)
                                        : Colors.grey[800],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    achievement.icon,
                                    color: achievement.unlocked 
                                        ? achievement.iconColor 
                                        : Colors.grey,
                                    size: 40,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        achievement.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: achievement.unlocked
                                              ? Color(0xFF00E676).withOpacity(0.2)
                                              : Colors.grey[800],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          achievement.unlocked ? 'Unlocked' : 'Locked',
                                          style: TextStyle(
                                            color: achievement.unlocked
                                                ? Color(0xFF00E676)
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            // Description
                            Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _getAchievementDescription(achievement.title),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 24),
                            // Requirements
                            Text(
                              'Requirements',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            ..._buildRequirementsList(achievement.title),
                          ],
                        ),
                      ),
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

  String _getAchievementDescription(String title) {
    switch (title) {
      case 'Early Bird':
        return 'Start your eco-journey by completing your first environmental action within the first week of joining.';
      case 'Eco Warrior':
        return 'Demonstrate your commitment to environmental protection through consistent daily actions.';
      case 'Planet Protector':
        return 'Make a significant impact on reducing your carbon footprint through various sustainable activities.';
      default:
        return 'Complete special challenges and tasks to unlock this achievement and prove your dedication to environmental sustainability.';
    }
  }

  List<Widget> _buildRequirementsList(String title) {
    final requirements = _getRequirements(title);
    return requirements.map((req) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: achievement.unlocked ? Color(0xFF00E676).withOpacity(0.2) : Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              achievement.unlocked ? Icons.check_circle : Icons.radio_button_unchecked,
              color: achievement.unlocked ? Color(0xFF00E676) : Colors.grey,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              req,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }

  List<String> _getRequirements(String title) {
    switch (title) {
      case 'Early Bird':
        return [
          'Install and set up the app',
          'Complete your first environmental survey',
          'Log your first eco-friendly action',
        ];
      case 'Eco Warrior':
        return [
          'Complete 10 daily challenges',
          'Reduce carbon footprint by 20%',
          'Share 5 eco-tips with community',
        ];
      default:
        return [
          'Achievement requirements locked',
          'Continue your eco-journey to discover more',
        ];
    }
  }
}