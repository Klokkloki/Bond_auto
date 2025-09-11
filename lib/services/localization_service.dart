import 'package:flutter/material.dart';

class LocalizationService extends ChangeNotifier {
  Locale _currentLocale = const Locale('ru', 'RU');

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'kz':
        return 'Қазақша';
      default:
        return 'Русский';
    }
  }

  String getCurrentLanguageName() {
    return getLanguageName(_currentLocale.languageCode);
  }

  List<Locale> get supportedLocales => const [
    Locale('ru', 'RU'),
    Locale('en', 'US'),
    Locale('de', 'DE'),
    Locale('kz', 'KZ'),
  ];
}




