import 'dart:convert';

import 'package:customerflow/constant/api_constant.dart';
import 'package:customerflow/ui/Cart/Checkout/checkout_payment.dart';
import 'package:customerflow/ui/Cart/Checkout/model/add_addresmodel.dart';
import 'package:customerflow/ui/Cart/Checkout/model/default_address.dart';
import 'package:customerflow/ui/Cart/Checkout/model/getdefaultaddress.dart';
import 'package:customerflow/ui/Cart/Checkout/model/update_address.dart';
import 'package:customerflow/utils/button.dart';
import 'package:customerflow/utils/textfeild.dart';
import 'package:customerflow/utils/validation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../constant/color_constant.dart';
import '../../../constant/font_constant.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textwidget.dart';
import '../../My Address/model/getaddressmodel.dart';

class MyCheckoutAddress extends StatefulWidget {
  const MyCheckoutAddress({super.key, this.type, this.addressid});
  final String? type;
  final int? addressid;
  @override
  State<MyCheckoutAddress> createState() => _MyCheckoutAddressState();
}

class _MyCheckoutAddressState extends State<MyCheckoutAddress> {
  @override
  void initState() {
    super.initState();
    if (widget.type == 'Edit') {
      getaddressmodelapi();
    } else {
      // getDefaultAddressapi();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fullnamecontroller.dispose();
    _homenumbercontroller.dispose();
    _addresscontroller.dispose();
    _citycontroller.dispose();
    _cvvcontroller.dispose();
    _landmarkcontroller.dispose();
    _zipcodecontroller.dispose();
    _statecontroller.dispose();
  }

  final _fullnamecontroller = TextEditingController();
  final _homenumbercontroller = TextEditingController();
  final _addresscontroller = TextEditingController();
  final _landmarkcontroller = TextEditingController();
  final _zipcodecontroller = TextEditingController();
  final _cvvcontroller = TextEditingController();
  final _citycontroller = TextEditingController();
  final _statecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Address> address = [];
  List<Addresses> addresslist = [];

  bool isChecked = false;

  final List city = ['Ahmedabad', 'Mumbai', 'Jaipur'];
  final List state = ['Gujarati', 'Maharashtra', 'Rajasthan'];

  String? selectCity;
  String? selectState;
  String? lat = '';
  String? lng = '';
  int? userId;
  int? getisDefault;

  String googleApiKey = 'AIzaSyB-s7cqmVufTKO1Rp2amMq8tdmEKVMVE-U';

  Widget line(Color linecolor) {
    return Container(
      color: linecolor,
      height: 3.0,
      width: 130.0,
    );
  }

  var token = getString('token');
  Future<void> getDefaultAddressapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = defaultaddressurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        debugPrint(token);

        var request = http.Request('GET', Uri.parse(apiurl));

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getdefaultaddressmodel =
            GetdefaultAddessModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getdefaultaddressmodel.status == 1) {
            setState(() {
              // addresslist = getdefaultaddressmodel.addresses!;
              // lat = getdefaultaddressmodel.addresses!.latitude ?? '';
              // lng = getdefaultaddressmodel.addresses!.longitude ?? '';
              // userId = getdefaultaddressmodel.addresses!.userId ?? 0;
              // _fullnamecontroller.text =
              //     getdefaultaddressmodel.addresses!.name ?? '';
              // _homenumbercontroller.text =
              //     getdefaultaddressmodel.addresses!.houseNo ?? '';
              // _landmarkcontroller.text =
              //     getdefaultaddressmodel.addresses!.landmark ?? '';
              // _addresscontroller.text =
              //     getdefaultaddressmodel.addresses!.address ?? '';
              // _citycontroller.text =
              //     getdefaultaddressmodel.addresses!.city ?? '';
              // _statecontroller.text =
              //     getdefaultaddressmodel.addresses!.state ?? '';
              // _zipcodecontroller.text =
              //     getdefaultaddressmodel.addresses!.zipcode ?? '';
              // getisDefault = getdefaultaddressmodel.addresses!.isDefault ?? 0;
              // }
              // debugPrint('User id :- $userId');
            });

            if (getisDefault == 0) {
              setState(() {
                isChecked = false;
              });
            } else {
              setState(() {
                isChecked = true;
              });
            }
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
            desc: '${getdefaultaddressmodel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getdefaultaddressmodel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getdefaultaddressmodel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getdefaultaddressmodel.message}',
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

  Future<void> getaddressmodelapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = getDefaultaddressurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        debugPrint(token);

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = jsonEncode({"id": widget.addressid});
        debugPrint('Body ${request.body}');

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getaddressmodel = AddressDetail.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getaddressmodel.status == 1) {
            setState(() {
              // address = getaddressmodel.address!;
              // for (var addressDetail in address) {
              userId = getaddressmodel.address!.userId!;
              _fullnamecontroller.text =
                  getaddressmodel.address!.name!.toString();
              _homenumbercontroller.text =
                  getaddressmodel.address!.houseNo!.toString();
              _landmarkcontroller.text =
                  getaddressmodel.address!.landmark!.toString();
              _addresscontroller.text =
                  getaddressmodel.address!.address!.toString();
              _citycontroller.text = getaddressmodel.address!.city!.toString();
              _statecontroller.text =
                  getaddressmodel.address!.state!.toString();
              _zipcodecontroller.text =
                  getaddressmodel.address!.zipcode!.toString();
              lat = getaddressmodel.address!.latitude!.toString();
              lng = getaddressmodel.address!.longitude!.toString();
              getisDefault = getaddressmodel.address!.isDefault!.toInt();
              // }

              debugPrint('User id :- $userId');

              debugPrint('lat :- $lat');

              debugPrint('lng:- $lng');
            });

            if (getisDefault == 0) {
              setState(() {
                isChecked = false;
              });
            } else {
              setState(() {
                isChecked = true;
              });
            }
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
              Navigator.pop(context);
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

  Future<dynamic> addAddressapi() async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer' '$token',
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(addAdrressurl));
        int isDefault;

