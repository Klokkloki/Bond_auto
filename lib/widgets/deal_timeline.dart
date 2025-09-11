import 'package:flutter/material.dart';
import '../models/deal.dart';

class DealTimeline extends StatelessWidget {
  final Deal deal;

  const DealTimeline({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Статус сделки',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimelineItem(
            'Сделка создана',
            'Сделка успешно создана и ожидает подтверждения',
            DealStatus.created,
            true,
            theme,
          ),
          _buildTimelineItem(
            'Ожидание платежа',
            'Ожидается подтверждение платежа от покупателя',
            DealStatus.paymentPending,
            deal.status.index >= DealStatus.paymentPending.index,
            theme,
          ),
          _buildTimelineItem(
            'Автомобиль куплен',
            'Автомобиль успешно приобретен у продавца',
            DealStatus.carPurchased,
            deal.status.index >= DealStatus.carPurchased.index,
            theme,
          ),
          _buildTimelineItem(
            'В пути',
            'Автомобиль находится в пути к месту назначения',
            DealStatus.inTransit,
            deal.status.index >= DealStatus.inTransit.index,
            theme,
          ),
          _buildTimelineItem(
            'На таможне',
            'Автомобиль проходит таможенное оформление',
            DealStatus.atCustoms,
            deal.status.index >= DealStatus.atCustoms.index,
            theme,
          ),
          _buildTimelineItem(
            'Регистрация',
            'Оформление документов и регистрация',
            DealStatus.registration,
            deal.status.index >= DealStatus.registration.index,
            theme,
          ),
          _buildTimelineItem(
            'Завершено',
            'Сделка успешно завершена',
            DealStatus.completed,
            deal.status == DealStatus.completed,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      String title,
      String description,
      DealStatus status,
      bool isCompleted,
      ThemeData theme,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCompleted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: isCompleted
                ? Icon(
              Icons.check,
              size: 12,
              color: theme.colorScheme.onPrimary,
            )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                    color: isCompleted
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
