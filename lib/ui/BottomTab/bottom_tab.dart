import 'dart:convert';

import 'package:customerflow/ui/Cart/cart.dart';
import 'package:customerflow/ui/Home/home.dart';
import 'package:customerflow/ui/My%20Profile/my_profile.dart';
import 'package:customerflow/ui/Search%20Screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:http/http.dart' as http;
import '../../../constant/font_constant.dart';
import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';
import '../Home/model/notify_count.dart';
import '../Notification/notification.dart';

class MyPrimaryBottomTab extends StatefulWidget {
  final String? from;
  const MyPrimaryBottomTab({super.key, this.from});

  @override
  State<MyPrimaryBottomTab> createState() => _MyPrimaryBottomTabState();
}

class _MyPrimaryBottomTabState extends State<MyPrimaryBottomTab> {
  int? notifyCount = 0;

  Future<void> getNotifycountapi() async {
    if (await checkUserConnection()) {
      try {
        var apiurl = getnotificationcounturl;
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
        var getNotifyCount = NotifyCountModel.fromJson(jsonResponse);
        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          // ProgressDialogUtils.dismissProgressDialog();
          if (getNotifyCount.status == 1) {
            setState(() {
              notifyCount = getNotifyCount.count ?? 0;
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
          }
        } else if (response.statusCode == 401) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getNotifyCount.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getNotifyCount.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getNotifyCount.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getNotifyCount.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        }
      } catch (e) {
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

  @override
  void initState() {
    super.initState();
    getNotifycountapi();
    if (widget.from == 'search') {
      setState(() {
        selectedPage = 1;
      });
    } else {
      setState(() {
        selectedPage = 0;
      });
    }
  }

  int selectedPage = 0;
  bool photo = true;
  bool video = false;

  final _pageOptions = [
    const MyHome(),
    const MySearchScreen(),
    // const MyCheckoutPayment(),
    const MyCart(),
    const MyProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: selectedPage == 0
              ? AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: background,
                  elevation: 0.0,
                  centerTitle: true,
                  title: getTextWidget(
                      title: 'Home',
                      textFontSize: fontSize15,
                      textFontWeight: fontWeightMedium,
                      textColor: whitecolor),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Stack(
                        children: [
                          IconButton(
                            icon: Image.asset(
                              icNotification,
                              height: 24,
                              width: 24,
                              color: whitecolor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyNotification()))
                                  .whenComplete(() => getNotifycountapi());
                            },
                          ),
                          if (notifyCount! > 0)
                            Positioned(
                              top: -1,
                              right: 3,
                              child: Container(
                                height: 22.0,
                                width: 22.0,
                                decoration: const BoxDecoration(
                                  color: orangecolor,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18.0,
                                  minHeight: 18.0,
                                ),
                                child: Center(
                                  child: Text(
                                    notifyCount!.toString(),
                                    style: const TextStyle(
                                      color: whitecolor,
                                      fontSize: fontSize13,
                                      fontFamily: fontfamilybeVietnam,
                                      fontWeight: fontWeightSemiBold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                )
              : selectedPage == 1
                  ? AppBar(
                      backgroundColor: background,
                      elevation: 0.0,
                      centerTitle: true,
                      leading: IconButton(
                          onPressed: () {
                            setState(() {
                              selectedPage = 0;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 24.0,
                            color: whitecolor,
                          )),
                      title: getTextWidget(
                          title: 'Search',
                          textFontSize: fontSize15,
                          textFontWeight: fontWeightMedium,
                          textColor: whitecolor),
                    )
                  : selectedPage == 2
                      ? AppBar(
                          leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedPage = 0;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 24.0,
                                color: whitecolor,
                              )),
                          elevation: 0.0,
                          centerTitle: true,
                          backgroundColor: background,
                          title: getTextWidget(
                              title: 'Cart',
                              textFontSize: fontSize15,
                              textFontWeight: fontWeightMedium,
                              textColor: whitecolor),
                        )
                      : selectedPage == 3
                          ? AppBar(
                              automaticallyImplyLeading: false,
                              elevation: 0.0,
                              centerTitle: true,
                              backgroundColor: background,
                              title: getTextWidget(
                                  title: 'My Profile',
                                  textFontSize: fontSize15,
                                  textFontWeight: fontWeightMedium,
                                  textColor: whitecolor),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Stack(
                                    children: [
                                      IconButton(
                                        icon: Image.asset(
                                          icNotification,
                                          height: 24,
                                          width: 24,
                                          color: whitecolor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MyNotification()))
                                              .whenComplete(
                                                  () => getNotifycountapi());
                                        },
                                      ),
                                      if (notifyCount! > 0)
                                        Positioned(
                                          top: -1,
                                          right: 3,
                                          child: Container(
                                            height: 22.0,
                                            width: 22.0,
                                            decoration: const BoxDecoration(
                                              color: orangecolor,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16.0,
                                              minHeight: 16.0,
                                            ),
                                            child: Center(
                                              child: Text(
                                                notifyCount!.toString(),
                                                style: const TextStyle(
                                                  color: whitecolor,
                                                  fontSize: fontSize13,
                                                  fontFamily:
                                                      fontfamilybeVietnam,
                                                  fontWeight:
                                                      fontWeightSemiBold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : AppBar(),
          body: _pageOptions[selectedPage],
          extendBody: true,
          bottomNavigationBar: _createBottomNavigationBar()),
    );
  }

  Widget _createBottomNavigationBar() {
    return BottomAppBar(
      color: whitecolor,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildBottomNavItem('Home', icHome, icHomeh, 0),
            buildBottomNavItem('Search', icSearch, icSearchh, 1),
            buildBottomNavItem('Cart', icCart, icCarth, 2),
            buildBottomNavItem('My Profile', icUser, icProfileh, 3),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNavItem(
    String label,
    String iconPath,
    String activeIconPath,
    int index,
  ) {
    bool isSelected = selectedPage == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedPage = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isSelected ? activeIconPath : iconPath,
              width: 24.0,
              height: 24.0,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? orangecolor : background,
                fontSize: fontSize12,
                fontWeight: fontWeightRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (selectedPage != 0) {
      setState(() {
        selectedPage = 0;
      });
      return false; // Do not exit the app
    } else {
      // If already on the home page, allow the app to exit
      return true;
    }
  }
}
