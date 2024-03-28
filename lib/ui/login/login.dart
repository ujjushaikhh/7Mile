import 'dart:convert';
import 'dart:io';

import 'package:customerflow/constant/api_constant.dart';
import 'package:customerflow/ui/BottomTab/bottom_tab.dart';
import 'package:customerflow/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/button.dart';
import '../../utils/dailog.dart';
import '../../utils/fcmtoken.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textfeild.dart';
import '../../utils/textwidget.dart';
import '../../utils/validation.dart';
import '../ForgotPassword/forgot.dart';
import '../Register/register.dart';

import 'package:http/http.dart' as http;

import 'Model/loginmodel.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String getDeviceType() {
    if (Platform.isAndroid) {
      return 'A';
    } else {
      return 'I';
    }
  }

  Future<dynamic> getloginapi() async {
    final token = await NotificationSet().requestUserPermission();
    debugPrint("Fcm Token $token");
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(loginurl));

        request.body = json.encode({
          "email": _emailcontroller.text,
          "password": _passcontroller.text,
          "device_type": getDeviceType(),
          "device_id": token
        });
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var loginModel = LoginModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (loginModel.status == 1) {
            setString('userlogin', '1');
            setString('token', loginModel.data!.token.toString());
            setString('id', loginModel.data!.id.toString());
            setString('email', loginModel.data!.email!.toString());
            setBool('getNotification', loginModel.data!.isNotification!);
            setString('mobilenum', loginModel.data!.phone!.toString());
            setString('name', loginModel.data!.name.toString());
            setString('userimage', loginModel.data!.image.toString());
            setState(() {
              Fluttertoast.showToast(msg: 'You\'re login successfully');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyPrimaryBottomTab()),
                  (route) => false);
            });
          } else {
            debugPrint('failed to login');
            ProgressDialogUtils.dismissProgressDialog();
            if (!mounted) return;
            vapeAlertDialogue(
                context: context,
                desc: '${loginModel.message}',
                onPressed: () {
                  Navigator.pop(context);
                }).show();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: 'There is no account with that user name & password !',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${loginModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${loginModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${loginModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        }
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        if (!mounted) return;
        debugPrint('$e');
        vapeAlertDialogue(
            context: context,
            desc: 'Something went wrong',
            onPressed: () {
              Navigator.pop(context);
            }).show();
      }
    } else {
      if (!mounted) return;
      vapeAlertDialogue(
          context: context,
          type: AlertType.info,
          desc: 'Please check your internet connection',
          onPressed: () {
            Navigator.pop(context);
          }).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: background,
            image: DecorationImage(
                image: AssetImage(icBackground), fit: BoxFit.cover)),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(children: [
                  getLogo(),
                  getLogin(),
                  getLoginFeild(),
                  getPasswordFeild(),
                  getForgotPassword(),
                  getLoginButton()
                ]),
              ),
            ),
            const Spacer(),
            getBottomtext()
          ],
        ),
      ),
    );
  }

  Widget getLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 128.0),
      child: Container(
        width: 169,
        height: 109,
        decoration: const BoxDecoration(
            image:
                DecorationImage(image: AssetImage(icLogo), fit: BoxFit.cover)),
      ),
    );
  }

  Widget getLogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 33.0),
      child: getTextWidget(
          title: 'Login',
          textColor: whitecolor,
          textFontSize: fontSize27,
          textFontWeight: fontWeightBold),
    );
  }

  Widget getForgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 19.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyForgotPassword()));
        },
        child: getTextWidget(
            title: 'Forgot Password?',
            textFontSize: fontSize15,
            textFontWeight: fontWeightSemiBold,
            textColor: greencolor),
      ),
    );
  }

  Widget getLoginFeild() {
    return Padding(
      padding: const EdgeInsets.only(top: 17.0),
      child: TextFormDriver(
        prefixIcon: icEmail,
        keyboardType: TextInputType.emailAddress,
        controller: _emailcontroller,
        hintText: 'Email',
        validation: (value) => Validation.validateEmail(value),
      ),
    );
  }

  Widget getLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 22.0,
      ),
      child: CustomizeButton(
          text: 'Login',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              getloginapi();
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const MyPrimaryBottomTab()),
              //     (route) => false);
            }
          }),
    );
  }

  Widget getPasswordFeild() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: TextFormDriver(
        controller: _passcontroller,
        hintText: 'Password',
        prefixIcon: icPassword,
        suffixIcon: icCloseeye,
        validation: (value) => Validation.validatePassword(value),
        obscureText: true,
      ),
    );
  }

  Widget getBottomtext() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(
                    color: whitecolor,
                    fontSize: fontSize15,
                    fontFamily: fontfamilybeVietnam,
                    fontWeight: fontWeightRegular,
                  ),
                ),
                WidgetSpan(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyRegister()),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: greencolor,
                        fontSize: fontSize15,
                        fontFamily: fontfamilybeVietnam,
                        fontWeight: fontWeightSemiBold,
                      ),
                    ),
                  ),
                ),
                const TextSpan(
                  text: '.',
                  style: TextStyle(
                    color: whitecolor,
                    fontSize: fontSize15,
                    fontFamily: fontfamilybeVietnam,
                    fontWeight: fontWeightBold,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
