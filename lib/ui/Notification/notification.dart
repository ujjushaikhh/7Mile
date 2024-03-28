import 'dart:convert';

import 'package:customerflow/constant/api_constant.dart';
import 'package:customerflow/ui/Notification/model/notification_model.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/textwidget.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({super.key});

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  String? dateformat = '';

  bool isload = true;

  @override
  void initState() {
    super.initState();
    getnotiapi();
  }

  Future<void> getnotiapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = getusernotificationurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('token'));

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getnoti = NotificationModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getnoti.status == 1) {
            setState(() {
              notificationlist = getnoti.data!;
              if (notificationlist.isNotEmpty) {
                for (var datetime in notificationlist) {
                  DateTime date = DateTime.parse(datetime.createdAt!).toLocal();
                  // rating = datetime.rate.toString();
                  dateformat = DateFormat('dd MMM yyyy').format(date);
                }
                isload = false;
              }
            });
            debugPrint('is it success');
          } else {
            setState(() {
              debugPrint('failed to load');
              ProgressDialogUtils.dismissProgressDialog();
              notificationlist = [];
              isload = false;
            });
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getnoti.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getnoti.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getnoti.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getnoti.message}',
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
        type: AlertType.info,
        desc: 'Please check your internet connection',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

  // final String notification =
  //     'Hey, New Order ID FIAH0939933 is available to be accepted. Please accept it within 15 mins of time frame erase you will lose it.';

  // final String date = '26 June 2023';

  List<Data> notificationlist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: background,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: getTextWidget(
            title: 'Notification',
            textFontSize: fontSize15,
            textFontWeight: fontWeightSemiBold,
            textColor: whitecolor,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
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
          : notificationlist.isEmpty
              ? Center(
                  child: getTextWidget(
                      title: 'No Notification are there',
                      textColor: background,
                      textFontSize: fontSize20,
                      textFontWeight: fontWeightSemiBold))
              : ListView.builder(
                  itemCount: notificationlist.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 26.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getTextWidget(
                                              textColor: background,
                                              title: notificationlist[index]
                                                  .notiMsg!
                                                  .toString(),
                                              textFontWeight:
                                                  fontWeightRegular),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 7.0),
                                            child: getTextWidget(
                                                title: dateformat!,
                                                textFontSize: fontSize14,
                                                textFontWeight:
                                                    fontWeightRegular,
                                                textColor:
                                                    const Color(0xFF6F7888)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ClipRRect(
                                  //   borderRadius: BorderRadius.circular(4),
                                  //   child: Image.asset(
                                  //     notificationlist[index].image!.toString(),
                                  //     height: 59,
                                  //     width: 59,
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 14.0),
                          child: Divider(
                            color: dividercolor,
                            thickness: 1.0,
                            height: 2.0,
                          ),
                        ),
                      ],
                    );
                    // Column(
                    //   children: [
                    //     Row(

                    //       children: [
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Padding(
                    //                 padding: const EdgeInsets.only(

                    //                 ),
                    //                 child:

                    //           ],
                    //         ),

                    //       ],
                    //     ),

                    //   ],
                    // );
                  },
                ),
    );
  }
}

class NotificationList {
  String? notification;
  String? date;
  String? image;

  NotificationList({this.notification, this.date, this.image});
}
