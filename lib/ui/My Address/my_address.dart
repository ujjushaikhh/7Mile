import 'dart:convert';

import 'package:customerflow/constant/api_constant.dart';
import 'package:customerflow/constant/color_constant.dart';
import 'package:customerflow/constant/font_constant.dart';
import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/ui/Cart/Checkout/checkout_address.dart';
import 'package:customerflow/ui/My%20Address/model/getaddressmodel.dart';
import 'package:customerflow/utils/button.dart';
import 'package:customerflow/utils/progressdialog.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:customerflow/utils/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({super.key});

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  @override
  void initState() {
    super.initState();
    getaddressmodelapi();
  }

  List<Address> address = [];
  bool isload = true;

  var token = getString('token');

  Future<void> getaddressmodelapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;

        ProgressDialogUtils.showProgressDialog(context);
      }

      try {
        var apiurl = getAddressurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer' '$token',
          'Content-Type': 'application/json',
        };

        debugPrint(token);

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getaddressmodel = GetAddressModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getaddressmodel.status == 1) {
            debugPrint('${getaddressmodel.message}');
            setState(() {
              address = getaddressmodel.address ?? [];
              isload = false;
            });

            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getaddressmodel.message}',
            onPressed: () {
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => LoginScreen()),
              //     (route) => false);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getaddressmodel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getaddressmodel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getaddressmodel.message}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0.0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 14),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyCheckoutAddress()));
                },
                icon: Image.asset(
                  icAdd,
                  height: 24,
                  width: 24,
                  color: whitecolor,
                  fit: BoxFit.cover,
                )),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: getTextWidget(
              title: 'My Addresses',
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
          : Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
              child: address.isEmpty
                  ? Center(
                      child: getTextWidget(
                          title: 'No Address added',
                          textFontSize: fontSize16,
                          textColor: background,
                          textFontWeight: fontWeightSemiBold),
                    )
                  : ListView.builder(
                      itemCount: address.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: lightorange),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 11.0,
                                left: 16.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getTextWidget(
                                    title: address[index].name!.toString(),
                                    textColor: addresstitlecolor,
                                    textFontSize: fontSize15,
                                    textFontWeight: fontWeightSemiBold,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, right: 65),
                                    child: getTextWidget(
                                        title:
                                            '${address[index].houseNo!.toString()} ,'
                                            '${address[index].address!.toString()} ,'
                                            '${address[index].zipcode!.toString()}',
                                        textFontWeight: fontWeightRegular,
                                        textColor: background),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: getTextWidget(
                                        title:
                                            'Mo: ${address[index].userPhone!.toString()}',
                                        textColor: addresstitlecolor,
                                        textFontSize: fontSize15,
                                        textFontWeight: fontWeightSemiBold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 17.0, top: 16.0, right: 15.0),
                                    child: CustomizeButton(
                                      text: 'Edit Address',
                                      textcolor: whitecolor,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyCheckoutAddress(
                                                      type: 'Edit',
                                                      addressid: address[index]
                                                          .addressid!,
                                                    ))).whenComplete(() {
                                          setState(() {
                                            getaddressmodelapi(
                                                showProgress: false);
                                          });
                                        });
                                      },
                                      color: orangecolor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

class MyAddressess {
  String? title;
  String? address;
  String? monum;

  MyAddressess({this.title, this.address, this.monum});
}
