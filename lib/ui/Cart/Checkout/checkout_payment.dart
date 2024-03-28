import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/ui/Cart/Checkout/checkout_confirm.dart';
import 'package:customerflow/ui/Cart/Checkout/model/get_cardmodel.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constant/color_constant.dart';
import '../../../constant/font_constant.dart';
import '../../../utils/button.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textwidget.dart';
import '../../../utils/validation.dart';

class MyCheckoutPayment extends StatefulWidget {
  const MyCheckoutPayment({super.key});

  @override
  State<MyCheckoutPayment> createState() => _MyCheckoutPaymentState();
}

class _MyCheckoutPaymentState extends State<MyCheckoutPayment> {
  bool isVisible = false;
  bool isCardSelected = false;
  bool isCodSelected = false;
  bool isPaypalselected = false;
  String? cardId;
  int? selectedCard;
  String? last4;
  List<GetCard> card = [];

  @override
  void initState() {
    super.initState();
    // getCardapi();
  }

  final List month = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final List year = ['2030', '2031', '2033'];

  final _cardholdercontroller = TextEditingController();
  final _cardnumbercontroller = TextEditingController();
  final _cvvcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  String? selectMonth;
  String? selectYear;

  String? generatedcardid;
  // String? token;
  String? token = getString('token');

  // Future<dynamic> addCardapi() async {
  //   if (await checkUserConnection()) {
  //     try {
  //       if (!mounted) return;
  //       ProgressDialogUtils.showProgressDialog(context);

  //       var headers = {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       };
  //       debugPrint(token);

  //       var request = http.Request('POST', Uri.parse(addCardurl));
  //       request.body = json.encode({'CardToken': generatedcardid});

  //       debugPrint(request.body);

  //       request.headers.addAll(headers);
  //       http.StreamedResponse response = await request.send();
  //       final responsed = await http.Response.fromStream(response);
  //       var jsonResponse = jsonDecode(responsed.body);
  //       var addCard = AddCardModel.fromJson(jsonResponse);

