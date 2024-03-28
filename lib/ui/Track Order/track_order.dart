import 'dart:convert';

import 'package:customerflow/constant/image_constant.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';
import '../Order Details/model/trackordermodel.dart';

class MyTrackOrder extends StatefulWidget {
  final int? cartid;

  const MyTrackOrder({super.key, this.cartid});

  @override
  State<MyTrackOrder> createState() => _MyTrackOrderState();
}

class _MyTrackOrderState extends State<MyTrackOrder> {
  bool isload = true;
  @override
  void initState() {
    super.initState();
    trackorderapi();
  }

  List<Data>? data = [];
  int? orderConfirmed;
  int? orderShipped;
  int? orderOutOfDelivered;
  int? orderDelivered;

  Future<void> trackorderapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = gettrackorderurl;
        debugPrint('url :- $apiurl');
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
              data = trackorder.data!;
              debugPrint("${data!.map((e) => e.description)}");
              debugPrint("${data!.map((e) => e.status)}");

              if (data != null) {
                for (var product in trackorder.data!) {
                  orderConfirmed = product.status;
                  orderShipped = product.status;
                  orderOutOfDelivered = product.status;
                  orderDelivered = product.status;
                  isload = false;
                }
              } else {
                debugPrint("Else part");
              }

              // debugPrint('Order Status 1 $orderConfirmed');
              // debugPrint('Order Status 2 $orderShipped');
              // debugPrint('Order Status 3 $orderOutOfDelivered');
              // debugPrint('Order Status 4 $orderDelivered');
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
              Navigator.pop(context);
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
      appBar: AppBar(
        backgroundColor: background,
        centerTitle: true,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: getTextWidget(
              title: 'Track Orders',
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
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 38.0),
                    child: Center(
                      child: Image.asset(
                        icTrackorder,
                        width: 259,
                        height: 113.98,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 26.0, top: 40.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Column(
                              children: [
                                tick(
                                    isChecked: data![index].status != 1
                                        ? false
                                        : true),
                                // if (index < data!.length - 1)
                                line(orangecolor)
                              ],
                            ),
                            _buildTimelineTile(
                                data![index].title!, data![index].description!)
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget line(Color linecolor) {
    return Container(
      color: linecolor,
      height: 60.0,
      width: 3.0,
    );
  }

  Widget tick({bool isChecked = true}) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked == true ? orangecolor : whitecolor,
          border: isChecked == true
              ? null
              : Border.all(width: 2, color: orangecolor)),
    );
  }

  Widget _buildTimelineTile(String title, String description) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 29.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(
              title: title,
              textFontSize: fontSize16,
              textFontWeight: fontWeightSemiBold,
              textColor: background,
            ),
            const SizedBox(
              height: 4.0,
            ),
            getTextWidget(
              title: description,
              textFontSize: fontSize14,
              textFontWeight: fontWeightRegular,
              textColor: const Color(0xFF747982),
            ),
          ],
        ),
      ),
    );
  }
}
