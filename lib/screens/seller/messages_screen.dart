import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dialogs = [
      {'name': 'Алексей', 'msg': 'Здравствуйте! Актуально?', 'time': '10:24'},
      {'name': 'Марина', 'msg': 'Можно бронь до пятницы?', 'time': '09:10'},
      {'name': 'Samir', 'msg': 'Готов забрать сегодня', 'time': 'Вчера'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Сообщения')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dialogs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final d = dialogs[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: theme.colorScheme.primary.withOpacity(0.12), child: const Icon(Icons.person)),
              title: Text(d['name']!),
              subtitle: Text(d['msg']!),
              trailing: Text(d['time']!, style: theme.textTheme.labelSmall),
              onTap: () => _openChat(context, d['name']!),
            ),
          );
        },
      ),
    );
  }

  void _openChat(BuildContext context, String name) {
    final templates = ['Доступно', 'Забронировано', 'В пути'];
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Быстрые ответы для $name', style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: templates
                  .map((t) => OutlinedButton(onPressed: () {}, child: Text(t)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(hintText: 'Напишите сообщение...')),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.send), label: const Text('Отправить')),
            ),
          ],
        ),
      ),
    );
  }
}


