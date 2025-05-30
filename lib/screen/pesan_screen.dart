import 'package:flutter/material.dart';
import 'package:whazlansaja/dosen.dart';

class PesanScreen extends StatefulWidget {
  final Dosen dosen;

  const PesanScreen({super.key, required this.dosen});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  late List<ChatDetail> _chats;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chats = widget.dosen.details;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _chats.add(ChatDetail(
        role: 'saya',
        message: _messageController.text,
      ));
      _messageController.clear();
    });
    
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _chats.add(ChatDetail(
            role: 'dosen',
            message: 'Pesan sudah diterima, terima kasih.',
          ));
          _scrollToBottom();
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: AssetImage(widget.dosen.img),
            radius: 16,
          ),
          title: Text(
            widget.dosen.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: const Text('Online'),
        ),
        actions: const [
          IconButton(icon: Icon(Icons.video_call), onPressed: null),
          IconButton(icon: Icon(Icons.call), onPressed: null),
          IconButton(icon: Icon(Icons.more_vert), onPressed: null),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                final isDosen = chat.role == 'dosen';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: isDosen
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (isDosen)
                        CircleAvatar(
                          backgroundImage: AssetImage(widget.dosen.img),
                          radius: 14,
                        ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin:
                              const EdgeInsets.symmetric(horizontal: 10),
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.65,
                          ),
                          decoration: BoxDecoration(
                            color: isDosen
                                ? colorScheme.tertiary
                                : colorScheme.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft:
                                  Radius.circular(isDosen ? 0 : 12),
                              bottomRight:
                                  Radius.circular(isDosen ? 12 : 0),
                            ),
                          ),
                          child: Text(
                            chat.message,
                            style: TextStyle(
                              color: isDosen
                                  ? colorScheme.onTertiary
                                  : colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      if (!isDosen)
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/user.png'),
                          radius: 14,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.emoji_emotions),
                      hintText: 'Ketikkan pesan',
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:  NavigationBar(
        selectedIndex: 0,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.sync),
            label: 'Pembaruan',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups),
            label: 'Komunitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.call),
            label: 'Panggilan',
          ),
        ],
      ),
    );
  }
}