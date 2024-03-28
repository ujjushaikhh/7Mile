import 'package:customerflow/constant/color_constant.dart';
import 'package:customerflow/constant/font_constant.dart';
import 'package:customerflow/ui/Intro/intro_screen.dart';
import 'package:customerflow/utils/dailog.dart';
import 'package:customerflow/utils/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constant/image_constant.dart';

class MyAreYou extends StatefulWidget {
  const MyAreYou({super.key});

  @override
  State<MyAreYou> createState() => _MyAreYouState();
}

class _MyAreYouState extends State<MyAreYou> {
  bool isYes = false;
  bool isNo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: background,
            image: DecorationImage(
                image: AssetImage(icBackground), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getLogo(),
            Padding(
              padding: const EdgeInsets.only(top: 29.0),
              child: getTextWidget(
                  title: 'Are you 18 older?',
                  textFontSize: fontSize25,
                  textFontWeight: fontWeightBold,
                  textColor: whitecolor),
            ),
            getYesNo(context),
            getContinue()
          ],
        ),
      ),
    );
  }

  Widget getYesNo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isYes = false;
                isNo = true;
              });
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 3.5,
              decoration: BoxDecoration(
                color: isNo == true ? greencolor : whitecolor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: getTextWidget(
                    title: 'No',
                    textColor: background,
                    textFontSize: fontSize16,
                    textFontWeight: fontWeightMedium),
              ),
            ),
          ),
          const SizedBox(
            width: 18.0,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isNo = false;
                isYes = true;
              });
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 3.5,
              decoration: BoxDecoration(
                color: isYes == true ? greencolor : whitecolor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: getTextWidget(
                    title: 'Yes',
                    textColor: background,
                    textFontSize: fontSize16,
                    textFontWeight: fontWeightMedium),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getLogo() {
    return Container(
      width: 169,
      height: 109,
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(icLogo), fit: BoxFit.cover)),
    );
  }

  Widget getContinue() {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: GestureDetector(
        onTap: () {
          if (isNo == true) {
            vapeAlertDialogue(
                context: context,
                type: AlertType.info,
                desc: "You have not permission to open the app",
                onPressed: () {
                  Navigator.pop(context);
                }).show();
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyIntro()),
                (route) => false);
          }
        },
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width / 2.7,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(width: 1, color: whitecolor)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                  title: 'Contniue',
                  textFontWeight: fontWeightRegular,
                ),
                Image.asset(
                  icNext,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
