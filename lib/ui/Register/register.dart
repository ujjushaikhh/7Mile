// import 'package:driverflow/ui/Otp/otp.dart';
import 'package:customerflow/constant/api_constant.dart';
import 'package:customerflow/ui/BottomTab/bottom_tab.dart';
import 'package:customerflow/ui/Register/Model/register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/button.dart';
import '../../utils/dailog.dart';
import '../../utils/fcmtoken.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textfeild.dart';
import '../../utils/textwidget.dart';
import '../../utils/validation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  final _fullnamecontroller = TextEditingController();
  final _mobilecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String getDeviceType() {
    if (Platform.isAndroid) {
      return 'A';
    } else {
      return 'I';
    }
  }

  Future<dynamic> getregisterapi() async {
    final token = await NotificationSet().requestUserPermission();
    debugPrint("Fcm token $token");
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(registerurl));

        request.body = json.encode({
          "email": _emailcontroller.text,
          "password": _passcontroller.text,
          "device_type": getDeviceType(),
          "name": _fullnamecontroller.text,
          "phone": _mobilecontroller.text,
          "device_id": token
        });
        debugPrint(request.body);
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var registerModel = RegisterModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          ProgressDialogUtils.dismissProgressDialog();
          if (registerModel.status == 1) {
            setString('userlogin', '1');
            setString('token', registerModel.data!.token.toString());
            setString('name', registerModel.data!.name.toString());
            setString('mobilenum', registerModel.data!.phone!.toString());
            setBool('getNotification', registerModel.data!.isNotification!);
            setString('email', registerModel.data!.email!.toString());
            setString('userimage', registerModel.data!.image.toString());
            setState(() {
              Fluttertoast.showToast(msg: 'You\'re register successfully');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyPrimaryBottomTab()),
                  (route) => false);
            });
          } else {
            debugPrint('failed to login');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: 'There is no account with that user name & password !',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${registerModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "${registerModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "${registerModel.message}",
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

  DateTime selectedDate = DateTime.now();
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getLogo(),
                      getLogin(),
                      getFullnameFeild(),
                      getLoginFeild(),
                      getMobileFeild(),
                      getPasswordFeild(),
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

  Widget getDobtext() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: getTextWidget(
          title: 'Date of Birth',
          textAlign: TextAlign.left,
          textFontSize: fontSize15,
          textFontWeight: fontWeightMedium,
          textColor: whitecolor),
    );
  }

  Widget getLogo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Container(
          width: 169,
          height: 109,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(icLogo), fit: BoxFit.cover)),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget getDobform() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(color: whitecolor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 16.0,
          ),
          hintText: DateFormat('dd-MM-yyyy').format(selectedDate),
          hintStyle: const TextStyle(
            color: whitecolor,
            fontSize: fontSize14,
            fontWeight: fontWeightRegular,
            fontFamily: fontfamilybeVietnam,
          ),
          fillColor: background,
          filled: true,
          enabled: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: const Icon(
                Icons.calendar_today_outlined,
                size: 24.0,
                color: whitecolor,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(
              width: 1.0,
              color: bordercolor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: bordercolor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: bordercolor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: bordercolor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: bordererror),
          ),
        ),
      ),
    );
  }

  Widget getLogin() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 33.0),
        child: getTextWidget(
            title: 'Create an Account',
            textColor: whitecolor,
            textFontSize: fontSize27,
            textFontWeight: fontWeightBold),
      ),
    );
  }

  Widget getFullnameFeild() {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0),
      child: TextFormDriver(
        prefixIcon: icUser,
        controller: _fullnamecontroller,
        hintText: 'Full Name',
        validation: (value) => Validation.validateName(value),
      ),
    );
  }

  Widget getMobileFeild() {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0),
      child: TextFormDriver(
        prefixIcon: icMobile,
        controller: _mobilecontroller,
        keyboardType: TextInputType.number,
        hintText: 'Mobile Number',
        validation: (value) => Validation.validateMobileNumber(value),
      ),
    );
  }

  Widget getLoginFeild() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormDriver(
        prefixIcon: icEmail,
        controller: _emailcontroller,
        hintText: 'Email',
        keyboardType: TextInputType.emailAddress,
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
          text: 'Register',
          onPressed: () {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const MyPrimaryBottomTab()),
            //     (route) => false);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const MyOtpScreen()));
            if (_formKey.currentState!.validate()) {
              getregisterapi();
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
                  text: 'Already have an account? ',
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
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login',
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
