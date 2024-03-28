import 'package:customerflow/constant/color_constant.dart';
import 'package:customerflow/constant/font_constant.dart';
import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/utils/textwidget.dart';
import 'package:flutter/material.dart';

class MyPayment extends StatefulWidget {
  const MyPayment({super.key});

  @override
  State<MyPayment> createState() => _MyPaymentState();
}

class _MyPaymentState extends State<MyPayment> {
  bool isCheck = false;
  final List payment = [
    {'icon': icPaypal, 'name': 'Paypal', 'ischeck': false},
    {'icon': icCreditcard, 'name': 'Credit Card', 'ischeck': false},
    {'icon': icApple, 'name': 'Apple Pay', 'ischeck': false}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        backgroundColor: background,
        centerTitle: true,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: getTextWidget(
              title: 'Payment Options',
              textFontSize: fontSize15,
              textFontWeight: fontWeightSemiBold,
              textColor: whitecolor),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24.0,
                color: whitecolor,
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: payment.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        for (int i = 0; i < payment.length; i++) {
                          payment[i]['ischeck'] = (i == index);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: whitecolor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(width: 1, color: orangeBorder),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 21.0, right: 21.0, top: 18.0, bottom: 18.0),
                        child: Row(
                          children: [
                            Image.asset(
                              payment[index]['icon'],
                              height: index == 1
                                  ? 25
                                  : index == 2
                                      ? 23
                                      : 30,
                              width: index == 1
                                  ? 21
                                  : index == 2
                                      ? 30
                                      : 22,
                              // fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 17.0),
                              child: getTextWidget(
                                  title: payment[index]['name'],
                                  fontfamily: fontfamilyDmSans,
                                  textColor: const Color(0xFF2A1A1A),
                                  textFontSize: fontSize15,
                                  textFontWeight: fontWeightSemiBold),
                            ),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                payment[index]['ischeck'] == false
                                    ? icUnCheckRadio
                                    : icRadio,
                                height: 26,
                                width: 26,
                                fit: BoxFit.cover,
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    icAdd,
                    height: 24,
                    width: 24,
                    color: orangecolor,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  getTextWidget(
                      title: 'Add Payment Method',
                      fontfamily: fontfamilyAvenir,
                      textColor: orangecolor,
                      textFontSize: fontSize15,
                      textFontWeight: fontWeight900)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
