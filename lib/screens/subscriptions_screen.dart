import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подписки'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderBanner(theme: theme),
          const SizedBox(height: 16),
          _PlanCard(
            title: 'Старт',
            price: '0 ₸',
            period: 'навсегда',
            highlight: false,
            features: const [
              'Базовый поиск и фильтры',
              'Просмотр карточек авто',
              'Чат по активной сделке',
            ],
            cta: 'Использовать',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          _PlanCard(
            title: 'Премиум',
            price: '4 990 ₸',
            period: 'в месяц',
            highlight: true,
            badge: 'Рекомендуем',
            features: const [
              'Расширенные фильтры и подбор',
              'Доступ к закрытым предложениям',
              'Приоритетная поддержка',
              'Уведомления по новым авто',
            ],
            cta: 'Оформить Премиум',
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          _PlanCard(
            title: 'Профи',
            price: '14 990 ₸',
            period: 'в месяц',
            highlight: false,
            features: const [
              'Все из Премиум + Аналитика',
              'Управление командами (для дилеров)',
              'API/экспорт заявок',
              'Персональный менеджер',
            ],
            cta: 'Оформить Профи',
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          _FaqBlock(theme: theme),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  final ThemeData theme;
  const _HeaderBanner({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.10),
            theme.colorScheme.secondary.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Выберите подходящую подписку', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  'Получите доступ к закрытым предложениям, аналитике и приоритетной поддержке.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.workspace_premium_rounded, size: 40, color: theme.colorScheme.primary),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final bool highlight;
  final String? badge;
  final List<String> features;
  final String cta;
  final VoidCallback onPressed;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.highlight,
    this.badge,
    required this.features,
    required this.cta,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.25)),
                  ),
                  child: Text(badge!, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(width: 6),
              Text(period, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 12),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: highlight ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(f, style: theme.textTheme.bodyMedium)),
              ],
            ),
          )),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: highlight ? theme.colorScheme.primary : theme.colorScheme.surface,
                foregroundColor: highlight ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(cta, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqBlock extends StatelessWidget {
  final ThemeData theme;
  const _FaqBlock({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.35)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Вопросы и ответы', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          _qa('Как отменить подписку?', 'Вы можете отменить её в любой момент — доступ останется до конца оплаченного периода.'),
          const SizedBox(height: 8),
          _qa('Можно ли перейти с Премиум на Профи?', 'Да, апгрейд активируется сразу, доплата считается пропорционально оставшимся дням.'),
          const SizedBox(height: 8),
          _qa('Поддержка каких способов оплаты?', 'Банковские карты, Apple/Google Pay (при наличии), счета для юридических лиц.'),
        ],
      ),
    );
  }

  Widget _qa(String q, String a) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(a),
      ],
    );
  }
}


