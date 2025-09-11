import 'package:flutter/material.dart';
import '../models/deal.dart';

class DealChat extends StatefulWidget {
  final Deal deal;

  const DealChat({super.key, required this.deal});

  @override
  State<DealChat> createState() => _DealChatState();
}

class _DealChatState extends State<DealChat> {
  final TextEditingController _messageController = TextEditingController();
  final List<DealMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // Загружаем сообщения из сделки
    _messages.addAll(widget.deal.messages);
    
    // Добавляем системные сообщения для демонстрации
    if (_messages.isEmpty) {
      _messages.addAll([
        DealMessage(
          id: '1',
          dealId: widget.deal.id,
          senderId: 'system',
          message: 'Сделка создана. Ожидается подтверждение от всех участников.',
          originalLanguage: 'ru',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          isSystem: true,
        ),
        DealMessage(
          id: '2',
          dealId: widget.deal.id,
          senderId: 'buyer',
          message: 'Здравствуйте! Интересует этот автомобиль. Можно ли получить дополнительную информацию?',
          originalLanguage: 'ru',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        DealMessage(
          id: '3',
          dealId: widget.deal.id,
          senderId: 'seller',
          message: 'Конечно! Автомобиль в отличном состоянии, один владелец. Могу предоставить все документы.',
          originalLanguage: 'ru',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _buildMessageBubble(message);
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageBubble(DealMessage message) {
    final isSystem = message.isSystem;
    final isFromCurrentUser = message.senderId == 'buyer'; // Заглушка

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isFromCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isFromCurrentUser && !isSystem) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSystem
                    ? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.35)
                    : isFromCurrentUser
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.20)
                        : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSystem)
                    Row(
                      children: [
                        Icon(Icons.info, size: 16, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Система',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      _getSenderName(message.senderId),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    message.message,
                    style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromCurrentUser && !isSystem) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.25),
              child: Icon(Icons.person, size: 16, color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Написать сообщение...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.35),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final message = DealMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dealId: widget.deal.id,
        senderId: 'buyer',
        message: _messageController.text.trim(),
        originalLanguage: 'ru',
        createdAt: DateTime.now(),
      );

      setState(() {
        _messages.add(message);
      });

      _messageController.clear();
    }
  }

  String _getSenderName(String senderId) {
    switch (senderId) {
      case 'buyer':
        return 'Покупатель';
      case 'seller':
        return 'Продавец';
      case 'logistics':
        return 'Логист';
      case 'broker':
        return 'Брокер';
      default:
        return 'Участник';
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}д назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}ч назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}м назад';
    } else {
      return 'только что';
    }
  }
}
