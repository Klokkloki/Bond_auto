import 'package:image_picker/image_picker.dart';
import 'dart:io';

class KycService {
  static final ImagePicker _picker = ImagePicker();

  // Загрузить документ (паспорт, водительские права)
  static Future<File?> pickDocument() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw KycException('Ошибка загрузки документа: $e');
    }
  }

  // Загрузить селфи для верификации
  static Future<File?> pickSelfie() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw KycException('Ошибка загрузки селфи: $e');
    }
  }

  // Загрузить документ из галереи
  static Future<File?> pickDocumentFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw KycException('Ошибка загрузки документа: $e');
    }
  }

  // Валидация документа (базовая проверка)
  static bool validateDocument(File document) {
    // Здесь можно добавить базовую валидацию:
    // - проверка размера файла
    // - проверка формата
    // - проверка качества изображения

    if (!document.existsSync()) {
      return false;
    }

    // Проверяем размер файла (максимум 10MB)
    final fileSize = document.lengthSync();
    if (fileSize > 10 * 1024 * 1024) {
      return false;
    }

    return true;
  }

  // Отправить документы на верификацию (заглушка)
  static Future<KycResult> submitDocuments({
    required File passport,
    required File selfie,
    File? additionalDocument,
  }) async {
    try {
      // В реальном приложении здесь будет отправка на сервер
      // для обработки через внешний API (например, Jumio, Onfido)

      await Future.delayed(const Duration(seconds: 2)); // Имитация обработки

      // Заглушка - случайный результат
      final isApproved = DateTime.now().millisecond % 2 == 0;

      return KycResult(
        status: isApproved ? KycStatus.approved : KycStatus.pending,
        message: isApproved
            ? 'Документы успешно верифицированы'
            : 'Документы отправлены на проверку',
        submittedAt: DateTime.now(),
      );
    } catch (e) {
      return KycResult(
        status: KycStatus.rejected,
        message: 'Ошибка при отправке документов: $e',
        submittedAt: DateTime.now(),
      );
    }
  }
}

enum KycStatus {
  pending,
  approved,
  rejected,
}

class KycResult {
  final KycStatus status;
  final String message;
  final DateTime submittedAt;

  KycResult({
    required this.status,
    required this.message,
    required this.submittedAt,
  });
}

class KycException implements Exception {
  final String message;
  KycException(this.message);

  @override
  String toString() => 'KycException: $message';
}
