import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:customerflow/ui/Terms&Condition/model/termsandconditionmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';

class MyTermsandCondition extends StatefulWidget {
  const MyTermsandCondition({super.key});

  @override
  State<MyTermsandCondition> createState() => _MyTermsandConditionState();
}

class _MyTermsandConditionState extends State<MyTermsandCondition> {
  @override
  void initState() {
    super.initState();
    getcmsdataapi();
  }

  String? terms;

  Future<void> getcmsdataapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = getcmsDataurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('token'));

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = json.encode({"id": 1});
        debugPrint(request.body);
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getcmsdata = TermsConditionModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getcmsdata.status == 1) {
            setState(() {
              terms = getcmsdata.data!;
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
            debugPrint(' Error Message :- ${getcmsdata.message}');
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getcmsdata.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getcmsdata.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getcmsdata.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getcmsdata.message}',
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: background,
          centerTitle: true,
          elevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: getTextWidget(
                title: 'Terms & Condition',
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
        body: SingleChildScrollView(
          child: Html(
            data: terms != null ? terms.toString() : '',
            style: {'body': Style(color: background)},
          ),
        ));
  }
}