        if (isChecked == false) {
          isDefault = 0;
        } else {
          isDefault = 1;
        }

        request.body = json.encode({
          'name': _fullnamecontroller.text,
          'house_no': _homenumbercontroller.text.toString(),
          'landmark': _landmarkcontroller.text.toString(),
          'address': _addresscontroller.text.toString(),
          'latitude': lat.toString(),
          'longitude': lng.toString(),
          'city': _citycontroller.text,
          'state': _statecontroller.text,
          'zipcode': _zipcodecontroller.text,
          'is_default': isDefault
        });
        debugPrint(request.body);

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var addAddress = AddAddressModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (addAddress.status == 1) {
            setState(() {
              setString('homenum', addAddress.data!.houseNo!);
              setString('address', addAddress.data!.address!);
              setString('zipcode', addAddress.data!.zipcode!);
              setInt('addressid', addAddress.data!.addressId!);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyCheckoutPayment()));
            });
            debugPrint('Success');
          } else {
            debugPrint('failed to login');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;

          vapeAlertDialogue(
              context: context,
              desc: '${addAddress.message}',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "${addAddress.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "${addAddress.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "${addAddress.message}",
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

  Future<dynamic> updateAddressapi() async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer' '$token',
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(updateAddressurl));
        if (isChecked == false) {
          setState(() {
            getisDefault = 0;
          });
        } else {
          setState(() {
            getisDefault = 1;
          });
        }

        request.body = json.encode({
          'id': userId,
          'name': _fullnamecontroller.text,
          'house_no': _homenumbercontroller.text.toString(),
          'landmark': _landmarkcontroller.text.toString(),
          'address': _addresscontroller.text.toString(),
          'latitude': lat.toString(),
          'longitude': lng.toString(),
          'city': _citycontroller.text,
          'state': _statecontroller.text,
          'zipcode': _zipcodecontroller.text,
          'is_default': 0
        });
        debugPrint(' Body ${request.body}');

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var addAddress = UpdateAddressModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (addAddress.status == 1) {
            setString('homenum', addAddress.data!.houseNo!);
            setString('address', addAddress.data!.address!);
            setString('zipcode', addAddress.data!.zipcode!);
            setString('city', addAddress.data!.city!);
            setString('state', addAddress.data!.state!);
            debugPrint('Address updated Successfully');
            if (!mounted) return;
            vapeAlertDialogue(
                context: context,
                type: AlertType.info,
                desc: 'Address updated Successfully',
                onPressed: () {
                  Navigator.pop(context);
                }).show();
            // Navigator.pop(context, true);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyCheckoutPayment()));
          } else {
            debugPrint('failed to login');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;

          vapeAlertDialogue(
              context: context,
              desc: '${addAddress.message}',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "${addAddress.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "${addAddress.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "${addAddress.message}",
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
      backgroundColor: whitecolor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: background,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Icon(
                Icons.arrow_back,
                color: whitecolor,
              ),
            )),
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: getTextWidget(
              title: 'Checkout',
              textColor: whitecolor,
              textFontWeight: fontWeightMedium,
              textFontSize: fontSize15),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: background,
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      tick(orangecolor, false),
                      line(orangecolor),
                      tick(const Color(0xFF495771), true),
                      line(Colors.grey),
                      tick(const Color(0xFF495771), true)
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 14.0, left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getTextWidget(
                          title: 'Address',
                          fontfamily: fontfamilyAvenir,
                          textFontWeight: fontWeightMedium,
                          textFontSize: fontSize15,
                          textColor: orangecolor),
                      getTextWidget(
                          title: 'Payment',
                          fontfamily: fontfamilyAvenir,
                          textFontWeight: fontWeightMedium,
                          textFontSize: fontSize15,
                          textColor: const Color(0xFFA2A5AA)),
                      getTextWidget(
                          title: 'Confirm',
                          fontfamily: fontfamilyAvenir,
                          textFontWeight: fontWeightMedium,
                          textFontSize: fontSize15,
                          textColor: const Color(0xFFA2A5AA))
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: getTextWidget(
                          title: 'Full Name',
                          textFontSize: fontSize15,
                          textFontWeight: fontWeightMedium,
                          textColor: background),
                    ),
                    getName(),
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getTextWidget(
                                    title: 'Home Number',
                                    textFontSize: fontSize15,
                                    textFontWeight: fontWeightMedium,
                                    textColor: background),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: getHomenumber(),
                                )
                              ]),
                          // const SizedBox(
                          //   width: 15.0,
                          // ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getTextWidget(
                                    title: 'Landmark',
                                    textFontSize: fontSize15,
                                    textFontWeight: fontWeightMedium,
                                    textColor: background),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: getLandmark(),
                                )
                              ]),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: getTextWidget(
                          title: 'Address',
                          textFontSize: fontSize15,
                          textFontWeight: fontWeightMedium,
                          textColor: background),
                    ),
                    getAddress(),
                    // getCityState(),
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getTextWidget(
                                    title: 'City',
                                    textFontSize: fontSize15,
                                    textFontWeight: fontWeightMedium,
                                    textColor: background),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: getCity(),
                                )
                              ]),
                          // const SizedBox(
                          //   width: 15.0,
                          // ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getTextWidget(
                                    title: 'State',
                                    textFontSize: fontSize15,
                                    textFontWeight: fontWeightMedium,
                                    textColor: background),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: getState(),
                                )
                              ]),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: getTextWidget(
                          title: 'Zip Code',
                          textFontSize: fontSize15,
                          textFontWeight: fontWeightMedium,
                          textColor: background),
                    ),
                    getZipcode(),
                    getCheckBox(),
                    const Spacer(),
                    getButton()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tick(Color circlecolor, bool isChecked) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: circlecolor,
          border: isChecked == true
              ? Border.all(width: 2, color: const Color(0xFFB1B9C7))
              : null),
    );
  }

  Widget getButton() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: CustomizeButton(
          text: widget.type == 'Edit' ? 'Update' : 'Continue',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (widget.type == 'Edit') {
                updateAddressapi();
              } else {
                addAddressapi();
              }
            }
          }),
    );
  }

  Widget getCheckBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 23.0),
      child: Row(
        children: [
          Checkbox(
              // fillColor: const MaterialStatePropertyAll<Color>(greencolor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              side: const BorderSide(color: dropdownborder),
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              }),
          getTextWidget(
              title: 'Set Shipping address default',
              textFontSize: fontSize13,
              textFontWeight: fontWeightRegular,
              textColor: background)
        ],
      ),
    );
  }

  Widget getZipcode() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormDriver(
        keyboardType: TextInputType.number,
        fillColor: whitecolor,
        borderColor: dropdownborder,
        controller: _zipcodecontroller,
        textstyle: background,
        hintText: 'Zip Code',
        validation: (value) => Validation.validateText(value),
        hintColor: dropdownhint,
      ),
    );
  }

  Widget getCityState() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTextWidget(
                      title: 'City',
                      textFontSize: fontSize15,
                      textFontWeight: fontWeightMedium,
                      textColor: background),
                  const SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    height: 45.0,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        // style: const TextStyle(color: Colors.white),
                        isExpanded: true,
                        hint: Row(
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            getTextWidget(
                                title: 'Select City',
                                textColor: dropdownhint,
                                textFontSize: fontSize14,
                                textFontWeight: fontWeightRegular),
                          ],
                        ),
                        items: city
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: fontfamilyBevietnam,
                                      color: background),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        value: selectCity,
                        onChanged: (value) {
                          setState(() {
                            selectCity = value;
                          });
                        },
                        // selectedItemBuilder: (BuildContext context) {
                        //   return gameItems.map<Widget>((item) {
                        //     return Align(
                        //       alignment: Alignment.centerLeft,
                        //       child: Text(
                        //         item.gameName!,
                        //         style: TextStyle(
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.bold,
                        //           fontFamily: 'Roboto',
                        //           color: item.id.toString() ==
                        //                   showGame[index].selectGame
                        //               ? Colors
                        //                   .white // Set the color of the selected item
                        //               : const Color(
                        //                   0xFF222947), // Set the color of non-selected items
                        //         ),
                        //         overflow: TextOverflow.ellipsis,
                        //       ),
                        //     );
                        //   }).toList();
                        // },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2.3,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              width: 1.0,
                              color: dropdownborder,
                            ),
                            color: whitecolor,
                          ),
                          // elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                            color: background,
                          ),
                          // iconSize: 14,
                          // iconEnabledColor: Colors.white,
                          // iconDisabledColor: Colors.white,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: MediaQuery.of(context).size.width / 2.3,
                          padding: null,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white),
                          // elevation: 8,
                          // offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTextWidget(
                      title: 'State',
                      textFontSize: fontSize15,
                      textFontWeight: fontWeightMedium,
                      textColor: background),
                  const SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    height: 45.0,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        // style: const TextStyle(color: Colors.white),
                        isExpanded: true,
                        hint: Row(
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            getTextWidget(
                                title: 'Select State',
                                textColor: dropdownhint,
                                textFontSize: fontSize14,
                                textFontWeight: fontWeightRegular),
                          ],
                        ),
                        // selectedItemBuilder: (BuildContext context) {
                        //   return rankItems.map<Widget>((String item) {
                        //     return Align(
                        //       alignment: Alignment.centerLeft,
                        //       child: Text(
                        //         item,
                        //         style: const TextStyle(
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.white,
                        //         ),
                        //         overflow: TextOverflow.ellipsis,
                        //       ),
                        //     );
                        //   }).toList();
                        // },
                        items: state
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.3,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                        color: Color(0xFF222947)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        value: selectState,
                        onChanged: (value) {
                          setState(() {
                            selectState = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 2.3,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              width: 1.0,
                              color: dropdownborder,
                            ),
                            color: whitecolor,
                          ),
                          // elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                            color: background,
                          ),
                          // iconSize: 14,
                          // iconEnabledColor: Colors.white,
                          // iconDisabledColor: Colors.white,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: MediaQuery.of(context).size.width / 2.3,
                          padding: null,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget getCVV() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3.8,
      child: TextFormDriver(
        controller: _cvvcontroller,
        hintText: 'CVV',
        hintColor: hintcolor,
        validation: (value) => Validation.validateText(value),
        fillColor: whitecolor,
        borderColor: dropdownborder,
      ),
    );
  }

  Widget getHomenumber() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.3,
      child: TextFormDriver(
        controller: _homenumbercontroller,
        hintText: 'Home Number',
        keyboardType: TextInputType.number,
        hintColor: hintcolor,
        validation: (value) => Validation.validateText(value),
        fillColor: whitecolor,
        textstyle: background,
        borderColor: dropdownborder,
      ),
    );
  }

  Widget getCity() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.3,
      child: TextFormDriver(
        controller: _citycontroller,
        hintText: 'City',
        hintColor: hintcolor,
        fillColor: whitecolor,
        textstyle: background,
        validation: (value) => Validation.validateText(value),
        borderColor: dropdownborder,
      ),
    );
  }

  Widget getState() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.3,
      child: TextFormDriver(
        controller: _statecontroller,
        hintText: 'State',
        hintColor: hintcolor,
        fillColor: whitecolor,
        validation: (value) => Validation.validateText(value),
        textstyle: background,
        borderColor: dropdownborder,
      ),
    );
  }

  Widget getLandmark() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.3,
      child: TextFormDriver(
        controller: _landmarkcontroller,
        hintText: 'Landmark',
        hintColor: hintcolor,
        validation: (value) => Validation.validateText(value),
        fillColor: whitecolor,
        textstyle: background,
        borderColor: dropdownborder,
      ),
    );
  }

  Widget getAddress() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: GooglePlaceAutoCompleteTextField(
          googleAPIKey: googleApiKey,
          isLatLngRequired: true,
          showError: true,
          boxDecoration: const BoxDecoration(color: whitecolor),
          textStyle: const TextStyle(
              color: background,
              fontFamily: fontfamilybeVietnam,
              fontWeight: fontWeightMedium,
              fontSize: fontSize14),
          inputDecoration: InputDecoration(
            // suffixText: widget.suffixText,
            // suffixStyle: widget.suffixtextstyle,
            // suffix: widget.suffix,
            contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
            hintText: 'Address',
            hintStyle: const TextStyle(
              color: hintcolor,
              fontSize: fontSize14,
              fontWeight: fontWeightRegular,
              fontFamily: fontfamilybeVietnam,
            ),
            fillColor: whitecolor,
            filled: true,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(
                width: 1.0,
                color: dropdownborder,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: dropdownborder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: dropdownborder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: dropdownborder),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: bordererror),
            ),
          ),

          textEditingController: _addresscontroller,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            debugPrint('Lng :- ${prediction.lng}');
            debugPrint('Lat :-${prediction.lat}');

            setState(() {
              lat = prediction.lat!;
              lng = prediction.lng!;
            });
          },

          itemClick: (Prediction prediction) async {
            _addresscontroller.text = prediction.description!;
            PlaceDetails placeDetails =
                await fetchPlaceDetails(prediction.placeId!);

            String selectCity = placeDetails.city;
            String selectState = placeDetails.state;

            debugPrint('City :- $selectCity');
            debugPrint('State :- $selectState');

            setState(() {
              _citycontroller.text = selectCity;
              _statecontroller.text = selectState;
            });
            _addresscontroller.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description!.length));
          },

          itemBuilder: (context, index, prediction) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(child: Text(prediction.description ?? ""))
                ],
              ),
            );
          },

          seperatedBuilder: const Divider(),
          isCrossBtnShown: false,

          // child: TextFormDriver(
          //   fillColor: whitecolor,
          //   borderColor: dropdownborder,
          //   controller: _addresscontroller,
          //   hintText: 'Address',
          //   hintColor: dropdownhint,
          //   textstyle: background,
          // ),
        ),
      ),
    );
  }

  Widget getName() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormDriver(
        fillColor: whitecolor,
        borderColor: dropdownborder,
        validation: (value) => Validation.validateText(value),
        textstyle: background,
        controller: _fullnamecontroller,
        hintText: 'Full Name',
        hintColor: dropdownhint,
      ),
    );
  }

  Future<PlaceDetails> fetchPlaceDetails(String placeId) async {
    final apiKey = googleApiKey; // Replace with your actual API key
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_components&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parse the response to extract city and state information
        String city = 'Unknown City';
        String state = 'Unknown State';

        List<dynamic> addressComponents =
            data['result']['address_components'] ?? [];

        for (var component in addressComponents) {
          List<dynamic> types = component['types'] ?? [];
          if (types.contains('locality')) {
            city = component['long_name'];
          } else if (types.contains('administrative_area_level_1')) {
            state = component['long_name'];
          }
        }

        return PlaceDetails(city: city, state: state);
      } else {
        throw Exception('Failed to fetch place details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class PlaceDetails {
  final String city;
  final String state;

  PlaceDetails({required this.city, required this.state});
}
