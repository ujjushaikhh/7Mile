import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/ui/Best%20Sellers/model/best_sellermodel.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

import 'package:http/http.dart' as http;
import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';
import '../Home/model/fav_model.dart';

class MyBestSellers extends StatefulWidget {
  const MyBestSellers({
    super.key,
  });

  @override
  State<MyBestSellers> createState() => _MyBestSellersState();
}

class _MyBestSellersState extends State<MyBestSellers> {
  List<BestSeller> bestSeller = [];

  Future<void> geBestSellers({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = getHomeurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };

        debugPrint('Token ${getString('token')}');

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getHome = BestSellers.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();

          setState(() {
            bestSeller = getHome.data!.bestSeller!;

            // categorylist = getHome.data!;
            // for (var product in categorylist) {
            //   products = product.product!;
            // }
            // for (var productid in products) {
            //   productId = productid.productId!;
            // }
          });
          debugPrint('is it success');
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

  Future<dynamic> favouriteapi(int productId, int isLiked) async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        // ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
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
            // getHomeapi(showProgress: false);
            geBestSellers(showProgress: false);
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

  @override
  void initState() {
    super.initState();
    geBestSellers();
  }

  // final List newarrival = [
  // {
  //   'image': icBestSeller3,
  //   'arrivalname': 'Disposable device',
  //   'productPrice': '\$ 128',
  //   'rating': '3.2',
  //   'isLiked': 'false'
  // },
  // {
  //   'image': icBestSeller2,
  //   'arrivalname': 'Disposable device',
  //   'productPrice': '\$ 128',
  //   'rating': '3.2',
  //   'isLiked': 'false'
  // },
  // {
  //   'image': icBestSeller1,
  //   'arrivalname': 'Disposable device',
  //   'productPrice': '\$ 128',
  //   'rating': '3.2',
  //   'isLiked': 'false'
  // },
  // {
  //   'image': icArrival2,
  //   'arrivalname': 'Disposable device',
  //   'productPrice': '\$ 128',
  //   'rating': '3.2',
  //   'isLiked': 'false'
  // },
  // ];

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
              title: 'Bestsellers',
              textColor: whitecolor,
              textFontWeight: fontWeightMedium,
              textFontSize: fontSize15),
        ),
        centerTitle: true,
      ),
      body: getNewArrivals(),
    );
  }

  getNewArrivals() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 15.0, left: 16, right: 16, bottom: 15),
      child: ListView.builder(
        // scrollDirection: Axis.vertical,
        itemCount: bestSeller.length,
        itemBuilder: (context, index) {
          return Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(6.0),
                        topLeft: Radius.circular(6.0)),
                    child: CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
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
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.grey, shape: BoxShape.circle),
                        ),
                      ),
                      imageUrl: bestSeller[index].image.toString(),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    right: 7.0,
                    top: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        if (bestSeller[index].isLiked == false) {
                          setState(() {
                            favouriteapi(bestSeller[index].id!, 1);
                            // newarrival[index]['isliked'] = 'true';
                          });
                        } else {
                          setState(() {
                            favouriteapi(bestSeller[index].id!, 0);
                          });
                        }
                      },
                      child: Image.asset(
                        bestSeller[index].isLiked == true
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
                  width: MediaQuery.of(context).size.width,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getTextWidget(
                                title: bestSeller[index].name!.toString(),
                                textFontSize: fontSize15,
                                textFontWeight: fontWeightSemiBold,
                                textColor: background),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    icStar,
                                    height: 15,
                                    width: 15,
                                  ),
                                  getTextWidget(
                                      title: bestSeller[index]
                                          .avgRating!
                                          .toString(),
                                      textFontSize: fontSize13,
                                      textFontWeight: fontWeightMedium,
                                      textColor: background)
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: getTextWidget(
                              title: '\$'
                                  '${bestSeller[index].price!.toString()}',
                              textFontSize: fontSize15,
                              textColor: orangecolor),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
