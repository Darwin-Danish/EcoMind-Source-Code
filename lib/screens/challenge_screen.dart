import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ModernChallengeScreen();
  }
}

class ModernChallengeScreen extends StatefulWidget {
  const ModernChallengeScreen({Key? key}) : super(key: key);

  @override
  State<ModernChallengeScreen> createState() => _ModernChallengeScreenState();
}

class _ModernChallengeScreenState extends State<ModernChallengeScreen> {
  // Add sample data for the chart
  final List<FlSpot> weeklyData = [
    FlSpot(0, 3),
    FlSpot(1, 5),
    FlSpot(2, 4),
    FlSpot(3, 6),
    FlSpot(4, 5),
    FlSpot(5, 7),
    FlSpot(6, 8),
  ];

  // Add achievements list
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
      icon: Icons.energy_savings_leaf,
      iconColor: Colors.grey,
      title: 'Green Champion',
      unlocked: false,
      subtitle: 'Locked',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Get the navigation bar height
    final bottomNavHeight = 80.0; // Height of bottom nav bar
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final totalBottomPadding = bottomNavHeight + bottomPadding;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D1F17),
            Color(0xFF1A1A1A),
            Color(0xFF10281B),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false, // Don't apply SafeArea at bottom
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: ListView(
                  // Using ListView instead of CustomScrollView for simpler padding handling
                  padding: EdgeInsets.only(bottom: totalBottomPadding),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: _buildStatisticsSection(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: _buildChallenges(),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Recent Achievements',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              scrollDirection: Axis.horizontal,
                              itemCount: achievements.length,
                              itemBuilder: (context, index) {
                                final achievement = achievements[index];
                                return Container(
                                  width: 120,
                                  margin: EdgeInsets.only(right: 12),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        achievement.unlocked 
                                            ? achievement.iconColor.withOpacity(0.2)
                                            : Colors.grey[800]!.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: achievement.unlocked 
                                          ? achievement.iconColor.withOpacity(0.3)
                                          : Colors.grey[700]!,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        achievement.icon,
                                        color: achievement.unlocked ? achievement.iconColor : Colors.grey,
                                        size: 24,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        achievement.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        achievement.subtitle,
                                        style: TextStyle(
                                          color: achievement.unlocked
                                              ? (achievement.subtitleColor ?? Color(0xFF00E676))
                                              : Colors.grey,
                                          fontSize: 11,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: _buildTipsAndTricks(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(12), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                title: 'Total Points',
                value: '2,547',
                icon: Icons.star,
                color: Color(0xFFFFD700),
                iconSize: 24, // Smaller icon
                fontSize: 18, // Smaller font
              ),
              _buildStatCard(
                title: 'Weekly Streak',
                value: '5 Days',
                icon: Icons.local_fire_department,
                color: Color(0xFFFF6B6B),
                iconSize: 24,
                fontSize: 18,
              ),
            ],
          ),
          SizedBox(height: 12), // Reduced spacing
          _buildStreakIndicator(),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    double iconSize = 24,
    double fontSize = 18,
  }) {
    return Container(
      padding: EdgeInsets.all(12), // Reduced padding
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12), // Smaller radius
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: iconSize),
          SizedBox(height: 4), // Reduced spacing
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12, // Smaller font
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        bool isCompleted = index < 5;
        bool isToday = index == 4;
        return Container(
          width: 32, // Smaller width
          child: Column(
            children: [
              Container(
                height: 32, // Smaller height
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Color(0xFF00E676) : Colors.grey[800],
                  border: isToday
                      ? Border.all(color: Colors.white, width: 1.5) // Thinner border
                      : null,
                ),
                child: isCompleted
                    ? Icon(Icons.check, color: Colors.black, size: 16) // Smaller icon
                    : null,
              ),
              SizedBox(height: 2), // Reduced spacing
              Text(
                ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10, // Smaller font
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      children: [
        _buildPointsChart(),
        SizedBox(height: 20),
        _buildStreakChart(),
      ],
    );
  }

  Widget _buildPointsChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Points History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16, // Smaller font
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12), // Reduced spacing
        Container(
          height: 160, // Reduced height
          padding: EdgeInsets.all(12), // Reduced padding
          decoration: BoxDecoration(
            color: Colors.grey[800]?.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 100,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 200,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = ['Mon', 'Wed', 'Fri', 'Sun'];
                      final index = value.toInt();
                      if (index % 2 == 0 && index < days.length) {
                        return Text(
                          days[index],
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 200),
                    FlSpot(1, 350),
                    FlSpot(2, 300),
                    FlSpot(3, 500),
                    FlSpot(4, 450),
                    FlSpot(5, 600),
                    FlSpot(6, 550),
                  ],
                  isCurved: true,
                  gradient: LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF00E676).withOpacity(0.3)],
                  ),
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF00E676).withOpacity(0.2),
                        Color(0xFF00E676).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Streak Progress',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16, // Smaller font
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12), // Reduced spacing
        Container(
          height: 160, // Reduced height
          padding: EdgeInsets.all(12), // Reduced padding
          decoration: BoxDecoration(
            color: Colors.grey[800]?.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 2,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 2,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toInt()}d',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const weeks = ['W1', 'W2', 'W3', 'W4'];
                      final index = value.toInt();
                      if (index < weeks.length) {
                        return Text(
                          weeks[index],
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 3),
                    FlSpot(1, 5),
                    FlSpot(2, 4),
                    FlSpot(3, 7),
                  ],
                  isCurved: true,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF6B6B).withOpacity(0.3)],
                  ),
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                      radius: 4,
                      color: Color(0xFFFF6B6B),
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFF6B6B).withOpacity(0.2),
                        Color(0xFFFF6B6B).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF00E676),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Challenges',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...List.generate(3, (index) => _buildChallengeCard()),
      ],
    );
  }

  Widget _buildChallengeCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00E676).withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF00E676).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.eco, color: Color(0xFF00E676)),
                  SizedBox(width: 8),
                  Text(
                    'Reduce Carbon Footprint',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF00E676).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+50 pts',
                  style: TextStyle(
                    color: Color(0xFF00E676),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.grey[800],
            color: Color(0xFF00E676),
          ),
          SizedBox(height: 8),
          Text(
            '7/10 days completed',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsAndTricks() {
    final tips = [
      {
        'icon': Icons.lightbulb,
        'color': Color(0xFFFFD700),
        'title': 'Complete challenges early',
        'subtitle': 'Earn bonus points by completing tasks before deadline'
      },
      {
        'icon': Icons.tips_and_updates,
        'color': Color(0xFF00E676),
        'title': 'Maintain your streak',
        'subtitle': 'Log in daily to keep your progress going'
      },
      {
        'icon': Icons.eco,
        'color': Color(0xFF4CAF50),
        'title': 'Be consistent',
        'subtitle': 'Small actions every day lead to big changes'
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tips & Tricks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...tips.map((tip) => Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (tip['color'] as Color).withOpacity(0.2),
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (tip['color'] as Color).withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (tip['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tip['icon'] as IconData,
                  color: tip['color'] as Color,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['title'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      tip['subtitle'] as String,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}

// Add Achievement class definition
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
