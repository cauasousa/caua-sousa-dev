import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiChatBubble extends StatefulWidget {
  const AiChatBubble({super.key});

  @override
  State<AiChatBubble> createState() => _AiChatBubbleState();
}

class _AiChatBubbleState extends State<AiChatBubble>
    with TickerProviderStateMixin { 
  bool _isOpen = false;
  late final AnimationController _panelController;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;

  late final AnimationController _thinkingController;

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); 
  final List<_ChatMessage> _messages = [];

  static const int _maxCharacterLimit = 150;

  final List<String> _apiUrls = [
    'http://127.0.0.1:8000/chat', // Local 
    'https://portfolio-ai-backend-xxm2.onrender.com/chat', // Deploy 
  ];
  
  final int _selectedApiIndex = 1;

  @override
  void initState() {
    super.initState();
    
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _panelController, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _panelController, curve: Curves.easeOutCubic),
    );

    _thinkingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _toggleChat();
      
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            _messages.add(_ChatMessage(
              text: "Hi! I'm Cauã's AI assistant. Ask me about his projects or skills!",
              status: MessageStatus.text,
            ));
          });
          _scrollToBottom();
        }
      });
    });
  }

  @override
  void dispose() {
    _panelController.dispose();
    _thinkingController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _panelController.forward();
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      } else {
        _panelController.reverse();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendApiMessage(String userMessage) async {
    final apiUrl = _apiUrls[_selectedApiIndex];

    try {
      
      final responses = await Future.wait([
        http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'message': userMessage}),
        ).timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('The request exceeded the time limit. Please try again later.');
          },
        ),
        Future.delayed(const Duration(seconds: 1)), 
      ]);

      final response = responses[0] as http.Response;

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final aiResponse = data['response'] ?? "No response generated.";

        if (mounted) {
          setState(() {
            if (_messages.isNotEmpty && _messages.last.status == MessageStatus.thinking) {
              _messages.last.text = aiResponse;
              _messages.last.status = MessageStatus.text;
            }
          });
          _scrollToBottom();
        }
      } else {
        throw Exception('Error in server: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (_messages.isNotEmpty && _messages.last.status == MessageStatus.thinking) {
            _messages.last.text = "Sorry, I couldn't process that right now. Please make sure the backend is running.";
            _messages.last.status = MessageStatus.error;
          }
        });
        _scrollToBottom();
      }
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true, status: MessageStatus.text));
      _textController.clear();
      _messages.add(_ChatMessage(status: MessageStatus.thinking));
    });
    
    
    _scrollToBottom();

    _sendApiMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Positioned(
          bottom: 80,
          right: 24,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: 360,
                height: 480,
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF1E293B)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF34D399).withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.smart_toy_outlined, color: Color(0xFF34D399), size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Cauã AI Assistant',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
                            onPressed: _toggleChat,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController, 
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          return _buildMessageBubble(msg);
                        },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0A0A0A),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              maxLength: _maxCharacterLimit,
                              decoration: InputDecoration(
                                hintText: 'Ask something...',
                                counterText: "",
                                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                                filled: true,
                                fillColor: const Color(0xFF1E293B),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(color: Color(0xFF34D399), width: 1),
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                              onPressed: _sendMessage,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 24,
          right: 24,
          child: GestureDetector(
            onTap: _toggleChat,
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34D399).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                _isOpen ? Icons.close : Icons.chat_bubble_outline,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    if (msg.status == MessageStatus.thinking) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _thinkingController,
                builder: (context, child) {
                  double offset = 0;
                  double opacity = 0.3;
                  
                  if (_thinkingController.value >= (index * 0.2)) {
                    final double progress = (_thinkingController.value - (index * 0.2)) / 0.6;
                    offset = (-4 * progress).clamp(-4.0, 0.0); 
                    opacity = (0.3 + (0.7 * progress)).clamp(0.3, 1.0);  
                  }
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    transform: Transform.translate(offset: Offset(0, offset)).transform,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFF34D399).withValues(alpha: opacity),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      );
    }

    Color bgColor = msg.isUser ? const Color(0xFF34D399) : const Color(0xFF1E293B);
    Color txtColor = msg.isUser ? Colors.black : const Color(0xFFE2E8F0);
    if (msg.status == MessageStatus.error) {
      bgColor = const Color(0xFF7F1D1D).withValues(alpha: 0.6); 
      txtColor = const Color(0xFFFCA5A5); 
    }

    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (msg.status == MessageStatus.error)
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 1),
                child: Icon(Icons.warning_amber_rounded, color: txtColor, size: 16),
              ),
            Expanded(
              child: Text(
                msg.text,
                style: TextStyle(
                  color: txtColor,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MessageStatus { thinking, text, error }

class _ChatMessage {
  String text;
  bool isUser;
  MessageStatus status;

  _ChatMessage({this.text = '', this.isUser = false, this.status = MessageStatus.text});
}