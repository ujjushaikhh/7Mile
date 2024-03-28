import 'dart:convert';
import 'package:customerflow/ui/Cart/Model/paypalmodel.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/ui/Success/success_payement.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constant/api_constant.dart';
import '../../../constant/color_constant.dart';
import '../../../constant/font_constant.dart';
import '../../../constant/image_constant.dart';
import '../../../utils/button.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/textwidget.dart';
import '../../My Address/model/getaddressmodel.dart';
import '../Model/getcartmodel.dart';
import '../Model/updatecartmodel.dart';

class MyCheckoutConfirm extends StatefulWidget {
  // final String? cardId;
  // final String? last4;
  const MyCheckoutConfirm({
    super.key,
    // this.cardId, this.last4
  });

  @override
  State<MyCheckoutConfirm> createState() => _MyCheckoutConfirmState();
}

class _MyCheckoutConfirmState extends State<MyCheckoutConfirm> {
  @override
  void initState() {
    super.initState();
    getCartapi();
    // getaddressmodelapi(
    //
    // );
  }

  String? clientid =
      "ARWqfKoUzF-Kwd4tJ-Sf2VFQz4qClXbRZB9YsckVTqQ_wNFP2ad7J2_YMg1_ioeOdnt6dF4_2-HTx-MY";
  String? secretid =
      "EC9vyZzRfkuFiIxHhbzLbwCd2tXrMw-fcdg0zKE5M0LxfhnRGRrUXTYKDueAlWtwGGlZNcnApB40IF4o";

  String? grandType = "client_credentials";
  int? deliveryCharge = 10;
  int? serviceCharge = 5;
  int? couponCharge = 0;
  int? totalPrice;
  // int? addressid;
  // final List cart = [
  //   {
  //     'image': icItem1,
  //     'name': 'Disposable Device',
  //     'price': '\$ 128',
  //     'qty': 1
  //   },
  //   {
  //     'image': icItem3,
  //     'name': 'Disposable Device',
  //     'price': '\$ 128',
  //     'qty': 1
  //   },
  //   {
  //     'image': icItem2,
  //     'name': 'Disposable Device',
  //     'price': '\$ 128',
  //     'qty': 1
  //   },
  // ];

  int cartId = 0;
  int cartlength = 0;
  List<Products> cartProduct = [];
  List<Address> addresslist = [];
  List<Map<String, dynamic>> transactionlist = [];
  var houseno = getString('homenum');
  var address = getString('address');
  // var addressid = getInt('addressid');
  var zipcode = getString('zipcode');
  var token = getString('token');

  Future<void> updateCartapi(var cartdetailid, int defProductid,
      var defincrement, var defdecrement) async {
    if (await checkUserConnection()) {
      try {
        // ProgressDialogUtils.showProgressDialog(context);

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
        desc: 'Check internet connection',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

  Future<void> removeProductapi(var cartdetailid) async {
    if (await checkUserConnection()) {
      try {
        // ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer ' '$token',
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(removeproducturl));
        request.body =
            json.encode({'cart_id': cartId, 'cart_detail_id': cartdetailid});

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
            });
          } else {
            debugPrint('status ${updatecartModel.message}');
            // ProgressDialogUtils.dismissProgressDialog();
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
        desc: 'Check internet connection',
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
                cartProduct = getCart.data!.products!;
                cartId = getCart.data!.id!;
                totalPrice = getCart.data!.totalPrice!;
                cartlength = getCart.data!.products!.length;
                // serviceCharge = getCart.data!.serviceCharge!;
                // totalPrice = getCart.data!.totalPrice!;
                // finalprice = totalPrice + serviceCharge;

                transactionlist.clear();
                for (var items in cartProduct) {
                  transactionlist.add({
                    "name": items.name,
                    "quantity": items.productQty!,
                    "price": items.price,
                    "currency": "USD"
                  });
                }
                // transactionlist.add({
                //   "name": cartProduct.map((e) => e.name).toString(),
                //   "quantity":
                //       cartProduct.map((e) => int.tryParse(e.productQty!)),
                //   "price": cartProduct.map((e) => e.price),
                //   "currency": "USD"
                // });

                debugPrint('New List $transactionlist');
              });
              debugPrint('$totalPrice');
              debugPrint('$cartId');
            } else {
              ("The Message ${getCart.message}");
            }

