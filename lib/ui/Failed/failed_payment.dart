import 'package:customerflow/constant/color_constant.dart';
import 'package:customerflow/constant/font_constant.dart';
import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/utils/button.dart';
import 'package:customerflow/utils/textwidget.dart';
import 'package:flutter/material.dart';

class MyPaymentFailed extends StatefulWidget {
  const MyPaymentFailed({super.key});

  @override
  State<MyPaymentFailed> createState() => _MyPaymentFailedState();
}

class _MyPaymentFailedState extends State<MyPaymentFailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 54.0, right: 53.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icFailed,
              width: 182.42,
              height: 175.08,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45.0),
              child: getTextWidget(
                  title: 'Payment Failed!',
                  textFontSize: fontSize20,
                  textFontWeight: fontWeightSemiBold,
                  textColor: background),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: getTextWidget(
                  title:
                      'Your payment has been failed please check payment method.',
                  textFontSize: fontSize14,
                  textAlign: TextAlign.center,
                  textFontWeight: fontWeightRegular,
                  textColor: background),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 31.0),
              child: CustomizeButton(
                  text: 'Check Payment',
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
