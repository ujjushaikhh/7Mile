import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/ui/Favourites/model/favoritemodel.dart';
import 'package:customerflow/utils/dailog.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/textwidget.dart';
import '../Home/model/fav_model.dart';
import '../Product Details/product_details.dart';

class MyFavourites extends StatefulWidget {
  const MyFavourites({super.key});

  @override
  State<MyFavourites> createState() => _MyFavouritesState();
}

class _MyFavouritesState extends State<MyFavourites> {
  @override
  void initState() {
    super.initState();
    getfavouriteproductapi();
  }

  List<Products> favouriteproducts = [];
  bool isload = true;

  Future<void> getfavouriteproductapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      if (showProgress) {
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = getfavoriteurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };

        // debugPrint(token);

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getfavouriteproduct = GetFavoriteModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getfavouriteproduct.status == 1) {
            setState(() {
              favouriteproducts = getfavouriteproduct.products!;
              isload = false;
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
            desc: '${getfavouriteproduct.message}',
            onPressed: () {
              Navigator.pop(context);
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
            desc: '${getfavouriteproduct.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getfavouriteproduct.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getfavouriteproduct.message}',
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
            getfavouriteproductapi(showProgress: false);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: background,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: getTextWidget(
            title: 'Favourite Products',
            textFontSize: fontSize15,
            textFontWeight: fontWeightSemiBold,
            textColor: whitecolor,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
                color: whitecolor,
              )),
        ),
      ),
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : favouriteproducts.isEmpty
              ? Center(
                  child: getTextWidget(
                    title: 'No Favourite products',
                    textFontSize: fontSize20,
                    textColor: background,
                    textFontWeight: fontWeightSemiBold,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16, top: 15, bottom: 16.0),
                  child: GridView.builder(
                    itemCount: favouriteproducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 239,
                      // mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      String avgRatingString =
                          favouriteproducts[index].product!.avgRate!;
                      double avgRating =
                          double.tryParse(avgRatingString) ?? 0.0;
                      String formattedAvgRating = avgRating.toStringAsFixed(2);

                      debugPrint(formattedAvgRating);
                      return Column(
                        // crossAxisAlignment: CrossAxis
                        // Alignment.start,
                        children: [
                          Stack(children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyProductDetailScreen(
                                              productid:
                                                  favouriteproducts[index]
                                                      .product!
                                                      .id,
                                            ))).whenComplete(() {
                                  setState(() {
                                    getfavouriteproductapi(showProgress: false);
                                  });
                                });
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
                                        // shape: BoxShape.circle
                                      ),
                                    ),
                                  ),
                                  imageUrl: favouriteproducts[index]
                                      .product!
                                      .image
                                      .toString(),
                                  height: 130.0,
                                  // width: 78.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                                right: 7.0,
                                top: 7.0,
                                child: GestureDetector(
                                  onTap: () {
                                    if (favouriteproducts[index].isLike == 0) {
                                      setState(() {
                                        favouriteapi(
                                            favouriteproducts[index]
                                                .product!
                                                .id!,
                                            1);
                                      });
                                    } else {
                                      setState(() {
                                        favouriteapi(
                                            favouriteproducts[index]
                                                .product!
                                                .id!,
                                            0);
                                      });
                                    }
                                  },
                                  child: Image.asset(
                                    favouriteproducts[index].isLike == 1
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
                                        title: favouriteproducts[index]
                                            .product!
                                            .name!,
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
                                                  '${favouriteproducts[index].product!.price}',
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
                          ),
                        ],
                      );
                    },
                    // child: ListView.builder(
                    //   scrollDirection: Axis.horizontal,
                    //   itemCount: favouriteproduct.length,
                    //   itemBuilder: (context, index) {

                    //   },
                    // ),
                  ),
                ),
    );
  }
}
