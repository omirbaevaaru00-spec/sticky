import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  // Синглтон
  static final LocaleController instance = LocaleController._();
  LocaleController._();

  Locale _locale = const Locale('ru');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}
