import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF10281B),
            Color(0xFF1A1A1A),
          ],
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Leaderboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                // Top 3 Winners with Podium
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Podium Base
                    Container(
                      height: 220,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // 2nd Place Podium
                          Container(
                            width: 90,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Color(0xFF1F392C),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                            ),
                          ),
                          // 1st Place Podium
                          Container(
                            width: 90,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Color(0xFF1F392C),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                            ),
                          ),
                          // 3rd Place Podium
                          Container(
                            width: 90,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Color(0xFF1F392C),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Players
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildTopPlayer(
                            rank: 2,
                            name: "Jackson",
                            points: "1847",
                            imagePath: "assets/avatar1.png",
                            height: 160,
                            bottomPadding: 160,
                          ),
                          _buildTopPlayer(
                            rank: 1,
                            name: "Elden",
                            points: "2430",
                            imagePath: "assets/avatar2.png",
                            height: 200,
                            isWinner: true,
                            bottomPadding: 200,
                          ),
                          _buildTopPlayer(
                            rank: 3,
                            name: "Emma Aria",
                            points: "1674",
                            imagePath: "assets/avatar3.png",
                            height: 140,
                            bottomPadding: 140,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Other Players List
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF10281B),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 100), // Added bottom padding
                      children: [
                        _buildPlayerListItem(4, "Sebastian", "1124"),
                        _buildPlayerListItem(5, "Jason", "875"),
                        _buildPlayerListItem(6, "Natalie", "774"),
                        _buildPlayerListItem(7, "Serenity", "723"),
                        _buildPlayerListItem(8, "Hannah", "559"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom gradient shadow
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xFF10281B).withOpacity(0.8),
                    Color(0xFF10281B),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPlayer({
    required int rank,
    required String name,
    required String points,
    required String imagePath,
    required double height,
    required double bottomPadding,
    bool isWinner = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isWinner 
                    ? [Color(0xFF00E676), Color(0xFF00C853)]
                    : [Color(0xFF2C4B3A), Color(0xFF1F392C)],
              ),
              border: Border.all(
                color: isWinner ? Color(0xFF00E676) : Colors.grey.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: isWinner ? Colors.black : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.eco,
                color: Color(0xFF00E676),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                points,
                style: TextStyle(
                  color: Color(0xFF00E676),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerListItem(int rank, String name, String points) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C4B3A), Color(0xFF1F392C)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.eco,
                color: Color(0xFF00E676),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                points,
                style: TextStyle(
                  color: Color(0xFF00E676),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
