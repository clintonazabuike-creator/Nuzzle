import 'package:flutter/material.dart';
import 'app_theme.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String songTitle;
  final String artistName;
  final String artworkUrl;
  final String audioUrl;

  const MusicPlayerScreen({
    super.key,
    required this.songTitle,
    required this.artistName,
    required this.artworkUrl,
    required this.audioUrl,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool _isPlaying = true;
  double _currentSliderVal = 0.3; // Simulated progress (30%)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Nuzzle Audio', style: TextStyle(fontSize: 14, color: AppTheme.textGray)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // 1. Album Artwork Card with Rounded Corners & Glow
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(widget.artworkUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // 2. THE MONETIZATION DECK: Persistent Native Banner Ad Slot
            // Sits right below the artwork. Auto-refreshes to maximize CPM without blocking UI.
            Container(
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'AD',
                        style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Sponsored Brand Promotion',
                          style: TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Support creators while you stream. Tap to explore.',
                          style: TextStyle(color: AppTheme.textGray, fontSize: 11),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Track Metadata
            Row(
              mainAxisAlignment: поддерживаетSpaceBetween ?? MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.songTitle,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textWhite),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.artistName,
                        style: const TextStyle(fontSize: 15, color: AppTheme.textGray),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: AppTheme.textWhite),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 4. Scrub Bar & Timestamps
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppTheme.primary,
                inactiveTrackColor: AppTheme.cardColor,
                thumbColor: AppTheme.primary,
                trackHeight: 4,
              ),
              child: Slider(
                value: _currentSliderVal,
                onChanged: (val) => setState(() => _currentSliderVal = val),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('1:12', style: TextStyle(color: AppTheme.textGray, fontSize: 12)),
                  Text('3:45', style: TextStyle(color: AppTheme.textGray, fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 5. Playback Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle, color: AppTheme.textGray),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 36, color: AppTheme.textWhite),
                  onPressed: () {},
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primary,
                  child: IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 32, color: Colors.white),
                    onPressed: () => setState(() => _isPlaying = !_isPlaying),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 36, color: AppTheme.textWhite),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.repeat, color: AppTheme.textGray),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
