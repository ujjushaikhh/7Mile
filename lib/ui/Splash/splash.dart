import 'dart:async';

import 'package:customerflow/ui/Are%20you/are_you.dart';
import 'package:customerflow/ui/BottomTab/bottom_tab.dart';
import 'package:flutter/material.dart';

import '../../constant/color_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/sharedprefs.dart';
import '../login/login.dart';

class MySplash extends StatefulWidget {
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  void initState() {
    super.initState();
    _showSpalsh();
  }

  // bool isSeenIntro = getBool('seen');
  // var isUserlogin = getString('userlogin');

  _showSpalsh() {
    if (getBool('seen') == false) {
      debugPrint('Intro is not seen');
      Timer(const Duration(seconds: 3), () async {
        await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyAreYou()),
            (route) => false);
      });
    } else {
      debugPrint('Else part is Executed');
      debugPrint('userloginstatus ${getString('userlogin')}');
      if (getString('userlogin') == '0') {
        debugPrint('Intro is seen');
        debugPrint('user is not logged in');
        Timer(const Duration(seconds: 3), () async {
          await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyLogin()),
              (route) => false);
        });
      } else if (getString('userlogin') == '1') {
        debugPrint('Intro is seen');
        debugPrint('user is logged in');
        Timer(const Duration(seconds: 3), () async {
          await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyPrimaryBottomTab()),
              (route) => false);
        });
      } else {
        Timer(const Duration(seconds: 3), () async {
          await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyLogin()),
              (route) => false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: background,
            image: DecorationImage(
                image: AssetImage(icBackground), fit: BoxFit.cover)),
        child: Center(
            child: Image.asset(
          icLogo,
          width: 169,
          height: 109,
        )),
      ),
    );
  }
}
