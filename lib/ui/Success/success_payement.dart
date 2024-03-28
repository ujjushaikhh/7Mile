import 'dart:convert';

import 'package:customerflow/constant/color_constant.dart';
import 'package:customerflow/constant/font_constant.dart';
import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/ui/BottomTab/bottom_tab.dart';
import 'package:customerflow/ui/Track%20Order/track_order.dart';
import 'package:customerflow/utils/button.dart';
import 'package:customerflow/utils/textwidget.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../../constant/api_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../Order Details/model/trackordermodel.dart';

class MySuuccessPayment extends StatefulWidget {
  final int? cartid;
  const MySuuccessPayment({super.key, this.cartid});

  @override
  State<MySuuccessPayment> createState() => _MySuuccessPaymentState();
}

class _MySuuccessPaymentState extends State<MySuuccessPayment> {
  Future<void> trackorderapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = gettrackorderurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('token'));

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = json.encode({"cart_id": widget.cartid});

        debugPrint(request.body);
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var trackorder = TrackOrderModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (trackorder.status == 1) {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyTrackOrder(
                            cartid: widget.cartid,
                          )));
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${trackorder.message}',
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => LoginScreen()),
              //     (route) => false);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${trackorder.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${trackorder.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${trackorder.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        }
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        debugPrint("$e");
        if (!mounted) return;
        vapeAlertDialogue(
          context: context,
          desc: '$e',
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ).show();
      }
    } else {
      if (!mounted) return;
      vapeAlertDialogue(
        context: context,
        desc: 'Check Internet Connection',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      body: Padding(
        padding: const EdgeInsets.only(left: 54.0, right: 53.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icSuccess,
              width: 168.48,
              height: 200.78,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: getTextWidget(
                  title: 'Successfully Done!',
                  textFontSize: fontSize20,
                  textFontWeight: fontWeightSemiBold,
                  textColor: background),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: getTextWidget(
                  title:
                      'Your Order Code #8539483.Thank you for choosing our products.',
                  textFontSize: fontSize14,
                  textFontWeight: fontWeightRegular,
                  textAlign: TextAlign.center,
                  textColor: background),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 31.0),
              child: CustomizeButton(
                  text: 'Continue Shopping',
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyPrimaryBottomTab()),
                        ((route) => false));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: CustomizeButton(
                text: 'Track Order',
                onPressed: () {
                  trackorderapi();
                },
                color: whitecolor,
                textfontfamily: fontfamilyAvenir,
                textfontsize: fontSize15,
                textfontweight: fontWeightExtraBold,
                borderColor: orangecolor,
                textcolor: orangecolor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