  //       if (response.statusCode == 200) {
  //         debugPrint(responsed.body);
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (addCard.status == 1) {
  //           if (!mounted) return;
  //           // getCardapi();

  //           // Navigator.push(
  //           //     context,
  //           //     MaterialPageRoute(
  //           //         builder: (context) => MyCheckoutConfirm(
  //           //               cardId: cardId,
  //           //               last4: last4,
  //           //             )));
  //           // vapeAlertDialogue(
  //           //     context: context,
  //           //     type: AlertType.success,
  //           //     desc: 'Product added to cart successfully',
  //           //     onPressed: () {
  //           //       Navigator.pop(context);
  //           //     }).show();
  //         } else {
  //           debugPrint('failed to login');
  //           ProgressDialogUtils.dismissProgressDialog();
  //         }
  //       } else if (response.statusCode == 400) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //             context: context,
  //             desc: '${addCard.message}',
  //             onPressed: () {
  //               Navigator.pop(context);
  //             }).show();
  //       } else if (response.statusCode == 404) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         //  displayToast("There is no account with that user name & password !");
  //         vapeAlertDialogue(
  //             context: context,
  //             desc: "${addCard.message}",
  //             onPressed: () {
  //               Navigator.pop(context);
  //             }).show();
  //       } else if (response.statusCode == 401) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         //  displayToast("There is no account with that user name & password !");
  //         vapeAlertDialogue(
  //             context: context,
  //             desc: "${addCard.message}",
  //             onPressed: () {
  //               Navigator.pop(context);
  //             }).show();
  //       } else if (response.statusCode == 500) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         //  displayToast("There is no account with that user name & password !");
  //         vapeAlertDialogue(
  //             context: context,
  //             desc: "${addCard.message}",
  //             onPressed: () {
  //               Navigator.pop(context);
  //             }).show();
  //       }
  //     } catch (e) {
  //       ProgressDialogUtils.dismissProgressDialog();
  //       if (!mounted) return;
  //       debugPrint('$e');
  //       vapeAlertDialogue(
  //           context: context,
  //           desc: 'Something went wrong',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           }).show();
  //     }
  //   } else {
  //     if (!mounted) return;
  //     vapeAlertDialogue(
  //         context: context,
  //         type: AlertType.info,
  //         desc: 'Please check your internet connection',
  //         onPressed: () {
  //           Navigator.pop(context);
  //         }).show();
  //   }
  // }

  // Future<void> getCardapi() async {
  //   if (await checkUserConnection()) {
  //     if (!mounted) return;

  //     ProgressDialogUtils.showProgressDialog(context);

  //     try {
  //       var apiurl = getCardurl;
  //       debugPrint(apiurl);
  //       var headers = {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       };

  //       debugPrint(token);
  //       debugPrint(apiurl);

  //       var request = http.Request('GET', Uri.parse(apiurl));
  //       request.headers.addAll(headers);
  //       http.StreamedResponse response = await request.send();
  //       final responsed = await http.Response.fromStream(response);
  //       var jsonResponse = jsonDecode(responsed.body);
  //       var getCard = GetCardModel.fromJson(jsonResponse);

  //       if (response.statusCode == 200) {
  //         debugPrint(responsed.body);
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (getCard.status == 1) {
  //           if (getCard.data != null) {
  //             setState(() {
  //               card = getCard.data!;
  //             });
  //           } else {
  //             ("The Message ${getCard.message}");
  //           }

  //           debugPrint('is it success');
  //         } else {
  //           debugPrint('failed to load');
  //           debugPrint("The Message ${getCard.message}");
  //           ProgressDialogUtils.dismissProgressDialog();
  //         }
  //       } else if (response.statusCode == 401) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getCard.message}',
  //           onPressed: () {
  //             // Navigator.pushAndRemoveUntil(
  //             //     context,
  //             //     MaterialPageRoute(builder: (context) => LoginScreen()),
  //             //     (route) => false);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 404) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getCard.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 400) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getCard.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 500) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getCard.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       }
  //     } catch (e) {
  //       ProgressDialogUtils.dismissProgressDialog();
  //       debugPrint("$e");
  //       if (!mounted) return;
  //       vapeAlertDialogue(
  //         context: context,
  //         desc: '$e',
  //         onPressed: () {
  //           Navigator.of(context, rootNavigator: true).pop();
  //         },
  //       ).show();
  //     }
  //   } else {
  //     if (!mounted) return;
  //     vapeAlertDialogue(
  //       context: context,
  //       type: AlertType.info,
  //       desc: 'Please check your internet connection',
  //       onPressed: () {
  //         Navigator.of(context, rootNavigator: true).pop();
  //       },
  //     ).show();
  //   }
  // }

  // Future<dynamic> generateCardapi() async {
  //   var numericMonth = month.indexOf(selectMonth) + 1;
  //   if (await checkUserConnection()) {
  //     try {
  //       if (!mounted) return;
  //       ProgressDialogUtils.showProgressDialog(context);

  //       var headers = {
  //         'Authorization': 'Bearer $stripeKey',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //         'Accept': 'application/json'
  //       };
  //       debugPrint('$headers');
  //       debugPrint(stripeKey);
  //       var request =
  //           http.Request('POST', Uri.parse('https://api.stripe.com/v1/tokens'));

  //       request.bodyFields = {
  //         "card[number]": _cardnumbercontroller.text.toString(),
  //         "card[exp_month]": numericMonth.toString(),
  //         "card[exp_year]": selectYear.toString(),
  //         "card[cvc]": _cvvcontroller.text,
  //         "card[name]": _cardholdercontroller.text.toString()
  //       };
  //       debugPrint(request.body);

  //       request.headers.addAll(headers);
  //       http.StreamedResponse response = await request.send();
  //       final responsed = await http.Response.fromStream(response);
  //       var jsonResponse = jsonDecode(responsed.body);
  //       var generateCard = GenerateCardToken.fromJson(jsonResponse);
  //       ProgressDialogUtils.dismissProgressDialog();

  //       debugPrint(responsed.body);
  //       if (response.statusCode == 200) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         generatedcardid = generateCard.id!.toString();
  //         debugPrint('$generatedcardid');
  //         last4 = generateCard.card!.last4!.toString();
  //         cardId = generateCard.card!.id!.toString();
  //         // addCardapi();
  //       }
  //       // else if (response.statusCode == 400) {
  //       //   ProgressDialogUtils.dismissProgressDialog();
  //       //   if (!mounted) return;
  //       //   vapeAlertDialogue(
  //       //       context: context,
  //       //       desc: '400',
  //       //       onPressed: () {
  //       //         Navigator.pop(context);
  //       //       }).show();
  //       // } else if (response.statusCode == 404) {
  //       //   ProgressDialogUtils.dismissProgressDialog();
  //       //   if (!mounted) return;
  //       //   vapeAlertDialogue(
  //       //       context: context,
  //       //       desc: "404",
  //       //       onPressed: () {
  //       //         Navigator.pop(context);
  //       //       }).show();
  //       // } else if (response.statusCode == 401) {
  //       //   ProgressDialogUtils.dismissProgressDialog();
  //       //   if (!mounted) return;
  //       //   vapeAlertDialogue(
  //       //       context: context,
  //       //       desc: "401",
  //       //       onPressed: () {
  //       //         Navigator.pop(context);
  //       //       }).show();
  //       // } else if (response.statusCode == 500) {
  //       //   ProgressDialogUtils.dismissProgressDialog();
  //       //   if (!mounted) return;
  //       //   vapeAlertDialogue(
  //       //       context: context,
  //       //       desc: "500",
  //       //       onPressed: () {
  //       //         Navigator.pop(context);
  //       //       }).show();
  //       // }
  //     } catch (e) {
  //       ProgressDialogUtils.dismissProgressDialog();
  //       if (!mounted) return;
  //       debugPrint('$e');
  //       vapeAlertDialogue(
  //           context: context,
  //           desc: 'Something went wrong',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           }).show();
  //     }
  //   } else {
  //     if (!mounted) return;
  //     vapeAlertDialogue(
  //         context: context,
  //         type: AlertType.info,
  //         desc: 'Please check your internet connection',
  //         onPressed: () {
  //           Navigator.pop(context);
  //         }).show();
  //   }
  // }

  // Future<String?> generateStripeToken({required String cvv}) async {
  //   // Construct the expiryDate from selected month and year
  //   var expiryDate = '$selectMonth/$selectYear';
  //   debugPrint(expiryDate);

  //   CardTokenParams cardParams = CardTokenParams(
  //     type: TokenType.Card,
  //     name: _cardholdercontroller.text,
  //   );

  //   await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
  //     number: _cardnumbercontroller.value.text.toString(),
  //     cvc: cvv,
  //     expirationMonth: int.tryParse(selectMonth!),
  //     expirationYear: int.tryParse("20$selectYear"),
  //   ));

  //   try {
  //     TokenData token = await Stripe.instance.createToken(
  //       CreateTokenParams.card(params: cardParams),
  //     );
  //     debugPrint("Flutter Stripe token ${token.toJson()}");
  //     return token.id;
  //   } on StripeException catch (e) {
  //     // Utils.errorSnackBar(e.error.message);
  //     debugPrint("Flutter Stripe error ${e.error.message}");
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      // resizeToAvoidBottomInset: false,
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
                      tick(orangecolor, false),
                      line(orangecolor),
                      tick(const Color(0xFF495771), true)
                      // TimelineTile(
                      //   alignment: TimelineAlign.manual,
                      //   axis: TimelineAxis.horizontal,
                      //   lineXY: 0.3,
                      //   endChild: Padding(
                      //     padding: const EdgeInsets.only(top: 14.0),
                      //     child: getTextWidget(
                      //       title: 'Address',
                      //       textColor: orangecolor,
                      //       textFontSize: fontSize14,
                      //       fontfamily: fontfamilyAvenir,
                      //     ),
                      //   ),
                      //   afterLineStyle: const LineStyle(
                      //     color: orangecolor,
                      //   ),
                      //   indicatorStyle: IndicatorStyle(
                      //     width: 22,
                      //     height: 22,
                      //     indicatorXY: 0.0,
                      //     color: orangecolor,
                      //     indicator: Container(
                      //         decoration: const BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: orangecolor,
                      //     )),
                      //   ),
                      // ),
                      // TimelineTile(
                      //   alignment: TimelineAlign.manual,
                      //   axis: TimelineAxis.horizontal,
                      //   lineXY: 0.3,
                      //   afterLineStyle: const LineStyle(color: orangecolor),
                      //   endChild: Padding(
                      //     padding: const EdgeInsets.only(top: 14.0),
                      //     child: getTextWidget(
                      //       title: 'Payment',
                      //       textColor: orangecolor,
                      //       textFontSize: fontSize14,
                      //       fontfamily: fontfamilyAvenir,
                      //     ),
                      //   ),
                      //   indicatorStyle: IndicatorStyle(
                      //     width: 22,
                      //     height: 22,
                      //     indicatorXY: 0.0,
                      //     color: orangecolor,
                      //     indicator: Container(
                      //       decoration: const BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: orangecolor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // TimelineTile(
                      //   alignment: TimelineAlign.manual,
                      //   axis: TimelineAxis.horizontal,
                      //   lineXY: 0.3,
                      //   endChild: Padding(
                      //     padding: const EdgeInsets.only(top: 14.0),
                      //     child: getTextWidget(
                      //       title: 'Confirm',
                      //       textColor: const Color(0xFFA2A5AA),
                      //       textFontSize: fontSize14,
                      //       fontfamily: fontfamilyAvenir,
                      //     ),
                      //   ),
                      //   isLast: true,
                      //   indicatorStyle: IndicatorStyle(
                      //     width: 22,
                      //     height: 22,
                      //     indicatorXY: 0.0,
                      //     color: orangecolor,
                      //     indicator: Container(
                      //         decoration: BoxDecoration(
                      //             shape: BoxShape.circle,
                      //             color: const Color(0xFF495771),
                      //             border: Border.all(
                      //                 width: 2, color: const Color(0xFFB1B9C7)))),
                      //   ),
                      // ),
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
                          textColor: orangecolor),
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
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: getTextWidget(
                            title: 'Payment Method',
                            textColor: background,
                            textFontSize: fontSize20,
                            textFontWeight: fontWeightSemiBold,
                          ),
                        ),
                        // getCard(),
                        getPaypal(),
                        // getCashondelivery(),
                        // Platform.isIOS ? getApplePay() : Container(),
                        // card.isNotEmpty
                        //     ? isVisible == false
                        //         ? Padding(
                        //             padding: const EdgeInsets.only(top: 30.0),
                        //             child: GestureDetector(
                        //               behavior: HitTestBehavior.translucent,
                        //               onTap: () {
                        //                 setState(() {
                        //                   isVisible = !isVisible;
                        //                 });
                        //               },
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.center,
                        //                 children: [
                        //                   Image.asset(
                        //                     icAdd,
                        //                     height: 24,
                        //                     width: 24,
                        //                     color: orangecolor,
                        //                     fit: BoxFit.cover,
                        //                   ),
                        //                   const SizedBox(
                        //                     width: 11,
                        //                   ),
                        //                   getTextWidget(
                        //                       title: 'Add New Card',
                        //                       fontfamily: fontfamilyAvenir,
                        //                       textColor: orangecolor,
                        //                       textFontSize: fontSize15,
                        //                       textFontWeight: fontWeight900)
                        //                 ],
                        //               ),
                        //             ),
                        //           )
                        //         : Container()
                        //     : Padding(
                        //         padding: const EdgeInsets.only(top: 30.0),
                        //         child: GestureDetector(
                        //           behavior: HitTestBehavior.translucent,
                        //           onTap: () {
                        //             setState(() {
                        //               isVisible = !isVisible;
                        //             });
                        //           },
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Image.asset(
                        //                 icAdd,
                        //                 height: 24,
                        //                 width: 24,
                        //                 color: orangecolor,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //               const SizedBox(
                        //                 width: 11,
                        //               ),
                        //               getTextWidget(
                        //                   title: 'Add New Card',
                        //                   fontfamily: fontfamilyAvenir,
                        //                   textColor: orangecolor,
                        //                   textFontSize: fontSize15,
                        //                   textFontWeight: fontWeight900)
                        //             ],
                        //           ),
                        //         ),
                        //       ),

                        // Visibility(
                        //     visible: isVisible,
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.only(top: 32.0),
                        //           child: getTextWidget(
                        //             title: 'Add New Card',
                        //             textColor: background,
                        //             textFontSize: fontSize20,
                        //             textFontWeight: fontWeightSemiBold,
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.only(top: 24.0),
                        //           child: getTextWidget(
                        //             title: 'Card Holder Name',
                        //             textColor: background,
                        //             textFontSize: fontSize15,
                        //             textFontWeight: fontWeightMedium,
                        //           ),
                        //         ),
                        //         getCardholdername(),
                        //         Padding(
                        //           padding: const EdgeInsets.only(top: 15.0),
                        //           child: getTextWidget(
                        //             title: 'Card Number',
                        //             textColor: background,
                        //             textFontSize: fontSize15,
                        //             textFontWeight: fontWeightMedium,
                        //           ),
                        //         ),
                        //         getCardnumber(),
                        //         Padding(
                        //           padding: const EdgeInsets.only(top: 15.0),
                        //           child: Row(
                        //             children: [
                        //               Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   getTextWidget(
                        //                     title: 'Expiry Date',
                        //                     textColor: background,
                        //                     textFontSize: fontSize15,
                        //                     textFontWeight: fontWeightMedium,
                        //                   ),
                        //                   Padding(
                        //                     padding:
                        //                         const EdgeInsets.only(top: 8.0),
                        //                     child: Row(
                        //                       children: [
                        //                         getMonth(),
                        //                         const SizedBox(
                        //                           width: 6.0,
                        //                         ),
                        //                         getYear()
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               Padding(
                        //                 padding:
                        //                     const EdgeInsets.only(left: 25.0),
                        //                 child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: [
                        //                     getTextWidget(
                        //                       title: 'CVV',
                        //                       textColor: background,
                        //                       textFontSize: fontSize15,
                        //                       textFontWeight: fontWeightMedium,
                        //                     ),
                        //                     Padding(
                        //                       padding: const EdgeInsets.only(
                        //                           top: 8.0),
                        //                       child: getCVV(),
                        //                     )
                        //                   ],
                        //                 ),
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //         getAddCardButton()
                        //       ],
                        //     )),
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: getButton(),
    );
  }

