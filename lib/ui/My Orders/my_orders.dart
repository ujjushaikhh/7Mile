import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/ui/My%20Orders/model/myorder_model.dart';
import 'package:customerflow/ui/Order%20Details/order_details.dart';
import 'package:customerflow/utils/button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';
import '../../utils/validation.dart';
import 'model/rate_model.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  double rate = 0.0;

  // int? cartDetailid;
  int? pId;
  bool isLoad = true;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getOrderapi();
  }

  // List<int>? cartdetailids;

  Future<dynamic> postRatingApi(int cartDetailid) async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
        var token = getString('token');
        var apiurl = ratingurl;
        var headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = json.encode({
          "product_id": 2,
          "cart_details_id": cartDetailid,
          "rate": rate,
          "review": reviewcontroller.text.toString()
        });
        debugPrint(request.body);
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var rateModel = RatingModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (rateModel.status == 1) {
            if (!mounted) return;
            Navigator.pop(context);
            reviewcontroller.clear();
            Fluttertoast.showToast(msg: 'Rated Successfully');
            // postOtherUserDetails();
            // Navigator.pop(context);
            debugPrint('Success');
          } else {
            debugPrint('${rateModel.message}');
            if (!mounted) return;
            vapeAlertDialogue(
                context: context,
                desc: '${rateModel.message}',
                onPressed: () {
                  Navigator.pop(context);
                }).show();
            // Navigator.pop(context);
          }
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: '${rateModel.message}',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: '${rateModel.message}',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: '${rateModel.message}',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: '${rateModel.message}',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        }
      } catch (error) {
        ProgressDialogUtils.dismissProgressDialog();
        debugPrint("$error");
        if (!mounted) return;
        vapeAlertDialogue(
            context: context,
            desc: '$error',
            onPressed: () {
              Navigator.pop(context);
            }).show();
      }
    } else {
      ProgressDialogUtils.dismissProgressDialog();
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

  Future<void> getOrderapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }

      try {
        var apiurl = myorderurl;
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
        var getOrder = MyOrderModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getOrder.status == 1) {
            setState(() {
              myOrders = getOrder.cart ?? [];

              // for (var allProducts in myOrders) {
              //   myproducts.addAll(allProducts.products!);
              // }
            });

            debugPrint('Length of Cart :-${myOrders.length}');
            isLoad = false;

            // debugPrint('Cart Detail id: $cartDetailid');
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
            myOrders = [];
            isLoad = false;
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getOrder.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getOrder.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getOrder.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getOrder.message}',
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

  final reviewcontroller = TextEditingController();
  // List<Products> myproducts = [];
  List<Cart> myOrders = [
    // MyOrderss(
    //     productImg: icHookah1,
    //     productPrice: '\$ 199.00',
    //     productName: 'Disposable \ndevice',
    //     status: 'Cancelled',
    //     productQty: 'QTY: 1',
    //     orderId: 'Order ID: #85304583534'),
    // MyOrderss(
    //     productImg: icHookah3,
    //     productPrice: '\$ 199.00',
    //     productName: 'Disposable \ndevice',
    //     status: 'Shipped',
    //     productQty: 'QTY: 1',
    //     orderId: 'Order ID: #85304583534'),
    // MyOrderss(
    //     productImg: icHookah2,
    //     productPrice: '\$ 199.00',
    //     productName: 'Disposable \ndevice',
    //     status: 'Delivered',
    //     productQty: 'QTY: 1',
    //     orderId: 'Order ID: #85304583534'),
    // MyOrderss(
    //     productImg: icHookah1,
    //     productPrice: '\$ 199.00',
    //     productName: 'Disposable \ndevice',
    //     status: 'Delivered',
    //     productQty: 'QTY: 1',
    //     orderId: 'Order ID: #85304583534'),
    // MyOrderss(
    //     productImg: icHookah,
    //     productPrice: '\$ 199.00',
    //     productName: 'Disposable \ndevice',
    //     status: 'Delivered',
    //     productQty: 'QTY: 1',
    //     orderId: 'Order ID: #85304583534')
  ];
  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: background,
        centerTitle: true,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: getTextWidget(
              title: 'My Orders',
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
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : myOrders.isEmpty
              ? Center(
                  child: getTextWidget(
                      title: 'No Order\'s are  there',
                      textFontSize: fontSize25,
                      textColor: background,
                      textFontWeight: fontWeightSemiBold),
                )
              : ListView.builder(
                  itemCount: myOrders.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 16, right: 16.0, bottom: 16.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myOrders[index].products!.length,
                        itemBuilder: (context, innerlist) {
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyOrderDetails(
                                            cardlast4: getString('cardlast4'),
                                            cartid: myOrders[index].cartId,
                                            iscancel: myOrders[index]
                                                .products![innerlist]
                                                .isCancel,
                                            cartdetailid: myOrders[index]
                                                .products![innerlist]
                                                .cartDetailsId,
                                            address: myOrders[index]
                                                .address!
                                                .toString(),
                                            zipcode: myOrders[index]
                                                .zipcode!
                                                .toString(),
                                            houseno: myOrders[index]
                                                .houseNo!
                                                .toString(),
                                            name: myOrders[index]
                                                .products![innerlist]
                                                .name!
                                                .toString(),
                                            image: myOrders[index]
                                                .products![innerlist]
                                                .image!
                                                .toString(),
                                            prdctQty: myOrders[index]
                                                .products![innerlist]
                                                .productQty!
                                                .toString(),
                                            price: myOrders[index]
                                                .products![innerlist]
                                                .price!
                                                .toString(),
                                            productStatus: myOrders[index]
                                                .products![innerlist]
                                                .orderStatus,
                                            rmOrderid: myOrders[index]
                                                .products![innerlist]
                                                .rmdOrderId!
                                                .toString(),
                                          ),
                                        ),
                                      ).whenComplete(() {
                                        setState(() {
                                          getOrderapi(showProgress: false);
                                        });
                                      });
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: CachedNetworkImage(
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        imageUrl: myOrders[index]
                                            .products![innerlist]
                                            .image
                                            .toString(),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getTextWidget(
                                            title: myOrders[index]
                                                .products![innerlist]
                                                .name!
                                                .toString(),
                                            textFontSize: fontSize16,
                                            textFontWeight: fontWeightMedium,
                                            textColor: ordertitle),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: SizedBox(
                                            width: screenSize!.width - 160,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                getTextWidget(
                                                    title:
                                                        '\$ ${myOrders[index].products![innerlist].price!}',
                                                    textFontSize: fontSize16,
                                                    textFontWeight:
                                                        fontWeightMedium,
                                                    textColor: lightorange2),
                                                getTextWidget(
                                                    title:
                                                        ' QTY :${myOrders[index].products![innerlist].productQty!}',
                                                    textFontSize: fontSize16,
                                                    textFontWeight:
                                                        fontWeightMedium,
                                                    textColor: ordertitle)
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    getTextWidget(
                                        title:
                                            'Order ID : ${myOrders[index].products![innerlist].rmdOrderId}',
                                        textFontWeight: fontWeightRegular,
                                        textColor: ordertitle),
                                    myOrders[index].products![innerlist].orderStatus == 1 &&
                                            myOrders[index]
                                                    .products![innerlist]
                                                    .isCancel ==
                                                0
                                        ? Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                                color: greencolor,
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                            child: getTextWidget(
                                                title: 'Delivered',
                                                textColor: whitecolor,
                                                textFontSize: fontSize12,
                                                textFontWeight:
                                                    fontWeightExtraBold),
                                          )
                                        : myOrders[index].products![innerlist].orderStatus == 0 &&
                                                myOrders[index]
                                                        .products![innerlist]
                                                        .isCancel ==
                                                    0
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                decoration: BoxDecoration(
                                                    color: yellow,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: getTextWidget(
                                                    title: 'Shipped',
                                                    textColor: ordertitle,
                                                    textFontSize: fontSize12,
                                                    textFontWeight:
                                                        fontWeightExtraBold))
                                            : myOrders[index]
                                                        .products![innerlist]
                                                        .isCancel ==
                                                    1
                                                ? Container(
                                                    padding: const EdgeInsets.all(4.0),
                                                    decoration: BoxDecoration(color: orangecolor, borderRadius: BorderRadius.circular(2)),
                                                    child: getTextWidget(title: 'Cancelled', textColor: whitecolor, textFontSize: fontSize12, textFontWeight: fontWeightExtraBold))
                                                : Container()
                                  ],
                                ),
                              ),
                              myOrders[index]
                                              .products![innerlist]
                                              .orderStatus ==
                                          1 &&
                                      myOrders[index]
                                              .products![innerlist]
                                              .isCancel ==
                                          0 &&
                                      myOrders[index]
                                              .products![innerlist]
                                              .isRate ==
                                          0
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 21.0),
                                      child: CustomizeButton(
                                        text: 'Rate this Product',
                                        onPressed: () {
                                          showRatingDialog(myOrders[index]
                                              .products![innerlist]
                                              .cartDetailsId!);
                                        },
                                        buttonHeight: 35,
                                        color: whitecolor,
                                        borderWidth: 1.0,
                                        textcolor: greencolor,
                                      ),
                                    )
                                  : Container()
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  showRatingDialog(int cartdetailid) {
    showDialog(
      builder: (context) {
        // var width = MediaQuery.of(context).size.width;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: SingleChildScrollView(
            child: Container(
              color: whitecolor,
              // width: width,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Center(
                          child: getTextWidget(
                              title: 'Rate this Product',
                              fontfamily: fontfamilyBevietnam,
                              textFontSize: fontSize21,
                              textFontWeight: fontWeightSemiBold,
                              textColor: ordertitle),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3.12),
                          child: Center(
                            child: Image.asset(
                              icHookah3,
                              height: 78,
                              width: 78,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 11.0),
                        child: Center(
                          child: getTextWidget(
                              title: 'Disposable devices',
                              fontfamily: fontfamilyBevietnam,
                              textFontSize: fontSize15,
                              textFontWeight: fontWeightSemiBold,
                              textColor: ordertitle),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 33.0),
                        child: Center(
                          child: RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 44,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Image.asset(
                              icStarh,
                              height: 44,
                              width: 44,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                rate = double.parse(rating.toString());
                              });
                              debugPrint('Rate :-$rate');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 42.0),
                        child: getTextWidget(
                            title: 'Review',
                            textFontWeight: fontWeightMedium,
                            textFontSize: fontSize15,
                            textColor: background),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextFormField(
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => Validation.validateText(value),
                          controller: reviewcontroller,
                          style: const TextStyle(color: background),
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Write here',
                            hintStyle: const TextStyle(
                                color: Color(0xFF6F7888),
                                fontSize: fontSize14,
                                fontFamily: fontfamilybeVietnam,
                                fontWeight: fontWeightRegular),
                            // contentPadding: const EdgeInsets.only(
                            //     left: 16.0, right: 16.0, top: 16, bottom: 16),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide:
                                    const BorderSide(color: dropdownborder)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide:
                                  const BorderSide(color: dropdownborder),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(color: orangecolor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide:
                                  const BorderSide(color: dropdownborder),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: CustomizeButton(
                            text: 'Submit',
                            onPressed: () {
                              if (rate == 0.0) {
                                vapeAlertDialogue(
                                    context: context,
                                    desc: 'please select a Star',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }).show();
                              } else {
                                if (_formkey.currentState!.validate()) {
                                  postRatingApi(cartdetailid);
                                }
                              }
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const MySuuccessPayment()));
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }
}
