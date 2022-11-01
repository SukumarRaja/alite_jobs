import '../helpers/Constant.dart';

import 'package:flutter/material.dart';

extension CustomIcons on ColorScheme {
  String get homeIcon => this.brightness == Brightness.dark
      ? iconPath + 'home_dark.json'
      : iconPath + 'home_light.json';
  String get demoIcon => this.brightness == Brightness.dark
      ? iconPath + 'search_dark.json'
      : iconPath + 'search_light.json';
  String get settingsIcon => this.brightness == Brightness.dark
      ? iconPath + 'settings_dark.json'
      : iconPath + 'settings_light.json';
  String get accountIcon => this.brightness == Brightness.dark
      ? iconPath + 'user.svg'
      : iconPath + 'user.svg';
  String get splashLogo => iconPath + 'splash_logo.png';

  String get darkModeIcon => iconPath + 'darkmode.svg';

  String get aboutUsIcon => iconPath + 'aboutus.svg';

  String get privacyIcon => iconPath + 'privacy.svg';

  String get termsIcon => iconPath + 'terms.svg';

  String get shareIcon => iconPath + 'share.svg';

  String get rateUsIcon => iconPath + 'rateus.svg';

  String get noInternetIcon => iconPath + 'no_internet.svg';

}
