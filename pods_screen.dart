import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PodsScreen extends StatefulWidget {
  const PodsScreen({super.key});

  @override
  State<PodsScreen> createState() => _PodsScreenState();
}

class _PodsScreenState extends State<PodsScreen> {
  // Playback state
  String _selectedSpeed = '1.0x';
  bool _isPlaying = false;
  String? _currentPlayingEpisode;

  final List<String> _speeds = ['1.0x', '1.25x', '1.5x', '2.0x'];

  // Simulated podcast episodes list
  final List<Map<String, String>> _episodes = [
    {
      'title': 'Ep 42: Tech & Startup Scaling in Nigeria',
      'show': 'The Tech Pulse Podcast',
      'duration': '45:20',
      'date': 'Oct 18, 2026',
      'host': 'Clinton Azubuike',
    },
    {
      'title': 'Ep 12: Building Independent Music Brands',
      'show': 'Afrobeats Uncut',
      'duration': '32:15',
      'date': 'Oct 15, 2026',
      'host': 'Nuzzle Creator Hub',
    },
    {
      'title': 'Ep 88: Future of Mobile App Monetization',
      'show': 'Digital Economy Pod',
      'duration': '50:10',
      'date': 'Oct 10, 2026',
      'host': 'Azabuike Tech',
    },
  ];

  void _cycleSpeed() {
    int currentIndex = _speeds.indexOf(_selectedSpeed);
    int nextIndex = (currentIndex + 1) % _speeds.length;
    setState(() {
      _selectedSpeed = _speeds[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Nuzzle Pods', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          // Playback Speed Toggle Chip
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ActionChip(
              backgroundColor: AppTheme.cardColor,
              side: const BorderSide(color: AppTheme.primary),
              label: Text(
                _selectedSpeed,
                style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
              ),
              onPressed: _cycleSpeed,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Featured Podcast Banner Carousel
          Container(
            height: 140,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, Color(0xFF4C1D95)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'FEATURED PODCAST',
                        style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'The Tech Pulse Podcast',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Listen to creators discuss building apps & tech.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.podcasts, size: 48, color: Colors.white),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Episodes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textWhite),
              ),
            ),
          ),

          // Episode List
          Expanded(
            child: ListView.builder(
              itemCount: _episodes.length,
              itemBuilder: (context, index) {
                final ep = _episodes[index];
                final isPlayingThis = _currentPlayingEpisode == ep['title'] && _isPlaying;

                return Card(
                  color: AppTheme.cardColor,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isPlayingThis ? Icons.pause : Icons.play_arrow,
                          color: AppTheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_currentPlayingEpisode == ep['title']) {
                              _isPlaying = !_isPlaying;
                            } else {
                              _currentPlayingEpisode = ep['title'];
                              _isPlaying = true;
                            }
                          });
                        },
                      ),
                    ),
                    title: Text(
                      ep['title']!,
                      style: const TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(ep['show']!, style: const TextStyle(color: AppTheme.textGray, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(ep['duration']!, style: const TextStyle(color: AppTheme.accent, fontSize: 11)),
                            const SizedBox(width: 10),
                            Text(ep['date']!, style: const TextStyle(color: AppTheme.textGray, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.download_for_offline_outlined, color: AppTheme.textGray),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${ep['title']}...')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
