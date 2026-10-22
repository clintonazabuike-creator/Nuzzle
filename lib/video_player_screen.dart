import 'package:flutter/material.dart';
import 'app_theme.dart';


class VideoPlayerScreen extends StatefulWidget {
  final String videoTitle;
  final String creatorName;
  final String videoUrl;
  final int viewsCount;
  final int likesCount;

  const VideoPlayerScreen({
    super.key,
    required this.videoTitle,
    required this.creatorName,
    required this.videoUrl,
    required this.viewsCount,
    required this.likesCount,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isPlaying = true;
  bool _isLiked = false;
  double _playbackProgress = 0.4; // Simulated position at 40%

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Video Player Container (16:9 Aspect Ratio Simulation)
            Container(
              height: 220,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Placeholder for Flutter video_player controller
                  const Center(
                    child: Icon(Icons.play_circle_fill, size: 64, color: AppTheme.primary),
                  ),
                  
                  // Top Back Button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // Mid-Roll Ad Markers on Video Progress Bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Ad Markers Indicators (Max 3 per video)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.star, size: 12, color: AppTheme.accent), // Pre-roll
                              Icon(Icons.star, size: 12, color: AppTheme.accent), // Mid-roll 1
                              Icon(Icons.star, size: 12, color: AppTheme.accent), // Mid-roll 2
                            ],
                          ),
                        ),
                        LinearProgressIndicator(
                          value: _playbackProgress,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Video Details & Monetization Badge
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    widget.videoTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textWhite),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye, size: 16, color: AppTheme.textGray),
                      const SizedBox(width: 4),
                      Text('${widget.viewsCount} Views', style: const TextStyle(color: AppTheme.textGray, fontSize: 13)),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Monetized (50% Share)',
                          style: TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: AppTheme.cardColor),

                  // Creator Row
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppTheme.primary,
                        child: Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.creatorName, style: const TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold)),
                            const Text('Verified Creator', style: TextStyle(color: AppTheme.textGray, fontSize: 12)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Subscribe'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Engagement Actions (Like, Tip, Share)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                        icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        label: '${widget.likesCount}',
                        color: _isLiked ? AppTheme.primary : AppTheme.textWhite,
                        onTap: () => setState(() => _isLiked = !_isLiked),
                      ),
                      _buildActionButton(
                        icon: Icons.card_giftcard,
                        label: 'Tip Creator',
                        color: AppTheme.accent,
                        onTap: () {},
                      ),
                      _buildActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        color: AppTheme.textWhite,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const Divider(height: 30, color: AppTheme.cardColor),

                  // Comments Section Header
                  const Text(
                    'Comments',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textWhite),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No comments yet. Be the first to share your thoughts!',
                    style: TextStyle(color: AppTheme.textGray, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
