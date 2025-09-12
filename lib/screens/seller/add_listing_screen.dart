import 'package:flutter/material.dart';

class AddListingScreen extends StatelessWidget {
  const AddListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить авто')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionHeader(icon: Icons.photo_library_outlined, title: 'Фото и видео', subtitle: 'Минимум 5 фото'),
          _UploaderPlaceholder(),
          SizedBox(height: 16),
          _SectionHeader(icon: Icons.key_outlined, title: 'VIN и характеристики', subtitle: 'Автозаполнение по VIN'),
          _VinForm(),
          SizedBox(height: 16),
          _SectionHeader(icon: Icons.attach_money, title: 'Цена', subtitle: 'Укажите стоимость и валюту'),
          _PriceForm(),
          SizedBox(height: 16),
          _SectionHeader(icon: Icons.place_outlined, title: 'Местоположение', subtitle: 'Город и страна'),
          _LocationForm(),
          SizedBox(height: 16),
          _SectionHeader(icon: Icons.tune, title: 'Доп. параметры', subtitle: 'Торг, гарантия и др.'),
          _OptionsForm(),
          SizedBox(height: 16),
          _PublishButton(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  const _SectionHeader({required this.icon, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              if (subtitle != null)
                Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}

class _UploaderPlaceholder extends StatelessWidget {
  const _UploaderPlaceholder();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.35)),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_upload_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Загрузить 5+ фото (демо)'),
          ],
        ),
      ),
    );
  }
}

class _VinForm extends StatelessWidget {
  const _VinForm();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: 'VIN', hintText: 'WVWZZZ...')),
        SizedBox(height: 8),
        _DoubleField(leftLabel: 'Марка', rightLabel: 'Модель'),
      ],
    );
  }
}

class _PriceForm extends StatelessWidget {
  const _PriceForm();
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(child: TextField(decoration: InputDecoration(labelText: 'Цена', hintText: 'Напр. 25 000'))),
      const SizedBox(width: 12),
      Expanded(
        child: DropdownButtonFormField<String>(
          items: const [DropdownMenuItem(value: 'EUR', child: Text('EUR')), DropdownMenuItem(value: 'USD', child: Text('USD')), DropdownMenuItem(value: 'KZT', child: Text('KZT'))],
          onChanged: (_) {},
          decoration: const InputDecoration(labelText: 'Валюта'),
        ),
      ),
    ]);
  }
}

class _LocationForm extends StatelessWidget {
  const _LocationForm();
  @override
  Widget build(BuildContext context) {
    return const _DoubleField(leftLabel: 'Страна', rightLabel: 'Город');
  }
}

class _OptionsForm extends StatelessWidget {
  const _OptionsForm();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SwitchListTile(value: true, onChanged: null, title: Text('Торг уместен')),
        SwitchListTile(value: false, onChanged: null, title: Text('Официальная гарантия')),
      ],
    );
  }
}

class _PublishButton extends StatelessWidget {
  const _PublishButton();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Опубликовать'),
      ),
    );
  }
}

class _DoubleField extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  const _DoubleField({required this.leftLabel, required this.rightLabel});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: TextField(decoration: InputDecoration(labelText: leftLabel))),
      const SizedBox(width: 12),
      Expanded(child: TextField(decoration: InputDecoration(labelText: rightLabel))),
    ]);
  }
}


