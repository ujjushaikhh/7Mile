import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/constant/color_constant.dart';
import 'package:customerflow/constant/font_constant.dart';
import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/ui/All%20products/all_product.dart';
import 'package:customerflow/ui/Best%20Sellers/best_seller.dart';
import 'package:customerflow/ui/BottomTab/bottom_tab.dart';
import 'package:customerflow/ui/Categories/categories.dart';
import 'package:customerflow/ui/Home/model/fav_model.dart';
import 'package:customerflow/ui/Home/model/home_model.dart';
import 'package:customerflow/ui/Product%20Details/product_details.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:customerflow/utils/textfeild.dart';
import 'package:customerflow/utils/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import '../../constant/api_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var token = getString('token');
  // int? notifyCount = 0;

  @override
  void initState() {
    super.initState();
    getHomeapi();
    // getNotifycountapi();
  }

  List<Data> home = [];

  // Future<void> getNotifycountapi() async {
  //   if (await checkUserConnection()) {
  //     try {
  //       var apiurl = getnotificationcounturl;
  //       debugPrint(apiurl);
  //       var headers = {
  //         'authkey': 'Bearer ${getString('token')}',
  //         'Content-Type': 'application/json',
  //       };

  //       debugPrint(token);

  //       var request = http.Request('GET', Uri.parse(apiurl));

  //       request.headers.addAll(headers);

  //       http.StreamedResponse response = await request.send();
  //       final responsed = await http.Response.fromStream(response);
  //       var jsonResponse = jsonDecode(responsed.body);
  //       var getNotifyCount = NotifyCountModel.fromJson(jsonResponse);

  //       if (response.statusCode == 200) {
  //         debugPrint(responsed.body);
  //         // ProgressDialogUtils.dismissProgressDialog();
  //         if (getNotifyCount.status == 1) {
  //           setState(() {
  //             notifyCount = getNotifyCount.count ?? 0;
  //           });
  //           debugPrint('is it success');
  //         } else {
  //           debugPrint('failed to load');
  //         }
  //       } else if (response.statusCode == 401) {
  //         // ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getNotifyCount.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 404) {
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getNotifyCount.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 400) {
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getNotifyCount.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 500) {
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getNotifyCount.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       }
  //     } catch (e) {
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

  Future<dynamic> favouriteapi(int productId, int isLiked) async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        // ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(favouriteurl));

        request.body =
            json.encode({'product_id': productId, 'is_like': isLiked});
        debugPrint(request.body);

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var favouriteModel = FavouriteModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          // ProgressDialogUtils.dismissProgressDialog();
          if (favouriteModel.status == 1) {
            getHomeapi(showProgress: false);
            debugPrint(favouriteModel.message);
          } else {
            debugPrint('failed to login');
            debugPrint(favouriteModel.message);
            // ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 400) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: '${favouriteModel.message}',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${favouriteModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${favouriteModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${favouriteModel.message}",
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

  Future<void> getHomeapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = getHomeurl;
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
        var getHome = HomeModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getHome.status == 1) {
            setState(() {
              advertisement = getHome.data!.deal!;
              categorylist = getHome.data!.category!;
              bestseller = getHome.data!.bestSeller!;
              newarrival = getHome.data!.newArivals!;
              hottrending = getHome.data!.hotTrending!;
              // categorylist = getHome.data!;
              // for (var product in categorylist) {
              //   products = product.product!;
              // }
              // for (var productid in products) {
              //   productId = productid.productId!;
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
            desc: '${getHome.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getHome.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getHome.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getHome.message}',
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
  List<Deal> advertisement = [];

  List<Category> categorylist = [];

  List<HotTrending> hottrending = [];

  List<BestSeller> bestseller = [];

  List<NewArivals> newarrival = [];

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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyPrimaryBottomTab(
                                  from: 'search',
                                )));
                  },
                  child: TextFormDriver(
                    hintText: 'Search',
                    fillColor: whitecolor,
                    controller: _searchController,
                    hintColor: dropdownhint,
                    enable: false,
                    textstyle: background,
                    prefixIcon: icSearch,
                    prefixiconcolor: background,
                  ),
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getAdvertisement(),
                    getCategories(),
                    getNewArrivals(),
                    getBestSellers(),
                    getHotTrending()
                  ],
                ),
              ),
            )),
          ],
        ));
  }

  getNewArrivals() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                    title: 'New Arrivals',
                    textFontSize: fontSize20,
                    textFontWeight: fontWeightSemiBold,
                    textColor: background),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyAllProducts()));
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
            padding: const EdgeInsets.only(
              left: 1.0,
              top: 10.0,
            ),
            child: SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newarrival.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        debugPrint(' id :${newarrival[index].id!}');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProductDetailScreen(
                                      productid: newarrival[index].id,
                                    )));
                      },
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
                                  imageUrl: newarrival[index].image.toString(),
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
                                    if (newarrival[index].isLiked == false) {
                                      setState(() {
                                        favouriteapi(newarrival[index].id!, 1);
                                      });
                                    } else {
                                      setState(() {
                                        favouriteapi(newarrival[index].id!, 0);
                                      });
                                    }
                                  },
                                  child: Image.asset(
                                    newarrival[index].isLiked == true
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
                                            title: newarrival[index]
                                                .name!
                                                .toString(),
                                            textFontSize: fontSize15,
                                            textFontWeight: fontWeightSemiBold,
                                            textColor: background),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: Row(
                                            children: [
                                              newarrival[index].avgRating == ''
                                                  ? Container()
                                                  : Image.asset(
                                                      icStar,
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                              getTextWidget(
                                                  title: newarrival[index]
                                                      .avgRating!
                                                      .toString(),
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
                                          title:
                                              '\$ ${newarrival[index].price!.toString()}',
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
                    title: 'Best Seller',
                    textFontSize: fontSize20,
                    textFontWeight: fontWeightSemiBold,
                    textColor: background),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyBestSellers()))
                          .whenComplete(() => getHomeapi(showProgress: false));
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
                                imageUrl: bestseller[index].image.toString(),
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
                                  if (bestseller[index].isLiked == false) {
                                    setState(() {
                                      favouriteapi(bestseller[index].id!, 1);
                                    });
                                  } else {
                                    setState(() {
                                      favouriteapi(bestseller[index].id!, 0);
                                    });
                                  }
                                },
                                child: Image.asset(
                                  bestseller[index].isLiked == true
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
                                              .name!
                                              .toString(),
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
                                                    .avgRating!
                                                    .toString(),
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
                                        title:
                                            '\$ ${bestseller[index].price!.toString()}',
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

  getHotTrending() {
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
                    title: 'Hot Trending',
                    textFontSize: fontSize20,
                    textFontWeight: fontWeightSemiBold,
                    textColor: background),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: getTextWidget(
                      title: 'See All',
                      textFontWeight: fontWeightSemiBold,
                      textColor: orangecolor),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 1.0, top: 10.0),
            child: SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hottrending.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 130,
                          width: MediaQuery.of(context).size.width / 2.8,
                          // width: 136,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6.0),
                                topRight: Radius.circular(6.0)),
                            child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 130,
                                width: MediaQuery.of(context).size.width / 2.8,
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
                                  height: 130,
                                  width:
                                      MediaQuery.of(context).size.width / 2.8,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              imageUrl: hottrending[index].image.toString(),
                              height: 130,
                              width: MediaQuery.of(context).size.width / 2.8,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.8,
                            decoration: const BoxDecoration(
                              color: whitecolor,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 0,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6)),
                            ),
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
                                      title:
                                          hottrending[index].name!.toString(),
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
                                            title:
                                                '\$ ${hottrending[index].price!.toString()}',
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
                                                  title: hottrending[index]
                                                      .avgRating!,
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

  getCategories() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 13.0,
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                    title: 'Categories',
                    textFontSize: fontSize20,
                    textFontWeight: fontWeightSemiBold,
                    textColor: background),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyCategories(
                              // categorylist: categorylist, productid: productId
                              ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
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
            padding: const EdgeInsets.only(
              top: 11.0,
            ),
            child: SizedBox(
              height: 105,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categorylist.length,
                // shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 11.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
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
                                height: 78.0,
                                width: 78.0,
                                decoration: const BoxDecoration(
                                    color: Colors.grey, shape: BoxShape.circle),
                              ),
                            ),
                            imageUrl: categorylist[index].image.toString(),
                            height: 78.0,
                            width: 78.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: getTextWidget(
                              title: categorylist[index].name!.toString(),
                              textFontSize: fontSize13,
                              textFontWeight: fontWeightRegular,
                              textColor: background),
                        )
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

  getAdvertisement() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 1.0,
      ),
      child: SizedBox(
        height: 117,
        child: ListView.builder(
          itemCount: advertisement.length,
          // shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 7.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                    height: 117.0,
                    width: MediaQuery.of(context).size.width / 1.4,
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
                      height: 117.0,
                      width: MediaQuery.of(context).size.width / 1.4,
                      decoration: const BoxDecoration(
                          color: Colors.grey, shape: BoxShape.rectangle),
                    ),
                  ),
                  imageUrl: advertisement[index].image.toString(),
                  height: 117.0,
                  width: MediaQuery.of(context).size.width / 1.4,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
