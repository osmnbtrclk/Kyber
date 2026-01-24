import 'dart:ui';

import 'package:jiffy/jiffy.dart' hide Locale;
import 'package:kyber_launcher/core/services/app_settings.dart';
import 'package:logging/logging.dart';

class AppLocale {
  AppLocale._();

  static Locale getLocale() {
    try {
      return Locale.fromSubtags(
        languageCode: Preferences.general.locale,
      );
    } catch (e, s) {
      Logger.root.severe('Failed to get locale', e, s);
      return const Locale.fromSubtags(languageCode: 'en-US');
    }
  }

  static Future<void> setLocale(Locale locale) async {
    await Jiffy.setLocale(locale.languageCode);
    Preferences.general.locale = locale.toString();
  }
}