  Widget line(Color linecolor) {
    return Container(
      color: linecolor,
      height: 3.0,
      width: 130.0,
    );
  }

  Widget tick(Color circlecolor, bool ischecked) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: circlecolor,
          border: ischecked == true
              ? Border.all(width: 2, color: const Color(0xFFB1B9C7))
              : null),
    );
  }

  Widget getMonth() {
    return SizedBox(
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
              Expanded(
                  child: getTextWidget(
                      title: 'MM',
                      textColor: dropdownhint,
                      textFontSize: fontSize14,
                      textFontWeight: fontWeightRegular)

                  // Text(
                  //   'Select City',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.bold,
                  //     fontFamily: 'Roboto',
                  //     color: Colors.white,
                  //   ),
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  ),
            ],
          ),
          items: month
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
          value: selectMonth,
          onChanged: (value) {
            setState(() {
              selectMonth = value;
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
            width: MediaQuery.of(context).size.width / 3.8,
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
            width: MediaQuery.of(context).size.width / 3.8,
            padding: null,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14), color: Colors.white),
            // elevation: 8,
            // offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  Widget getCVV() {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width / 3.8,
      child: TextFormDriver(
        controller: _cvvcontroller,
        hintText: 'CVV',
        keyboardType: TextInputType.number,
        hintColor: hintcolor,
        validation: (value) => Validation.validateCVV(value),
        textstyle: background,
        fillColor: whitecolor,
        inputFormatters: [LengthLimitingTextInputFormatter(4)],
        borderColor: dropdownborder,
      ),
    );
  }

  Widget getYear() {
    return SizedBox(
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
              Expanded(
                  child: getTextWidget(
                      title: 'YYYY',
                      textColor: dropdownhint,
                      textFontSize: fontSize14,
                      textFontWeight: fontWeightRegular)),
            ],
          ),
          items: year
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
          value: selectYear,
          onChanged: (value) {
            setState(() {
              selectYear = value;
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
            width: MediaQuery.of(context).size.width / 3.8,
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
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: MediaQuery.of(context).size.width / 3.8,
            padding: null,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14), color: Colors.white),
            // elevation: 8,
            // offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  Widget getButton() {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16.0, top: 30, left: 16.0, right: 16.0),
      child: CustomizeButton(
          text: 'Continue',
          onPressed: () async {
            // if (selectedCard != null ||  ) {
            // String selectedcardId = card[selectedCard!].cardId!.toString();
            // String cardLast4 = card[selectedCard!].cardNumber!.toString();
            // setString('cardlast4', cardLast4);

            // debugPrint(selectedcardId);
            // debugPrint(getString('cardast4'));
            if (isPaypalselected != false) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const MyCheckoutConfirm(
                          // cardId: selectedcardId,
                          // last4: cardLast4,
                          ))));
            } else {
              Fluttertoast.showToast(msg: 'Please select a method');
            }

            // } else {

            // if (_formkey.currentState!.validate()) {
            //   // String? stripeTokenid =
            //   //     await generateStripeToken(cvv: _cvvcontroller.text);
            //   // debugPrint(stripeTokenid);
            //   // if (stripeTokenid != null) {
            //   generateCardapi();
            // }
            // }

            // }
          }),
    );
  }

  // Widget getAddCardButton() {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16.0, top: 30),
  //     child: CustomizeButton(
  //         text: 'Add Card',
  //         onPressed: () async {
  //           if (_formkey.currentState!.validate()) {
  //             generateCardapi();
  //           }
  //         }),
  //   );
  // }

  Widget getCardnumber() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormDriver(
        fillColor: whitecolor,
        borderColor: dropdownborder,
        textstyle: background,
        validation: (value) => Validation.validateCardNumber(value),
        keyboardType: TextInputType.number,
        controller: _cardnumbercontroller,
        hintText: 'XXXX XXXX XXXX 1234',
        inputFormatters: [LengthLimitingTextInputFormatter(16)],
        hintColor: dropdownhint,
      ),
    );
  }

  Widget getCardholdername() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormDriver(
        fillColor: whitecolor,
        textstyle: background,
        validation: (value) => Validation.validateName(value),
        borderColor: dropdownborder,
        controller: _cardholdercontroller,
        hintText: 'Card Holder Name',
        hintColor: dropdownhint,
      ),
    );
  }

  Widget getApplePay() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            // for (int i = 0; i < card.length; i++) {
            //   card[i]['ischeck'] = (i == index);
            // }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              icApple,
              // card[index]['image'],
              height: 39,
              width: 63,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: getTextWidget(
                  title: 'Apple Pay',
                  textFontSize: fontSize16,
                  textFontWeight: fontWeightRegular,
                  textColor: background),
            ),
            const Spacer(),
            Image.asset(
              icUnCheckRadio,
              height: 26,
              width: 26,
            )
          ],
        ),
      ),
    );
  }

  Widget getPaypal() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            isPaypalselected = !isPaypalselected;
            isCardSelected = true;
            // for (int i = 0; i < card.length; i++) {
            //   card[i]['ischeck'] = (i == index);
            // }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              icPaypal,
              // card[index]['image'],
              height: 39,
              width: 63,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: getTextWidget(
                  title: 'Paypal',
                  textFontSize: fontSize16,
                  textFontWeight: fontWeightRegular,
                  textColor: background),
            ),
            const Spacer(),
            Image.asset(
              isPaypalselected ? icOrangeRadio : icUnCheckRadio,
              height: 26,
              width: 26,
            )
          ],
        ),
      ),
    );
  }

  Widget getCashondelivery() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            isCodSelected = !isCodSelected;
            isCardSelected = false;
            // for (int i = 0; i < card.length; i++) {
            //   card[i]['ischeck'] = (i == index);
            // }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              icCod,
              // card[index]['image'],
              height: 39,
              width: 63,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: getTextWidget(
                  title: 'Cash on Delivery',
                  textFontSize: fontSize16,
                  textFontWeight: fontWeightRegular,
                  textColor: background),
            ),
            const Spacer(),
            Image.asset(
              isCodSelected ? icOrangeRadio : icUnCheckRadio,
              height: 26,
              width: 26,
            )
          ],
        ),
      ),
    );
  }

  Widget getCard() {
    return card.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: getTextWidget(
                  title: 'There are no card\'s',
                  textFontSize: fontSize16,
                  textFontWeight: fontWeightSemiBold,
                  textColor: background),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: card.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      // isCardSelected = !isCardSelected;
                      isCodSelected = false;
                      isCardSelected = true;
                      selectedCard = index;
                      // for (int i = 0; i < card.length; i++) {
                      //   card[i]['ischeck'] = (i == index);
                      // }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        icVisa,
                        // card[index]['image'],
                        height: 39,
                        width: 63,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: getTextWidget(
                            title: 'XXXX XXXX XXXX ${card[index].cardNumber}',
                            textFontSize: fontSize16,
                            textFontWeight: fontWeightRegular,
                            textColor: background),
                      ),
                      const Spacer(),
                      Image.asset(
                        index == selectedCard && isCardSelected
                            ? icOrangeRadio
                            : icUnCheckRadio,
                        height: 26,
                        width: 26,
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
