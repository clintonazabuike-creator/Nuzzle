import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'login_screen.dart';
import 'creator_upload_screen.dart';
import 'inbox_screen.dart';
import 'music_player_screen.dart';
import 'pods_screen.dart';
import 'wallet_screen.dart';
import 'video_player_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NuzzleApp());
}

class NuzzleApp extends StatelessWidget {
  const NuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuzzle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // For initial testing, you can toggle between LoginScreen() and MainNavigation()
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Hardcoded mock user data for testing navigation tabs
  // In production, these come from your cPanel login response/SharedPreferences
  final int mockUserId = 1;
  final String mockUserEmail = 'clinton@azabuiketech.com';
  final bool mockIsCreator = true;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      // Tab 0: Video Feed / Discovery Home
      _buildHomeFeedTab(),
      // Tab 1: Music Player Deck
      const MusicPlayerScreen(
        songTitle: 'Afro-Magic Anthem',
        artistName: 'Azabuike Sounds',
        artworkUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500',
        audioUrl: 'https://yourdomain.com/api/uploads/musics/sample.mp3',
      ),
      // Tab 2: Pods Hub
      const PodsScreen(),
      // Tab 3: Inbox / Chat
      const InboxScreen(),
      // Tab 4: Creator Wallet & Studio
      CreatorUploadScreen(
        userId: mockUserId,
        userEmail: mockUserEmail,
        isCreator: mockIsCreator,
      ),
    ];
  }

  Widget _buildHomeFeedTab() {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Nuzzle',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 24),
        ),
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined, color: AppTheme.textWhite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WalletScreen(userId: mockUserId)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    videoTitle: 'Exploring Delta State Tech & Creator Economy #${index + 1}',
                    creatorName: 'Clinton Azubuike',
                    videoUrl: 'https://yourdomain.com/api/uploads/videos/sample.mp4',
                    viewsCount: 1420 + (index * 350),
                    likesCount: 310 + (index * 45),
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Video Thumbnail Mock
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?w=500',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.play_arrow, color: Colors.white, size: 30),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.primary,
                          child: Text('C', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Exploring Delta State Tech & Creator Economy #${index + 1}',
                                style: const TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold, fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Clinton Azubuike • 1.4K views • 2 hours ago',
                                style: TextStyle(color: AppTheme.textGray, fontSize: 12),
                              ),
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.cardColor,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textGray,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
          BottomNavigationBarItem(icon: Icon(Icons.podcasts), label: 'Pods'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.video_call), label: 'Studio'),
        ],
      ),
    );
  }
}
