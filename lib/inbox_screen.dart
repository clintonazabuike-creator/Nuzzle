import 'package:flutter/material.dart';
import 'app_theme.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated conversation list data
    final List<Map<String, dynamic>> conversations = [
      {
        'name': 'Afrobeats Daily',
        'lastMessage': 'New podcast episode dropped! Check it out.',
        'time': '10:42 AM',
        'unreadCount': 2,
        'isOnline': true,
      },
      {
        'name': 'Chinedu Tech',
        'lastMessage': 'Boss, saw your new video upload. Great work!',
        'time': 'Yesterday',
        'unreadCount': 0,
        'isOnline': false,
      },
      {
        'name': 'Nuzzle Official Support',
        'lastMessage': 'Your creator verification has been confirmed.',
        'time': 'Oct 18',
        'unreadCount': 0,
        'isOnline': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Inbox & Messages', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final chat = conversations[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.cardColor,
                  child: Text(
                    chat['name'][0],
                    style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                if (chat['isOnline'])
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.background, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              chat['name'],
              style: const TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                chat['lastMessage'],
                style: const TextStyle(color: AppTheme.textGray, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat['time'], style: const TextStyle(color: AppTheme.textGray, fontSize: 11)),
                const SizedBox(height: 6),
                if (chat['unreadCount'] > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${chat['unreadCount']}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            onTap: () {
              // Navigate to Chat Detail Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(peerName: chat['name']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// --- Direct Chat Conversation Screen ---
class ChatDetailScreen extends StatefulWidget {
  final String peerName;

  const ChatDetailScreen({super.key, required this.peerName});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hello Boss! Welcome to Nuzzle messaging.', 'isMe': false, 'time': '10:30 AM'},
    {'text': 'Glad to be here. Let\'s test out the chat speed.', 'isMe': true, 'time': '10:32 AM'},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text.trim(),
        'isMe': true,
        'time': 'Just now',
      });
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primary,
              child: Text(widget.peerName[0], style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
            const SizedBox(width: 10),
            Text(widget.peerName, style: const TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: AppTheme.cardColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'];
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe ? AppTheme.primary : AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg['text'], style: const TextStyle(color: AppTheme.textWhite, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(msg['time'], style: const TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Chat Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: AppTheme.cardColor,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: AppTheme.textGray),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppTheme.textGray),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppTheme.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
