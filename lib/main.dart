// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/navigationBarProvider.dart';
import '../helpers/Constant.dart';
import '../screens/main_screen.dart';
import '../widgets/admob_service.dart';
import '../provider/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/main_screen_bottom_bar.dart';
import 'screens/settings_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'msg_channel', // id
    'High Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //when we have to communicate to flutter framework before initializing app

  if (showInterstitialAds) {
    AdMobService.initialize();
  }

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  bool isNavVisible = true;
  int counter = 0;
  SharedPreferences.getInstance().then((prefs) {
    prefs.setInt('counter', counter);
    var isDarkTheme =
        prefs.getBool("isDarkTheme") ?? ThemeMode.system == ThemeMode.dark
            ? true
            : false;
    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: MyApp(),
        create: (BuildContext context) {
          return ThemeProvider(isDarkTheme);
        },
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    if (showSplashScreen) {
      startTimer();
    }
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return Timer(
        duration,
        () => navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (_) =>
                showBottomNavigationBar ? MainScreen() : MyHomePage())));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      /* start--commnet  below 2 lines to enable landscape mode */
      DeviceOrientation
          .landscapeLeft, 
      DeviceOrientation
          .landscapeRight 
         /*end */
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationBarProvider>(
            create: (_) => NavigationBarProvider())
      ],
      child: Consumer<ThemeProvider>(builder: (context, value, child) {
        return MaterialApp(
          title: appName,
          debugShowCheckedModeBanner: false,
          themeMode: value.getTheme(),
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          navigatorKey: navigatorKey,
          home:showBottomNavigationBar
                  ? MainScreen()
                  : MyHomePage(),
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case 'home':
                return MaterialPageRoute(builder: (_) => HomeScreen());
              case 'settings':
                return MaterialPageRoute(builder: (_) => SettingsScreen());
            }
            return null;
          },
        );
      }),
    );
  }
}
