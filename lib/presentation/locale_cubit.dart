import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale?> {
  static const String _localeKey = 'app_locale';
  final SharedPreferences _prefs;

  LocaleCubit(this._prefs) : super(null) {
    _loadLocale();
  }

  void _loadLocale() {
    final languageCode = _prefs.getString(_localeKey);
    if (languageCode != null) {
      emit(Locale(languageCode));
    } else {
      emit(null); // Follow system
    }
  }

  Future<void> setLocale(String languageCode) async {
    await _prefs.setString(_localeKey, languageCode);
    emit(Locale(languageCode));
  }

  Future<void> setSystemLocale() async {
    await _prefs.remove(_localeKey);
    emit(null);
  }

  bool get isChinese => state?.languageCode == 'zh';
}
