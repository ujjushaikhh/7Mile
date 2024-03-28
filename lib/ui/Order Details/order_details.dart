import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/constant/api_constant.dart';
import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/ui/Order%20Details/model/cancel_model.dart';
import 'package:customerflow/ui/Track%20Order/track_order.dart';
import 'package:customerflow/utils/button.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/textwidget.dart';

class MyOrderDetails extends StatefulWidget {
  final int? cartdetailid;
  final int? productStatus;
  final String? image;
  final int? iscancel;
  final String? name;
  final String? price;
  final String? rmOrderid;
  final String? prdctQty;
  final String? houseno;
  final String? zipcode;
  final String? address;
  final int? cartid;
  final String? cardlast4;

  const MyOrderDetails(
      {super.key,
      this.image,
      this.cardlast4,
      this.address,
      this.houseno,
      this.iscancel,
      this.cartid,
      this.zipcode,
      this.cartdetailid,
      this.name,
      this.prdctQty,
      this.price,
      this.productStatus,
      this.rmOrderid});

  @override
  State<MyOrderDetails> createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  int? status;

  Future<void> cancelorderapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = cancelorderurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('token'));

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = json.encode({"cart_id": widget.cartid});

        debugPrint(request.body);
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var cancelorder = CancelOrderModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (cancelorder.status == 1) {
            setState(() {
              Navigator.pop(context);
              debugPrint('Message :- ${cancelorder.message}');
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
            debugPrint(' Error Message :- ${cancelorder.message}');
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${cancelorder.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${cancelorder.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${cancelorder.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${cancelorder.message}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: background,
          centerTitle: true,
          elevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: getTextWidget(
                title: 'My Order Detail',
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
        body: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, left: 16, right: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                        height: 100,
                        width: 100,
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
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      imageUrl: widget.image.toString(),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTextWidget(
                            title: widget.name!.toString(),
                            textFontSize: fontSize16,
                            textFontWeight: fontWeightMedium,
                            textColor: ordertitle),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 160,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getTextWidget(
                                    title: '\$ ${widget.price!.toString()}',
                                    textFontSize: fontSize16,
                                    textFontWeight: fontWeightMedium,
                                    textColor: lightorange2),
                                getTextWidget(
                                    title:
                                        'QTY: ${widget.prdctQty!.toString()}',
                                    textFontSize: fontSize16,
                                    textFontWeight: fontWeightMedium,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getTextWidget(
                        title: 'Order ID: ${widget.rmOrderid}',
                        textFontWeight: fontWeightRegular,
                        textColor: ordertitle),
                    widget.productStatus == 0 && widget.iscancel == 0
                        ? Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                color: yellow,
                                borderRadius: BorderRadius.circular(2)),
                            child: getTextWidget(
                                title: 'Shipped',
                                textColor: ordertitle,
                                textFontSize: fontSize12,
                                textFontWeight: fontWeightExtraBold))
                        : widget.productStatus == 1 && widget.iscancel == 0
                            ? Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    color: greencolor,
                                    borderRadius: BorderRadius.circular(2)),
                                child: getTextWidget(
                                    title: 'Delivered',
                                    textColor: ordertitle,
                                    textFontSize: fontSize12,
                                    textFontWeight: fontWeightExtraBold))
                            : widget.iscancel == 1
                                ? Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                        color: orangecolor,
                                        borderRadius: BorderRadius.circular(2)),
                                    child: getTextWidget(
                                        title: 'Cancelled',
                                        textColor: whitecolor,
                                        textFontSize: fontSize12,
                                        textFontWeight: fontWeightExtraBold))
                                : Container()
                  ],
                ),
              ),
              Padding(
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: Container(
                  height: 77,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: lightPink,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 13.0, bottom: 14.0, right: 9.0, left: 20),
                    child: getTextWidget(
                        title:
                            '${widget.houseno!} , ${widget.address!} , ${widget.zipcode}',
                        textFontSize: fontSize14,
                        textColor: background,
                        textFontWeight: fontWeightRegular),
                  ),
                ),
              ),
              Padding(
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: Container(
                  height: 77,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), color: lightPink),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 13.0, left: 20, bottom: 11, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getTextWidget(
                                title: 'Credit Card',
                                textFontSize: fontSize15,
                                fontfamily: fontfamilyAvenir,
                                textFontWeight: fontWeight900,
                                textColor: background),
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    icDots,
                                    height: 6,
                                    width: 118,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: getTextWidget(
                                        title: widget.cardlast4!.toString(),
                                        textFontSize: fontSize15,
                                        textColor: background,
                                        fontfamily: fontfamilyAvenir,
                                        textFontWeight: fontWeightMedium),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          icMasterCard,
                          width: 50.29,
                          height: 39.12,
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              widget.iscancel != 1
                  ? CustomizeButton(
                      text: 'Track Order',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyTrackOrder(
                                      cartid: widget.cartid,
                                    )));
                        // trackorderapi();
                      })
                  : Container(),
              widget.iscancel != 1
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: CustomizeButton(
                        text: 'Cancel Order',
                        onPressed: () {
                          cancelorderapi();
                        },
                        color: whitecolor,
                        textcolor: greencolor,
                        borderColor: greencolor,
                        borderWidth: 1,
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
