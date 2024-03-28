import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/ui/Categories/Model/getcategorymodel.dart';
import 'package:customerflow/ui/Product%20Details/product_details.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

import 'package:http/http.dart' as http;
import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/textwidget.dart';

class MyCategories extends StatefulWidget {
  const MyCategories({
    super.key,
  });
  // final List<Data>? categorylist;
  // final int? productid;

  @override
  State<MyCategories> createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  @override
  void initState() {
    super.initState();
    getCategoryapi();
  }

  List<bool> isExpanded = [];

  var token = getString('token');
  // List<Product> item = [];
  List<Data> allCategories = [];

  Future<void> getCategoryapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = getCategoryurl;
        debugPrint(apiurl);
        var headers = {
          // 'Authorization': 'Bearer' '$token',
          'Content-Type': 'application/json',
        };

        debugPrint(token);

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getCategory = GetCategoryModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getCategory.status == 1) {
            setState(() {
              allCategories = getCategory.data!;
              // for (var product in getCategory.data!) {
              //   item.addAll(product.product!);
              // }
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getCategory.message}',
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
            desc: '${getCategory.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getCategory.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getCategory.message}',
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
                title: 'Categories',
                textColor: whitecolor,
                textFontWeight: fontWeightMedium,
                textFontSize: fontSize15),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              // item = allCategories[index].product ?? [];
              if (isExpanded.length <= index) {
                isExpanded.add(false);
              }
              return Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          isExpanded[index] = !isExpanded[index];
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipOval(
                              child: CachedNetworkImage(
                            imageBuilder: (context, imageProvider) => Container(
                              height: 78.0,
                              width: 78.0,
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
                            imageUrl: allCategories[index].catImage.toString(),
                            height: 78.0,
                            width: 78.0,
                            fit: BoxFit.cover,
                          )),
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: Column(
                              children: [
                                getTextWidget(
                                  title:
                                      allCategories[index].catName!.toString(),
                                  textFontSize: fontSize20,
                                  textFontWeight: fontWeightRegular,
                                  textColor: isExpanded[index] == true
                                      ? orangecolor
                                      : background,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                            isExpanded[index] != true
                                ? icRightArrow
                                : icArrowDown,
                            height: 24,
                            width: 24,
                            fit: BoxFit.cover,
                            color: isExpanded[index] != true
                                ? background
                                : orangecolor,
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded[index] == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 92.0),
                        child: allCategories[index].product!.isNotEmpty
                            ? ListView.builder(
                                itemCount: allCategories[index].product!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, innerindex) {
                                  return Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 14.0),
                                        child: Divider(
                                          color: dividercolor,
                                          thickness: 1.0,
                                          height: 2.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, left: 1.0),
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyProductDetailScreen(
                                                        productid:
                                                            allCategories[index]
                                                                .product![
                                                                    innerindex]
                                                                .productId,
                                                      )),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              getTextWidget(
                                                title: allCategories[index]
                                                    .product![innerindex]
                                                    .productName!
                                                    .toString(),
                                                textFontSize: fontSize16,
                                                textFontWeight:
                                                    fontWeightRegular,
                                                textColor: background,
                                              ),
                                              const Spacer(),
                                              Image.asset(
                                                icRightArrow,
                                                height: 24.0,
                                                width: 24.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            : getTextWidget(
                                title: 'No item in this Category',
                                textFontSize: fontSize16,
                                textColor: background,
                                textFontWeight: fontWeightRegular),
                      ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 14.0,
                      ),
                      child: Divider(
                        color: dividercolor,
                        thickness: 1.0,
                        height: 2.0,
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
