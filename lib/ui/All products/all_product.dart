import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/constant/api_constant.dart';
import 'package:customerflow/ui/All%20products/model/allproductmodel.dart';
import 'package:customerflow/ui/Product%20Details/product_details.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/textwidget.dart';

class MyAllProducts extends StatefulWidget {
  const MyAllProducts({super.key});

  @override
  State<MyAllProducts> createState() => _MyAllProductsState();
}

class _MyAllProductsState extends State<MyAllProducts> {
  @override
  void initState() {
    super.initState();

    getAllProductapi();
  }

  List<Products> allProduct = [];
  int? productId;
  bool isload = true;

  Future<void> getAllProductapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = allproducturl;
        debugPrint(apiurl);
        var headers = {
          // 'Authorization': 'Bearer' '$token',
          'Content-Type': 'application/json',
        };

        // debugPrint(token);

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getAllProduct = GetAllProductModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getAllProduct.status == 1) {
            setState(() {
              allProduct = getAllProduct.products!;
              isload = false;
              // for (var productid in allProduct) {
              //   productId = productid.id!;

              // }
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
            setState(() {
              allProduct = [];
              isload = false;
            });
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getAllProduct.message}',
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
            desc: '${getAllProduct.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getAllProduct.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getAllProduct.message}',
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
              title: 'All Products',
              textColor: whitecolor,
              textFontWeight: fontWeightMedium,
              textFontSize: fontSize15),
        ),
        centerTitle: true,
      ),
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : allProduct.isEmpty
              ? Center(
                  child: getTextWidget(
                      title: 'No products are there',
                      textFontSize: fontSize20,
                      textColor: background,
                      textFontWeight: fontWeightSemiBold),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16,
                    top: 15,
                  ),
                  child: GridView.builder(
                    itemCount: allProduct.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 239,
                      // mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      String avgRatingString = allProduct[index].avgRating!;
                      double avgRating =
                          double.tryParse(avgRatingString) ?? 0.0;
                      String formattedAvgRating = avgRating.toStringAsFixed(2);

                      debugPrint(formattedAvgRating);
                      return Column(
                        // crossAxisAlignment: CrossAxis
                        // Alignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyProductDetailScreen(
                                            productid: allProduct[index].id,
                                          )));
                            },
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6.0),
                                  topRight: Radius.circular(6)),
                              child: CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 130,
                                  // width: 78.0,
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
                                    height: 130.0,
                                    width: 130.0,
                                    decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                imageUrl: allProduct[index].image.toString(),
                                height: 130.0,
                                // width: 78.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            // width: 133,
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x0F000000),
                                    blurRadius: 0,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  )
                                ],
                                color: whitecolor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 16.0,
                                left: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getTextWidget(
                                      title: allProduct[index].name!,
                                      textFontSize: fontSize15,
                                      textFontWeight: fontWeightSemiBold,
                                      textColor: background),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getTextWidget(
                                            title: '\$'
                                                '${allProduct[index].price!}',
                                            textFontSize: fontSize15,
                                            textColor: orangecolor),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                icStar,
                                                height: 15,
                                                width: 15,
                                              ),
                                              getTextWidget(
                                                  title: formattedAvgRating,
                                                  textFontSize: fontSize13,
                                                  textFontWeight:
                                                      fontWeightMedium,
                                                  textColor: background)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    // child: ListView.builder(
                    //   scrollDirection: Axis.horizontal,
                    //   itemCount: allProduct.length,
                    //   itemBuilder: (context, index) {

                    //   },
                    // ),
                  ),
                ),
    );
  }
}
