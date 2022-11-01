// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import '../helpers/Strings.dart';
import '../helpers/Icons.dart';
import '../helpers/Constant.dart';
import '../widgets/admob_service.dart';
import '../widgets/change_theme_button_widget.dart';
import 'webview_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen();

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    if (showInterstitialAds) {
      // AdMobService.createInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: !showBottomNavigationBar
          ? FloatingActionButton(
        child: Lottie.asset(
          Theme.of(context).colorScheme.homeIcon,
          height: 30,
          repeat: true,
        ),
        onPressed: () {
          setState(() {
            Navigator.of(context).pop();
          });
        },
      )
          : null,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading:
                  _buildIcon(Theme.of(context).colorScheme.darkModeIcon),
                  title: _buildTitle(CustomStrings.darkMode),
                  trailing: ChangeThemeButtonWidget(),
                ),
                ListTile(
                    leading:
                    _buildIcon(Theme.of(context).colorScheme.aboutUsIcon),
                    title: _buildTitle(CustomStrings.callLogs),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onTap: () => _onPressed(WebviewScreen(CustomStrings.callLogs,
                        CustomStrings.callLogsContent, callLogsUrl))),

                ListTile(
                    leading:
                    _buildIcon(Theme.of(context).colorScheme.privacyIcon),
                    title: _buildTitle(CustomStrings.webSite),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onTap: () => _onPressed(WebviewScreen(CustomStrings.webSite,
                        CustomStrings.callLogsContent, webSiteUrl))),
                // ListTile(
                //     leading:
                //     _buildIcon(Theme.of(context).colorScheme.privacyIcon),
                //     title: _buildTitle(CustomStrings.privacyPolicy),
                //     trailing: Icon(
                //       Icons.arrow_forward_ios_rounded,
                //       color: Theme.of(context).iconTheme.color,
                //     ),
                //     onTap: () => _onPressed(WebviewScreen(
                //         CustomStrings.privacyPolicy,
                //         CustomStrings.privacyPageContent,
                //         privacyPageURL))),
                // ListTile(
                //     leading:
                //     _buildIcon(Theme.of(context).colorScheme.termsIcon),
                //     title: _buildTitle(CustomStrings.terms),
                //     trailing: Icon(
                //       Icons.arrow_forward_ios_rounded,
                //       color: Theme.of(context).iconTheme.color,
                //     ),
                //     onTap: () => _onPressed(WebviewScreen(CustomStrings.terms,
                //         CustomStrings.termsPageContent, termsPageURL))),
                ListTile(
                  leading: _buildIcon(Theme.of(context).colorScheme.shareIcon),
                  title: _buildTitle(CustomStrings.share),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onTap: () => Share.share(
                      Platform.isAndroid
                          ? shareAndroidAppMessge
                          : shareiOSAppMessage,
                      subject: Platform.isAndroid
                          ? shareAndroidAppMessge
                          : shareiOSAppMessage),
                ),
                ListTile(
                    leading:
                    _buildIcon(Theme.of(context).colorScheme.rateUsIcon),
                    title: _buildTitle(CustomStrings.rateUs),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    // onTap: () => StoreRedirect.redirect(
                    //     androidAppId: androidAppId, iOSAppId: iOSAppId)



                )
              ],
            ),
          )),
    );
  }

  Widget _buildIcon(String icon) {
    return SvgPicture.asset(
      icon,
      width: 20,
      height: 20,
      color: Theme.of(context).iconTheme.color,
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.subtitle1,
    );
  }

  void _onPressed(Widget routeName) {
    if (showInterstitialAds) {
      AdMobService.showInterstitialAd();
    }
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) => routeName));
  }
}
