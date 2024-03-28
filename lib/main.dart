import 'dart:io';

import 'package:customerflow/constant/color_constant.dart';
import 'package:customerflow/ui/Splash/splash.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey =
  //     'pk_test_51MedQAFCatXUefOhO5ncew3NbXK0iKxJPXVu1Mf7Z1VqHF6yob98hpuwjhScJacLu856jlDo29e6W6wm5jOwbpHW00DEZqSjTc';
  await init();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAbeJH46hKqlBOxw4qV8YyuGKOuxIDUKnU",
            appId: "1:478923021746:ios:108948dfb7c974aab758ab",
            messagingSenderId: "478923021746",
            projectId: 'mile-vapeandhape-customerflow'));
  } else {
    await Firebase.initializeApp();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MaterialApp(
    color: whitecolor,
    home: MySplash(),
    debugShowCheckedModeBanner: false,
  ));
}
