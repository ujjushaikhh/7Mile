import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/constant/font_constant.dart';
import 'package:customerflow/ui/Search%20Screen/model/searc_history.dart';
import 'package:customerflow/ui/Search%20Screen/model/search_add.dart';
import 'package:customerflow/ui/Search%20Screen/model/search_product.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:customerflow/utils/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/textfeild.dart';

class MySearchScreen extends StatefulWidget {
  const MySearchScreen({super.key});

  @override
  State<MySearchScreen> createState() => _MySearchScreenState();
}

// class Debouncer {
//   int? milliseconds;
//   VoidCallback? action;
//   Timer? timer;

//   run(VoidCallback action) {
//     if (null != timer) {
//       timer!.cancel();
//     }
//     timer = Timer(
//       const Duration(milliseconds: Duration.millisecondsPerSecond),
//       action,
//     );
//   }
// }

class _MySearchScreenState extends State<MySearchScreen> {
  @override
  void initState() {
    super.initState();
    getHistoryapi(showProgress: false);
  }

  int? productId;
  List<Products> productList = [];
  List<Products> productName = [];

  Future<dynamic> searchProductapi(String? productname) async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(searchProducturl));

        request.body = json.encode({'name': productname, "price": ''});
        debugPrint(request.body);

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var searchProduct = SearchModel.fromJson(jsonResponse);
        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (searchProduct.status == 1) {
            debugPrint('Product Found');
            productList = searchProduct.products!;
            for (var pId in productList) {
              setState(() {
                productId = pId.id!;
              });
            }
            debugPrint('Product Id :- $productId');
            searchProductAddapi();
          } else {
            debugPrint('Product Not Found');
            ProgressDialogUtils.dismissProgressDialog();
            if (!mounted) return;
            vapeAlertDialogue(
                context: context,
                type: AlertType.info,
                desc: 'Product not Available',
                onPressed: () {
                  Navigator.pop(context);
                }).show();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: '${searchProduct.message}',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              type: AlertType.info,
              desc: "${searchProduct.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              // type: AlertType.info,
              desc: "${searchProduct.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${searchProduct.message}",
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

  Future<dynamic> searchProductAddapi() async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        // ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(searchProductAddurl));

        request.body = json.encode({'product_id': productId});
        debugPrint(request.body);

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var searchProductAdd = SearchAddModel.fromJson(jsonResponse);
        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          // ProgressDialogUtils.dismissProgressDialog();
          if (searchProductAdd.status == 1) {
            debugPrint('Product Stored Successfully');
            // getHistoryapi(showProgress: false);
          } else {
            debugPrint('Product Not Found');
            // ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 400) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: '${searchProductAdd.message}',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              type: AlertType.info,
              desc: "${searchProductAdd.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${searchProductAdd.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${searchProductAdd.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        }
      } catch (e) {
        // ProgressDialogUtils.dismissProgressDialog();
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

  Future<void> getHistoryapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = searchHistory;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getHistory = GetSearchHistoryModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getHistory.status == 1) {
            setState(() {
              yourDataList = getHistory.search!;
            });
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
            desc: '${getHistory.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getHistory.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getHistory.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getHistory.message}',
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

  final _searchController = TextEditingController();

  List<SearchHistory> yourDataList = [];
  final List bestseller = [
    {
      'image': icRecommend,
      'arrivalname': 'Disposable device',
      'productPrice': '\$ 128',
      'rating': '3.2',
      'isLiked': 'false'
    },
    {
      'image': icBestSeller2,
      'arrivalname': 'Disposable device',
      'productPrice': '\$ 128',
      'rating': '3.2',
      'isLiked': 'false'
    },
    {
      'image': icBestSeller1,
      'arrivalname': 'Disposable device',
      'productPrice': '\$ 128',
      'rating': '3.2',
      'isLiked': 'false'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whitecolor,
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: background,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 12.0),
                child: TextFormDriver(
                  hintText: 'Search',
                  fillColor: whitecolor,
                  suffixIcon:
                      _searchController.text.isNotEmpty ? icClose : null,
                  suffixiconcolor: background,
                  controller: _searchController,
                  hintColor: dropdownhint,
                  // autoFocus: true,
                  onfeildSubmitted: (value) {
                    searchProductapi(_searchController.text.toString());
                  },
                  textstyle: background,
                  prefixIcon: icSearch,
                  prefixiconcolor: background,
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, left: 16, bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getTextWidget(
                        title: 'Recent Searches',
                        textFontSize: fontSize20,
                        textColor: background,
                        textFontWeight: fontWeightMedium),
                    yourDataList.isEmpty ? Container() : getWrapWidget(),
                    // getRecentSearch(),

                    Visibility(
                        visible: productList.isNotEmpty,
                        child: getSearchedProduct()),

                    getBestSellers()
                  ],
                ),
              ),
            )),
          ],
        ));
  }

  getWrapWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30.0,
      ),
      child: Wrap(
        // spacing: 10,
        children: [
          ...yourDataList.map((title) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 11.0,
                right: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  searchProductapi(title.productName!.toString());
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border:
                        Border.all(width: 1, color: const Color(0xFFD6D6D6)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 7.0, horizontal: 15.0),
                    child: getTextWidget(
                      title: title.productName!,
                      textColor: background,
                      textFontWeight: fontWeightRegular,
                    ),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  getRecentSearch() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(width: 1, color: const Color(0xFFD6D6D6)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 7.0, bottom: 7.0, left: 15.0, right: 15.0),
        child: getTextWidget(
            title: 'Fusce varius',
            textColor: background,
            textFontWeight: fontWeightRegular),
      ),
    );
  }

  getSearchedProduct() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTextWidget(
              title: 'Products',
              textFontSize: fontSize20,
              textFontWeight: fontWeightSemiBold,
              textColor: background),
          Padding(
            padding: const EdgeInsets.only(left: 1.0, top: 10.0),
            child: SizedBox(
              height: 244,
              child: productList.isEmpty
                  ? getTextWidget(
                      title: 'No Products are there ',
                      textFontSize: fontSize14,
                      textColor: background,
                      textFontWeight: fontWeightRegular,
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(children: [
                                SizedBox(
                                  height: 150,
                                  width: 273,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(6.0),
                                        topRight: Radius.circular(6.0)),
                                    child: CachedNetworkImage(
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 150,
                                        width: 273,
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
                                          height: 150,
                                          width: 273,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.rectangle),
                                        ),
                                      ),
                                      imageUrl: productList[index]
                                          .productImage
                                          .toString(),
                                      height: 150,
                                      width: 273,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 7.0,
                                    top: 7.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        // if (bestseller[index].isLiked == false) {
                                        //   setState(() {
                                        //     favouriteapi(bestseller[index].id!, 1);
                                        //   });
                                        // } else {
                                        //   setState(() {
                                        //     favouriteapi(bestseller[index].id!, 0);
                                        //   });
                                        // }
                                      },
                                      child: Image.asset(
                                        // productList[index].isLiked == true
                                        //     ? icRedHeart
                                        // :
                                        icWhiteHeart,
                                        height: 36,
                                        width: 36,
                                      ),
                                    ))
                              ]),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Container(
                                  width: 273,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0xFFE1E1E1)),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x0F000000),
                                          blurRadius: 0,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        )
                                      ],
                                      color: whitecolor,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 16.0,
                                      left: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            getTextWidget(
                                                title: productList[index]
                                                    .name!
                                                    .toString(),
                                                textFontSize: fontSize15,
                                                textFontWeight:
                                                    fontWeightSemiBold,
                                                textColor: background),
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
                                                      title: '3.50',
                                                      textFontSize: fontSize13,
                                                      textFontWeight:
                                                          fontWeightMedium,
                                                      textColor: background)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: getTextWidget(
                                              title:
                                                  '\$ ${productList[index].price!.toString()}',
                                              textFontSize: fontSize15,
                                              textColor: orangecolor),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }

  getBestSellers() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                    title: 'Recommended',
                    textFontSize: fontSize20,
                    textFontWeight: fontWeightSemiBold,
                    textColor: background),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const MyBestSellers()));
                    },
                    child: getTextWidget(
                        title: 'See All',
                        textFontWeight: fontWeightSemiBold,
                        textColor: orangecolor),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 1.0, top: 10.0),
            child: SizedBox(
              height: 244,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bestseller.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          Container(
                            height: 150,
                            width: 273,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                                image: DecorationImage(
                                    image:
                                        AssetImage(bestseller[index]['image']),
                                    fit: BoxFit.cover)),
                          ),
                          Positioned(
                              right: 7.0,
                              top: 7.0,
                              child: GestureDetector(
                                onTap: () {
                                  if (bestseller[index]['isliked'] == 'false') {
                                    setState(() {
                                      bestseller[index]['isliked'] = 'true';
                                    });
                                  } else {
                                    setState(() {
                                      bestseller[index]['isliked'] = 'false';
                                    });
                                  }
                                },
                                child: Image.asset(
                                  bestseller[index]['isliked'] == 'true'
                                      ? icRedHeart
                                      : icWhiteHeart,
                                  height: 36,
                                  width: 36,
                                ),
                              ))
                        ]),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            width: 273,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: const Color(0xFFE1E1E1)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0F000000),
                                    blurRadius: 0,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  )
                                ],
                                color: whitecolor,
                                borderRadius: const BorderRadius.only(
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      getTextWidget(
                                          title: bestseller[index]
                                              ['arrivalname'],
                                          textFontSize: fontSize15,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor: background),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              icStar,
                                              height: 15,
                                              width: 15,
                                            ),
                                            getTextWidget(
                                                title: bestseller[index]
                                                    ['rating'],
                                                textFontSize: fontSize13,
                                                textFontWeight:
                                                    fontWeightMedium,
                                                textColor: background)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: getTextWidget(
                                        title: bestseller[index]
                                            ['productPrice'],
                                        textFontSize: fontSize15,
                                        textColor: orangecolor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
