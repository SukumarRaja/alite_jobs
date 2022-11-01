// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';

import '../helpers/Icons.dart';
import '../main.dart';
import '../widgets/no_internet.dart';
import '../provider/navigationBarProvider.dart';
import '../widgets/no_internet_widget.dart';
import '../helpers/Constant.dart';
import '../widgets/load_web_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController navigationContainerAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500));
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      context
          .read<NavigationBarProvider>()
          .setAnimationController(navigationContainerAnimationController);
    });
  }

  @override
  void dispose() {
    navigationContainerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Column(children: [
          Flexible(child: LoadWebView(webinitialUrl, true)),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                CurvedAnimation(
                    parent: navigationContainerAnimationController,
                    curve: Curves.easeInOut)),
            child: SlideTransition(
                position: Tween<Offset>(
                        begin: Offset.zero, end: const Offset(0.0, 1.0))
                    .animate(CurvedAnimation(
                        parent: navigationContainerAnimationController,
                        curve: Curves.easeInOut)),
                child: FloatingActionButton(
                  child: Lottie.asset(
                    Theme.of(context).colorScheme.settingsIcon,
                    height: 30,
                    repeat: true,
                  ),
                  onPressed: () {
                    setState(() {
                      navigatorKey.currentState!.pushNamed('settings');
                    });
                  },
                ))));
  }
}
