import '../../core/utils/screen_imports.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _send() {
    final state = context.read<AppState>();
    final text = _messageController.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please type a message first.')),
      );
      return;
    }
    if (state.isStaff) {
      state.sendClinicReply(text);
    } else {
      state.sendChatMessage(text);
    }
    _messageController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.isStaff
            ? 'Reply sent to the customer.'
            : 'Message sent to the clinic.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final messages = state.chatMessages;
    final isStaff = state.isStaff;
    // `isMe` is stored from the customer's perspective. When staff opens the
    // same shared thread, flip the sides so the clinic's replies are "mine".
    final quickReplies = isStaff
        ? const [
            'Your booking is confirmed.',
            'Please arrive 10 minutes early.',
            'Could you share your preferred time?',
          ]
        : const [
            'What is included?',
            'Do I need a referral?',
            'Book a slot',
          ];

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF007D68)),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFB5F0E6),
              child: Icon(
                isStaff ? Icons.person_outline : Icons.spa,
                size: 18,
                color: const Color(0xFF007D68),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isStaff ? 'Customer Chat' : 'JongSart Reception',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    isStaff ? 'REPLYING AS STAFF' : 'ONLINE',
                    style: const TextStyle(
                      color: Color(0xFF007D68),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'View clinic') {
                context.push('/clinic-detail?id=clinic_lumina');
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$value selected.')),
              );
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'View clinic', child: Text('View clinic')),
              PopupMenuItem(value: 'Mute chat', child: Text('Mute chat')),
            ],
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderGrey),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF0EE),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ...messages.map((message) => ChatBubble(
                      text: message.text,
                      isMe: isStaff ? !message.isMe : message.isMe,
                    )),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: quickReplies
                        .map(
                          (text) => Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: OutlinedButton(
                              onPressed: () {
                                _messageController.text = text;
                                _send();
                              },
                              child: Text(text),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: messageInput(
                      _messageController,
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _send,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primaryMint,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.send),
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