            // for (var productid in cartProduct) {
            //   productId = productid.productId!;
            // }
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            debugPrint("The Message ${getCart.message}");
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
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
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getCart.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getCart.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
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

  Future<void> checkoutapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      try {
        if (showProgress) {
          if (!mounted) return;
          ProgressDialogUtils.showProgressDialog(context);
        }

        String basicAuth =
            'Basic ${base64.encode(utf8.encode('$clientid:$secretid'))}';
        debugPrint('Basic Auth :-  $basicAuth');
        debugPrint("var grandtype: $grandType");

        var headers = {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        };

        var request = http.Request('POST', Uri.parse(paypalurl));
        request.bodyFields = {'grant_type': 'client_credentials'};

        debugPrint('URl $paypalurl');

        request.headers.addAll(headers);
        debugPrint("Header ${request.headers}");
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var checkout = PayPalModel.fromJson(jsonResponse);

        debugPrint("Status ${response.statusCode}");
        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();

          // debugPrint('Final Price $finalPrice');
          // debugPrint('Shipping Charge $shippingCharge');
          // debugPrint('Coupon Charge $couponCharge');

          debugPrint("Success");
          debugPrint(' Access Token :-${checkout.accessToken}');
          if (!mounted) return;
          var finalPrice =
              (totalPrice! + deliveryCharge! + serviceCharge!) - couponCharge!;
          var shippingCharge = deliveryCharge! + serviceCharge!;
          debugPrint('$finalPrice');
          debugPrint('$couponCharge');
          debugPrint('$shippingCharge');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => PaypalCheckoutView(
                  sandboxMode: true,
                  clientId: clientid,
                  secretKey: secretid,
                  // returnURL: "https://samplesite.com/return",
                  // cancelURL: "https://samplesite.com/cancel",
                  transactions: [
                    {
                      "amount": {
                        "total": finalPrice.toString(),
                        "currency": "USD",
                        "details": {
                          "subtotal": totalPrice.toString(),
                          "shipping": shippingCharge.toString(),
                          "shipping_discount": couponCharge
                        }
                      },
                      "description": "The payment transaction description.",
                      // "payment_options": {
                      //   "allowed_payment_method":
                      //       "INSTANT_FUNDING_SOURCE"
                      // },
                      "item_list": {
                        "items": transactionlist,
                        // [
                        //   {
                        //     "name": "A demo product",
                        //     "quantity": 1,
                        //     "price": '10.12',
                        //     "currency": "USD"
                        //   }
                        // ],

                        // shipping address is not required though
                        "shipping_address": {
                          "recipient_name": getString('name'),
                          "line1": getString('address'),
                          "line2": "",
                          "city": getString('city'),
                          "country_code": "US",
                          "postal_code": getString('zipcode'),
                          "phone": getString('mobilenum'),
                          "state": getString('state')
                        },
                      }
                    }
                  ],
                  note: "Contact us for any questions on your order.",
                  onSuccess: (Map params) async {
                    debugPrint("onSuccess: $params");
                    debugPrint('It is done');
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MySuuccessPayment()),
                        (route) => false);
                    // checkoutapi();
                  },
                  onError: (error) {
                    debugPrint("onError: $error");
                  },
                  onCancel: (params) {
                    debugPrint('cancelled: $params');
                  }),
            ),
          );

          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => MySuuccessPayment(
          //               cartid: cartId,
          //             )),
          //     (route) => false);
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => MyPapPal(
          //           clientid: clientid,
          //           secretid: secretid,
          //           couponCharge: couponCharge!.toString(),
          //           finalPrice: finalPrice.toString(),
          //           shippingCharge: shippingCharge.toString(),
          //           totalPrice: totalPrice!.toString(),
          //           transactionlist: transactionlist,
          //         )));
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: '400 Bad Request	',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "404 Not Found	",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 405) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "405 Method Not Allowed	",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: "Internal Server Error",
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

  // Future<dynamic> checkoutapi() async {
  //   if (await checkUserConnection()) {
  //     try {
  //       if (!mounted) return;
  //       ProgressDialogUtils.showProgressDialog(context);

  //       var headers = {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       };
  //       var request = http.Request('POST', Uri.parse(checkouturl));
  //       var finalPrice =
  //           (totalPrice! + deliveryCharge! + serviceCharge!) - couponCharge!;
  //       request.body = json.encode({
  //         'cardID': widget.cardId!.toString(),
  //         'cart_id': cartId.toInt(),
  //         'address_id': addressid,
  //         'delivery_charge': deliveryCharge.toString(),
  //         'service_charge': serviceCharge.toString(),
  //         'coupon_price': couponCharge.toString(),
  //         'total_price': finalPrice.toString(),
  //         'type': 'Stripe',
  //         'transaction_id': ''
  //       });
  //       debugPrint(request.body);

  //       request.headers.addAll(headers);
  //       http.StreamedResponse response = await request.send();
  //       final responsed = await http.Response.fromStream(response);
  //       var jsonResponse = jsonDecode(responsed.body);
  //       var checkout = CheckOutModel.fromJson(jsonResponse);

  //       debugPrint(responsed.body);
  //       if (response.statusCode == 200) {
  //         debugPrint(responsed.body);
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (checkout.status == 1) {
  //           if (!mounted) return;
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => MySuuccessPayment(
  //                         cartid: cartId,
  //                       )));
  //         } else {
  //           debugPrint('failed to login');
  //           ProgressDialogUtils.dismissProgressDialog();
  //         }
  //       } else if (response.statusCode == 400) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //             context: context,
  //             desc: '${checkout.message}',
  //             onPressed: () {
  //               Navigator.pop(context);
  //             }).show();
  //       } else if (response.statusCode == 404) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         //  displayToast("There is no account with that user name & password !");
  //         vapeAlertDialogue(
  //             context: context,
  //             desc: "${checkout.message}",
  //             onPressed: () {
  //               Navigator.pop(context);
  //             }).show();
  //       } else if (response.statusCode == 401) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         //  displayToast("There is no account with that user name & password !");
  //         vapeAlertDialogue(
  //             context: context,
  //             desc: "${checkout.message}",
  //             onPressed: () {
  //               Navigator.pop(context);
  //             }).show();
  //       } else if (response.statusCode == 500) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         //  displayToast("There is no account with that user name & password !");
  //         vapeAlertDialogue(
  //             context: context,
  //             desc: "${checkout.message}",
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

  // Future<void> getaddressmodelapi() async {
  //   if (await checkUserConnection()) {
  //     if (!mounted) return;
  //     // ProgressDialogUtils.showProgressDialog(context);
  //     try {
  //       var apiurl = getAddressurl;
  //       debugPrint(apiurl);
  //       var headers = {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       };

  //       debugPrint(token);

  //       var request = http.Request('GET', Uri.parse(apiurl));

  //       request.headers.addAll(headers);
  //       http.StreamedResponse response = await request.send();
  //       final responsed = await http.Response.fromStream(response);
  //       var jsonResponse = jsonDecode(responsed.body);
  //       var getaddressmodel = GetAddressModel.fromJson(jsonResponse);

  //       debugPrint(responsed.body);
  //       if (response.statusCode == 200) {
  //         debugPrint(responsed.body);
  //         // ProgressDialogUtils.dismissProgressDialog();
  //         if (getaddressmodel.status == 1) {
  //           setState(() {
  //             addresslist = getaddressmodel.address!;
  //             for (var id in addresslist) {
  //               addressid = id.addressid!;
  //             }
  //             debugPrint('$addressid');
  //           });
  //           debugPrint('is it success');
  //         } else {
  //           debugPrint('failed to load');
  //           ProgressDialogUtils.dismissProgressDialog();
  //         }
  //       } else if (response.statusCode == 401) {
  //         // ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getaddressmodel.message}',
  //           onPressed: () {
  //             // Navigator.pushAndRemoveUntil(
  //             //     context,
  //             //     MaterialPageRoute(builder: (context) => LoginScreen()),
  //             //     (route) => false);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 404) {
  //         // ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getaddressmodel.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 400) {
  //         // ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getaddressmodel.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 500) {
  //         // ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getaddressmodel.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       }
  //     } catch (e) {
  //       // ProgressDialogUtils.dismissProgressDialog();
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
  //       desc: 'Check Internet Connection',
  //       onPressed: () {
  //         Navigator.of(context, rootNavigator: true).pop();
  //       },
  //     ).show();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      tick(orangecolor, false)
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
                          textColor: orangecolor)
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
                child: Column(
                  children: [
                    getItem(),
                    getCart(),
                    getDelivery(),
                    getDeliveryAddress(),
                    getPayment(),
                    getCreditCard(),
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

  Widget line(Color linecolor) {
    return Container(
      color: linecolor,
      height: 3.0,
      width: 130.0,
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
      padding: const EdgeInsets.only(bottom: 16.0, top: 25),
      child: CustomizeButton(
        text: 'Place Order',
        onPressed: () {
          checkoutapi();
        },

        // onPressed:
        // async {

        //   //if (!mounted) return;
        //   await Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => UsePaypal(
        //           sandboxMode: true,
        //           clientId: clientid!,
        //           secretKey: secretid!,
        //           returnURL: "https://samplesite.com/return",
        //           cancelURL: "https://samplesite.com/cancel",
        //           transactions: [
        //             {
        //               "amount": {
        //                 "total": finalPrice.toString(),
        //                 "currency": "USD",
        //                 "details": {
        //                   "subtotal": totalPrice!.toString(),
        //                   "shipping": shippingCharge.toString(),
        //                   "shipping_discount": couponCharge.toString()
        //                 }
        //               },
        //               "description": "The payment transaction description.",
        //               // "payment_options": {
        //               //   "allowed_payment_method":
        //               //       "INSTANT_FUNDING_SOURCE"
        //               // },
        //               "item_list": {
        //                 "items": transactionlist,
        //                 // [
        //                 //   {
        //                 //     "name":
        //                 //         cartProduct.map((e) => e.name).toString(),
        //                 //     "quantity":
        //                 //         cartProduct.map((e) => e.productQty),
        //                 //     "price": cartProduct.map((e) => e.price),
        //                 //     "currency": "USD"
        //                 //   }
        //                 // ],

        //                 // shipping address is not required though
        //                 // "shipping_address": {
        //                 //   "recipient_name": "Jane Foster",
        //                 //   "line1": "Travis County",
        //                 //   "line2": "",
        //                 //   "city": "Austin",
        //                 //   "country_code": "US",
        //                 //   "postal_code": "73301",
        //                 //   "phone": "+00000000",
        //                 //   "state": "Texas"
        //                 // },
        //               }
        //             }
        //           ],
        //           note: "Contact us for any questions on your order.",
        //           onSuccess: (Map params) async {
        //             debugPrint("onSuccess: $params");
        //             // Navigator.of(context).push(MaterialPageRoute(
        //             //     builder: (context) => const MySuuccessPayment()));
        //             // await checkoutapi();
        //           },
        //           onError: (error) {
        //             debugPrint("onError: $error");
        //           },
        //           onCancel: (params) {
        //             debugPrint('cancelled: $params');
        //           })));

        // checkoutapi();
        // }
      ),
    );
  }

  Widget getCreditCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: Container(
        // height: 77,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: lightPink),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 13.0, left: 20, bottom: 11, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getTextWidget(
                  title: 'Paypal',
                  textFontSize: fontSize15,
                  fontfamily: fontfamilyAvenir,
                  textFontWeight: fontWeight900,
                  textColor: background),
              Image.asset(
                icPaypal,
                width: 21.24,
                height: 25.38,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget getCreditCard() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 13.0),
  //     child: Container(
  //       height: 77,
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8), color: lightPink),
  //       child: Padding(
  //         padding:
  //             const EdgeInsets.only(top: 13.0, left: 20, bottom: 11, right: 20),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 getTextWidget(
  //                     title: 'Credit Card',
  //                     textFontSize: fontSize15,
  //                     fontfamily: fontfamilyAvenir,
  //                     textFontWeight: fontWeight900,
  //                     textColor: background),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 9.0),
  //                   child: Row(
  //                     children: [
  //                       Image.asset(
  //                         icDots,
  //                         height: 6,
  //                         width: 118,
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 8.0),
  //                         child: getTextWidget(
  //                             title: '${widget.last4}',
  //                             textFontSize: fontSize15,
  //                             textColor: background,
  //                             fontfamily: fontfamilyAvenir,
  //                             textFontWeight: fontWeightMedium),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Image.asset(
  //               icMasterCard,
  //               width: 50.29,
  //               height: 39.12,
  //               fit: BoxFit.cover,
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget getPayment() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: lightPink,
            ),
            child: Center(
              child: Image.asset(
                icCart,
                height: 20,
                color: blackcolor,
                width: 20,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: getTextWidget(
                title: 'Payment',
                textFontSize: fontSize16,
                textFontWeight: fontWeightSemiBold,
                textColor: background),
          ),
        ],
      ),
    );
  }

  Widget getItem() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: lightPink,
            ),
            child: Center(
              child: Image.asset(
                icCart,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: getTextWidget(
                title: 'In Your Cart',
                textFontSize: fontSize16,
                textFontWeight: fontWeightSemiBold,
                textColor: background),
          ),
          const Spacer(),
          getTextWidget(
              title: '${cartlength.toString()}' ' items',
              textFontSize: fontSize14,
              textFontWeight: fontWeightRegular,
              textColor: background)
        ],
      ),
    );
  }

  Widget getDeliveryAddress() {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: Container(
        // height: 77,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: lightPink,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 13.0, bottom: 14.0, right: 9.0, left: 20),
          child: getTextWidget(
              title: '$houseno $address $zipcode',
              textFontSize: fontSize14,
              textColor: background,
              textFontWeight: fontWeightRegular),
        ),
      ),
    );
  }

  Widget getDelivery() {
    return Padding(
      padding: const EdgeInsets.only(top: 29.0),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: lightPink,
            ),
            child: Center(
              child: Image.asset(
                icVan,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: getTextWidget(
                title: 'Delivery',
                textFontSize: fontSize16,
                textFontWeight: fontWeightSemiBold,
                textColor: background),
          ),
        ],
      ),
    );
  }

  Widget getCart() {
    return ListView.builder(
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
                        imageBuilder: (context, imageProvider) => Container(
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
                                color: Colors.grey, shape: BoxShape.circle),
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
                        getTextWidget(
                            title: cartProduct[index].name!.toString(),
                            textFontSize: fontSize16,
                            textFontWeight: fontWeightMedium,
                            textColor: background),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 116,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getTextWidget(
                                    title: '\$ '
                                        '${cartProduct[index].price!.toString()}',
                                    textFontSize: fontSize16,
                                    textFontWeight: fontWeightMedium,
                                    textColor: orangecolor),
                                Container(
                                  height: 30,
                                  width: 115,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0xFFE2E2E2))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              updateCartapi(
                                                  cartProduct[index]
                                                      .cartDetailId,
                                                  cartProduct[index].productId!,
                                                  null,
                                                  1);
                                            });
                                          },
                                          icon: Image.asset(
                                            icMinus,
                                            height: 2,
                                            width: 10,
                                            color: const Color(0xff1F1C1C),
                                          )),
                                      getTextWidget(
                                          title: cartProduct[index]
                                              .productQty
                                              .toString(),
                                          fontfamily: fontfamilyAvenir,
                                          textFontWeight: fontWeight900,
                                          textColor: const Color(0xff1F1C1C)),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              updateCartapi(
                                                  cartProduct[index]
                                                      .cartDetailId,
                                                  cartProduct[index].productId!,
                                                  1,
                                                  null);
                                            });
                                          },
                                          icon: Image.asset(
                                            icPlus,
                                            height: 10,
                                            width: 10,
                                            color: const Color(0xff1F1C1C),
                                          ))
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
    );
  }
}
