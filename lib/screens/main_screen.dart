import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../helpers/Constant.dart';
import '../provider/navigationBarProvider.dart';
import '../screens/home_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  late AnimationController navigationContainerAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500));

  @override
  void dispose() {
    navigationContainerAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context
          .read<NavigationBarProvider>()
          .setAnimationController(navigationContainerAnimationController);
    });
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await OneSignal.shared.setAppId(
        Platform.isAndroid ? oneSignalAndroidAppId : oneSignalIOSAppId);
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print(
          'NOTIFICATION OPENED HANDLER CALLED WITH: ${result.notification.launchUrl}');
      if (result.notification.launchUrl != null) {
        setState(() {
          webinitialUrl = result.notification.launchUrl.toString();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => MyHomePage()),
            (route) => false,
          );
        });
      }
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      setState(() {
        print(
            "Notification received in foreground notification: \n${event.notification.launchUrl}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () => _navigateBack(context),
      child: SafeArea(
        child: Scaffold(
          extendBody: false,
          body: Navigator(
            key: _homeNavigatorKey,
            initialRoute: 'home',
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(builder: (_) => HomeScreen());
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _navigateBack(BuildContext context) async {
    if (mounted) {
      if (!context
          .read<NavigationBarProvider>()
          .animationController
          .isAnimating) {
        context.read<NavigationBarProvider>().animationController.reverse();
      }
    }
    final isFirstRouteInCurrentTab =
        !await _homeNavigatorKey.currentState!.maybePop();

    if (!isFirstRouteInCurrentTab) {
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Do you want to exit app?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ));

      return Future.value(true);
    }
  }
}
