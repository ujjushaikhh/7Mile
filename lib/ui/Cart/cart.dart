import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/ui/Cart/Checkout/checkout_address.dart';
import 'package:customerflow/ui/Cart/Model/getcartmodel.dart';
import 'package:customerflow/ui/Cart/Model/updatecartmodel.dart';
import 'package:customerflow/utils/button.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:customerflow/utils/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/textwidget.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  void initState() {
    super.initState();
    getCartapi();
  }

  final _vouchercontroller = TextEditingController();
  var token = getString('token');
  int serviceCharge = 0;
  int totalPrice = 0;
  int finalprice = 0;
  int cartId = 0;
  int coupon = 10;
  List<Products> cartProduct = [];
  bool isload = true;
  bool isupdated = false;

  Future<void> updateCartapi(var cartdetailid, int defProductid,
      var defincrement, var defdecrement) async {
    if (await checkUserConnection()) {
      try {
        // ProgressDialogUtils.showProgressDialog(context);
        setState(() {
          isupdated = true;
        });

        var headers = {
          'Authorization': 'Bearer ' '$token',
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(updateQtyurl));
        request.body = json.encode({
          'product_id': defProductid,
          'cart_detail_id': cartdetailid,
          'increment': defincrement,
          'decrement': defdecrement
        });

        // debugPrint(request.body);
        request.headers.addAll(headers);
        debugPrint('Body :- ${request.body}');

        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var updatecartModel = UpdateQtyModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (updatecartModel.status == 1) {
            setState(() {
              getCartapi(showProgress: false);
              isupdated = false;
            });
          } else {
            // ProgressDialogUtils.dismissProgressDialog();
            if (!mounted) return;
            vapeAlertDialogue(
              context: context,
              desc: '${updatecartModel.message}',
              onPressed: () {
                Navigator.pop(context);
              },
            ).show();
          }
        } else if (response.statusCode == 404) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${updatecartModel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 401) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${updatecartModel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: 'Internal Server Error: ${updatecartModel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${updatecartModel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        }
      } catch (e) {
        // ProgressDialogUtils.dismissProgressDialog();
        debugPrint("$e");
        if (!mounted) return;
        vapeAlertDialogue(
          context: context,
          desc: 'Something went Wrong',
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

  Future<void> removeProductapi(var cartdetailid) async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer ' '$token',
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(removeproducturl));
        request.body =
            json.encode({'cart_id': cartId, 'cart_detail_id': cartdetailid});

        request.headers.addAll(headers);
        debugPrint('Body :- ${request.body}');

        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var updatecartModel = UpdateQtyModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          ProgressDialogUtils.dismissProgressDialog();
          if (updatecartModel.status == 1) {
            setState(() {
              getCartapi(showProgress: false);
            });
          } else {
            debugPrint('status ${updatecartModel.message}');
            ProgressDialogUtils.dismissProgressDialog();
            // if (mounted) return;
            // vapeAlertDialogue(
            //   context: context,
            //   desc: '${updatecartModel.message}',
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ).show();
          }
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${updatecartModel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${updatecartModel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: 'Internal Server Error: ${updatecartModel.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${updatecartModel.message}',
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
          desc: 'Something went Wrong',
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

  Future<void> getCartapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      if (showProgress) {
        ProgressDialogUtils.showProgressDialog(context);
      }

      try {
        var apiurl = getCarturl;
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
        var getCart = GetCartModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getCart.status == 1) {
            if (getCart.data != null) {
              setState(() {
                cartProduct = getCart.data!.products ?? [];
                cartId = getCart.data!.id!;
                serviceCharge = getCart.data!.serviceCharge!;
                totalPrice = getCart.data!.totalPrice!;
                finalprice = (totalPrice + serviceCharge) - coupon;
                isload = false;
              });
            } else {
              ("The Message if data is null:- ${getCart.message}");
            }

            // for (var productid in cartProduct) {
            //   productId = productid.productId!;
            // }
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            debugPrint("The Message ${getCart.message}");
            ProgressDialogUtils.dismissProgressDialog();
            setState(() {
              isload = false;
              cartProduct = [];
            });
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getCart.message}',
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
            desc: '${getCart.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getCart.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getCart.message}',
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
      resizeToAvoidBottomInset: false,
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : cartProduct.isNotEmpty
              ? SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          getCart(),
                          getVoucher(),
                          getBill(),
                          getButton(),
                          const SizedBox(
                            height: 90.0,
                          )
                        ],
                      )),
                )
              : Center(
                  child: getTextWidget(
                    title: 'No products in your cart',
                    textColor: background,
                    textFontSize: 20,
                    textFontWeight: fontWeightSemiBold,
                  ),
                ),
    );
  }

  Widget getButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16, top: 20),
      child: CustomizeButton(
          text: 'Add to Cart',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyCheckoutAddress()));
          }),
    );
  }

  Widget getBill() {
    return Padding(
      padding: const EdgeInsets.only(top: 17.0, left: 16, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTextWidget(
              title: 'Bill Details',
              textFontSize: fontSize18,
              textFontWeight: fontWeightMedium,
              textColor: background),
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                    title: 'Sub Total',
                    textFontWeight: fontWeightMedium,
                    textFontSize: fontSize14,
                    textColor: background),
                getTextWidget(
                    title: '\$ ' '$totalPrice',
                    textFontWeight: fontWeightRegular,
                    textFontSize: fontSize14,
                    textColor: background)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                    title: 'Service Fee',
                    textFontWeight: fontWeightMedium,
                    textFontSize: fontSize14,
                    textColor: background),
                getTextWidget(
                    title: '\$' '$serviceCharge',
                    textFontWeight: fontWeightRegular,
                    textFontSize: fontSize14,
                    textColor: background)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                    title: 'Coupon Discount',
                    textFontWeight: fontWeightMedium,
                    textFontSize: fontSize14,
                    textColor: background),
                getTextWidget(
                    title: '- \$ $coupon',
                    textFontWeight: fontWeightRegular,
                    textFontSize: fontSize14,
                    textColor: background)
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 29.0),
            child: Divider(
              color: dropdownborder,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 13.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                    title: 'Total',
                    textFontWeight: fontWeightBold,
                    textFontSize: fontSize14,
                    textColor: background),
                getTextWidget(
                    title: '\$' '$finalprice',
                    textFontWeight: fontWeightBold,
                    textFontSize: fontSize14,
                    textColor: background)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getVoucher() {
    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 113,
        color: const Color(0xFFFCEBE8),
        child: Padding(
          padding: const EdgeInsets.only(top: 11.0, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTextWidget(
                  title: 'Add Voucher Code',
                  textColor: const Color(0xFF171210),
                  textFontSize: fontSize18,
                  textFontWeight: fontWeightSemiBold),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 18.0),
                child: TextFormDriver(
                  controller: _vouchercontroller,
                  hintText: 'Voucher Code',
                  hintColor: dropdownhint,
                  prefixIcon: icCoupon,
                  suffixIcon: icApply,
                  suffixiconcolor: orangecolor,
                  // suffix: Padding(
                  //   padding: const EdgeInsets.only(right: 16.0),
                  //   child: getTextWidget(
                  //       title: 'Apply',
                  //       textFontSize: fontSize14,
                  //       textFontWeight: fontWeightSemiBold,
                  //       textColor: orangecolor),
                  // ),
                  textstyle: background,
                  prefixiconcolor: orangecolor,
                  fillColor: whitecolor,
                  borderColor: const Color(0xFFE3CDD7),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getCart() {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: MediaQuery.removePadding(
          removeBottom: true,
          context: context,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartProduct.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 19.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const MyOrderDetails()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 71.0,
                                width: 71.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle),
                                ),
                              ),
                              imageUrl: cartProduct[index].image.toString(),
                              height: 71.0,
                              width: 71.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13.0, top: 7.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 116,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      getTextWidget(
                                          title: cartProduct[index]
                                              .name!
                                              .toString(),
                                          textFontSize: fontSize16,
                                          textFontWeight: fontWeightMedium,
                                          textColor: background),
                                      GestureDetector(
                                        onTap: () {
                                          removeProductapi(
                                              cartProduct[index].cartDetailId);
                                        },
                                        child: Image.asset(
                                          icClose,
                                          height: 24,
                                          width: 24,
                                          color: background,
                                        ),
                                      )
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 116,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      getTextWidget(
                                          title: '\$ '
                                              '${cartProduct[index].price!}',
                                          textFontSize: fontSize16,
                                          textFontWeight: fontWeightMedium,
                                          textColor: orangecolor),
                                      Container(
                                        height: 30,
                                        width: 115,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            border: Border.all(
                                                width: 1,
                                                color:
                                                    const Color(0xFFE2E2E2))),
                                        child: isupdated
                                            ? const SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: greencolor,
                                                  ),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          updateCartapi(
                                                              cartProduct[index]
                                                                  .cartDetailId,
                                                              cartProduct[index]
                                                                  .productId!,
                                                              null,
                                                              1);
                                                        });
                                                      },
                                                      icon: Image.asset(
                                                        icMinus,
                                                        height: 2,
                                                        width: 10,
                                                        color: const Color(
                                                            0xff1F1C1C),
                                                      )),
                                                  getTextWidget(
                                                      title: cartProduct[index]
                                                          .productQty
                                                          .toString(),
                                                      fontfamily:
                                                          fontfamilyAvenir,
                                                      textFontWeight:
                                                          fontWeight900,
                                                      textColor: const Color(
                                                          0xff1F1C1C)),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          updateCartapi(
                                                              cartProduct[index]
                                                                  .cartDetailId,
                                                              cartProduct[index]
                                                                  .productId!,
                                                              1,
                                                              null);
                                                        });
                                                      },
                                                      icon: Image.asset(
                                                        icPlus,
                                                        height: 10,
                                                        width: 10,
                                                        color: const Color(
                                                            0xff1F1C1C),
                                                      )),
                                                ],
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 18.0),
                      child: Divider(
                        color: dropdownborder,
                        height: 1,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}
