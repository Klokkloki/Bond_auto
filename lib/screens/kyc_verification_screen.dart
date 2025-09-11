import 'package:flutter/material.dart';
import 'dart:io';
import '../services/kyc_service.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  File? _passportImage;
  File? _selfieImage;
  File? _additionalDocument;
  bool _isLoading = false;
  KycStatus? _kycStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Верификация личности'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Text(
              'Подтвердите свою личность',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Загрузите документы для верификации аккаунта',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 32),

            // Статус верификации
            if (_kycStatus != null) ...[
              _buildStatusCard(theme),
              const SizedBox(height: 24),
            ],

            // Паспорт
            _buildDocumentCard(
              title: 'Паспорт или удостоверение личности',
              subtitle: 'Загрузите фото главной страницы паспорта',
              image: _passportImage,
              onTap: () => _pickDocument(KycDocumentType.passport),
              theme: theme,
            ),

            const SizedBox(height: 16),

            // Селфи
            _buildDocumentCard(
              title: 'Фото для сравнения',
              subtitle: 'Сделайте селфи для сравнения с документом',
              image: _selfieImage,
              onTap: () => _pickDocument(KycDocumentType.selfie),
              theme: theme,
            ),

            const SizedBox(height: 16),

            // Дополнительный документ (опционально)
            _buildDocumentCard(
              title: 'Дополнительный документ (опционально)',
              subtitle: 'Водительские права, справка и т.д.',
              image: _additionalDocument,
              onTap: () => _pickDocument(KycDocumentType.additional),
              theme: theme,
              isOptional: true,
            ),

            const SizedBox(height: 32),

            // Кнопка отправки
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSubmit() && !_isLoading ? _submitDocuments : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Отправить на верификацию'),
              ),
            ),

            const SizedBox(height: 16),

            // Информация о безопасности
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ваши документы защищены и используются только для верификации',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (_kycStatus!) {
      case KycStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        statusText = 'На проверке';
        break;
      case KycStatus.approved:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Одобрено';
        break;
      case KycStatus.rejected:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Отклонено';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 12),
          Text(
            'Статус верификации: $statusText',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required String subtitle,
    required File? image,
    required VoidCallback onTap,
    required ThemeData theme,
    bool isOptional = false,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isOptional) ...[
                              const SizedBox(width: 8),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Опционально',
                                    style: theme.textTheme.labelSmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    image != null ? Icons.check_circle : Icons.add_circle_outline,
                    color: image != null
                        ? Colors.green
                        : theme.colorScheme.primary,
                  ),
                ],
              ),
              if (image != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    image,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDocument(KycDocumentType type) async {
    try {
      File? image;

      switch (type) {
        case KycDocumentType.passport:
          image = await KycService.pickDocument();
          break;
        case KycDocumentType.selfie:
          image = await KycService.pickSelfie();
          break;
        case KycDocumentType.additional:
          image = await KycService.pickDocumentFromGallery();
          break;
      }

      if (image != null && KycService.validateDocument(image)) {
        setState(() {
          switch (type) {
            case KycDocumentType.passport:
              _passportImage = image;
              break;
            case KycDocumentType.selfie:
              _selfieImage = image;
              break;
            case KycDocumentType.additional:
              _additionalDocument = image;
              break;
          }
        });
      } else if (image != null) {
        _showError('Неверный формат документа. Попробуйте другой файл.');
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  bool _canSubmit() {
    return _passportImage != null && _selfieImage != null;
  }

  Future<void> _submitDocuments() async {
    if (!_canSubmit()) return;

    setState(() => _isLoading = true);

    try {
      final result = await KycService.submitDocuments(
        passport: _passportImage!,
        selfie: _selfieImage!,
        additionalDocument: _additionalDocument,
      );

      setState(() {
        _kycStatus = result.status;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.status == KycStatus.approved
              ? Colors.green
              : result.status == KycStatus.rejected
              ? Colors.red
              : Colors.orange,
        ),
      );
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

enum KycDocumentType {
  passport,
  selfie,
  additional,
}
