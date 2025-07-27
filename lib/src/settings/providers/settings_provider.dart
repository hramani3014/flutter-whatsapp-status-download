import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_status/core/enums/status_directory.dart';
import 'package:whatsapp_status/src/settings/stats/settings_state.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier()..initPrefs(),
);

class SettingsNotifier extends StateNotifier<SettingsState> {
  SharedPreferences? _prefs;

  SettingsNotifier() : super(SettingsState.initial());

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await initSettings();
  }

  Future<void> initSettings() async {
    final languageCode = _prefs?.getString('languageCode');
    final themeModeIndex = _prefs?.getInt('themeMode') ?? 0;
    final whatsappPref = _prefs?.getString('whatsapp');

    StatusDirectory selectedDir = StatusDirectory.whatsapp;
    if (whatsappPref == StatusDirectory.whatsappBusiness.toString()) {
      selectedDir = StatusDirectory.whatsappBusiness;
    }

    final Directory statusDir = selectedDir.directory;
    final bool isWhatsapp = selectedDir == StatusDirectory.whatsapp;
    final bool isWhatsappBusiness = selectedDir == StatusDirectory.whatsappBusiness;

    final themeMode = ThemeMode.values[themeModeIndex];

    state = state.copyWith(
      locale: languageCode != null ? Locale(languageCode) : null,
      statusDirectory: statusDir,
      themeMode: themeMode,
      isDarkMode: themeMode == ThemeMode.dark,
      isWhatsapp: isWhatsapp,
      isWhatsappBusiness: isWhatsappBusiness,
    );
  }

  void setStatusDir(StatusDirectory dir) {
    final Directory statusDir = dir.directory;
    final bool isWhatsapp = dir == StatusDirectory.whatsapp;
    final bool isWhatsappBusiness = dir == StatusDirectory.whatsappBusiness;

    state = state.copyWith(
      statusDirectory: statusDir,
      isWhatsapp: isWhatsapp,
      isWhatsappBusiness: isWhatsappBusiness,
    );

    _prefs?.setString('whatsapp', dir.toString());
  }

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
    _prefs?.setString('languageCode', locale.languageCode);
  }

  void toggleTheme(bool isDarkMode) {
    final themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(themeMode: themeMode, isDarkMode: isDarkMode);
    _prefs?.setInt('themeMode', themeMode.index);
  }

  bool get isDarkMode {
    if (state.themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return state.themeMode == ThemeMode.dark;
  }
}
