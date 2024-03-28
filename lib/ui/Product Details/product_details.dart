import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/constant/image_constant.dart';
import 'package:customerflow/ui/Cart/Model/addtocartmodel.dart';
import 'package:customerflow/ui/Home/model/fav_model.dart';
import 'package:customerflow/ui/Product%20Details/model/productdetailmodel.dart';
import 'package:customerflow/utils/button.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/textwidget.dart';

class MyProductDetailScreen extends StatefulWidget {
  const MyProductDetailScreen({super.key, this.productid});
  final int? productid;

  @override
  State<MyProductDetailScreen> createState() => _MyProductDetailScreenState();
}

class _MyProductDetailScreenState extends State<MyProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getproductdetailapi();
    });
  }

  var token = getString('token');
  int selectedIndex = 0;
  int maxLinesToShow = 3;
  bool showFullDescription = false;
  String? productName = '';
  String? productPrice = '';
  int productId = 0;
  String? minidescription = '';
  String? description2 = '';
  // DateTime? date;
  String? dateformat = '';
  String? rating = '';
  String? avgrating;
  bool? isLiked;
  bool isLoaded = false;

  // List<ProductImages> customer = [];
  // List<Product> products = [];
  // List<Data> category = [];
  // List<Specifications> specification = [];

  List<ProductImages> productimages = [];
  List<ProductSpecifications> productspecification = [];
  List<ProductRatings> productReviews = [];
  Future<dynamic> addtocartapi() async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer' '$token',
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(addtocarturl));

        request.body =
            json.encode({'product_id': widget.productid, "qty": "1"});
        debugPrint(request.body);

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var addtoCart = AddtoCartModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (addtoCart.status == 1) {
            if (!mounted) return;
            vapeAlertDialogue(
                context: context,
                type: AlertType.success,
                desc: 'Product added to cart successfully',
                onPressed: () {
                  Navigator.pop(context);
                }).show();
          } else {
            debugPrint('failed to login');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
              context: context,
              desc: '${addtoCart.message}',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${addtoCart.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${addtoCart.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          vapeAlertDialogue(
              context: context,
              desc: "${addtoCart.message}",
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

  Future<void> getproductdetailapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }

      try {
        var apiurl = productdetailurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        debugPrint(token);

        var request = http.Request('POST', Uri.parse(apiurl));
        request.body = json.encode({"product_id": widget.productid});
        debugPrint(request.body);

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getProductdetail = GetProductDetailModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getProductdetail.status == 1) {
            setState(() {
              productimages = getProductdetail.productsData!.productImages!;
              productspecification =
                  getProductdetail.productsData!.productSpecifications ?? [];
              productId = getProductdetail.productsData!.id!;
              productName = getProductdetail.productsData!.name!.toString();
              productPrice = getProductdetail.productsData!.price!.toString();
              minidescription =
                  getProductdetail.productsData!.miniDescription!.toString();
              avgrating = getProductdetail.productsData!.averageRate ?? '';
              description2 =
                  getProductdetail.productsData!.description!.toString();
              productReviews =
                  getProductdetail.productsData!.productRatings ?? [];
              isLiked = getProductdetail.productsData!.isLiked ?? false;
              for (var datetime in productReviews) {
                DateTime date = DateTime.parse(datetime.createdAt!).toLocal();
                rating = datetime.rate.toString();
                dateformat = DateFormat("dd MMM yyyy").format(date);
              }

              debugPrint('Date Format :-$dateformat');
              // category = getProductdetail.data!;
              isLoaded = true;
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
            desc: '${getProductdetail.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getProductdetail.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getProductdetail.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          debugPrint('${response.statusCode}');
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${getProductdetail.message}',
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

  Future<dynamic> favouriteapi(int isliked) async {
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
            json.encode({'product_id': productId, 'is_like': isliked});
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
            getproductdetailapi(showProgress: false);
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
      appBar: AppBar(
        backgroundColor: background,
        centerTitle: true,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: getTextWidget(
              title: 'Product Detail',
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isLiked == false) {
                    favouriteapi(1);
                  } else {
                    favouriteapi(0);
                  }
                });
              },
              child: Image.asset(
                isLiked == false ? icHeart : icRedHeartLiked,
                color: isLiked == false ? whitecolor : Colors.red,
                height: 24.0,
                width: 24.0,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: isLoaded == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getImage(),
                        getName(),
                        getPrice(),
                        getDescription(),
                        // getKnowMore()
                      ],
                    ),
                  ),
                  getContainer(),
                  selectedIndex == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getProductDescription(),
                            getProductDescritption2(),
                            getSpecification(),
                          ],
                        )
                      : getReviews(),
                  // getButton()
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.transparent,
                ),
              ),
      ),
      bottomNavigationBar: getButton(),
    );
  }

  Widget getButton() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 25.0, left: 16, right: 16.0, bottom: 16),
      child: CustomizeButton(
          text: 'Add to Cart',
          onPressed: () {
            addtocartapi();
          }),
    );
  }

  Widget getReviews() {
    return productReviews.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(
              child: getTextWidget(
                  title: 'No Product Reviews',
                  textFontSize: fontSize16,
                  textColor: background,
                  textFontWeight: fontWeightSemiBold),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
                child: ListView.builder(
                  itemCount: productReviews.length,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 51.0,
                                    width: 51.0,
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
                                      height: 51.0,
                                      width: 51.0,
                                      decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                  imageUrl: productReviews[index]
                                      .userImage
                                      .toString(),
                                  height: 51.0,
                                  width: 51.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 13.0, top: 3),
                                child: Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getTextWidget(
                                          title: productReviews[index]
                                              .userName!
                                              .toString(),
                                          textFontSize: fontSize15,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor: background),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: getTextWidget(
                                            title: dateformat!.toString(),
                                            textFontSize: fontSize13,
                                            textFontWeight: fontWeightRegular,
                                            textColor: const Color(0xFF747982)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 9.0,
                                        ),
                                        child: getTextWidget(
                                            textFontSize: fontSize14,
                                            textFontWeight: fontWeightRegular,
                                            textColor: background,
                                            maxLines: 2,
                                            title: productReviews[index]
                                                .review!
                                                .toString()),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: RatingBar.builder(
                                  initialRating: double.parse(rating!),
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  ignoreGestures: true,
                                  itemCount: 5,
                                  itemSize: 15,
                                  itemBuilder: (context, index) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.amberAccent,
                                    );
                                  },
                                  unratedColor: const Color(0xffC7C3B9),
                                  onRatingUpdate: (double value) {},
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 17.0),
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
              ),
              productReviews.length > 7
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                        left: 16.0,
                      ),
                      child: getTextWidget(
                          title: 'See All Reviews',
                          textColor: orangecolor,
                          textFontWeight: fontWeightSemiBold,
                          fontfamily: fontfamilyBevietnam,
                          textFontSize: fontSize14),
                    )
                  : Container(),
            ],
          );
  }

  Widget getSpecification() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF4F2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 16, bottom: 12.0),
              child: getTextWidget(
                  title: 'Specification',
                  textFontSize: fontSize20,
                  textFontWeight: fontWeightSemiBold,
                  textColor: background),
            ),
            ListView.builder(
              itemCount: productspecification.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const Divider(
                      color: Color(0xFFEADDDD),
                      height: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 9.0,
                        left: 16,
                        bottom: 10.0,
                      ),
                      child: Row(
                        children: [
                          getTextWidget(
                              title:
                                  productspecification[index].title.toString(),
                              textFontSize: fontSize14,
                              textFontWeight: fontWeightSemiBold,
                              textColor: background),
                          Expanded(
                              child: Align(
                            alignment: Alignment.center,
                            child: getTextWidget(
                                title: productspecification[index]
                                    .subTitle!
                                    .toString(),
                                textFontSize: fontSize14,
                                textFontWeight: fontWeightRegular,
                                textColor: background),
                          )),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getProductDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0, left: 16.0, right: 26.0),
      child: getTextWidget(
          title: minidescription.toString(),
          height: 2.0,
          textFontSize: fontSize14,
          textFontWeight: fontWeightRegular,
          textColor: background),
    );
  }

  Widget getProductDescritption2() {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0, left: 16.0, right: 26.0),
      child: getTextWidget(
          title: description2.toString(),
          textFontSize: fontSize14,
          height: 2.0,
          textFontWeight: fontWeightRegular,
          textColor: background),
    );
  }

  Widget getContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        // height: 52,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Color(0xFFFBEBE7)),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: selectedIndex == 0
                                  ? orangecolor
                                  : Colors.transparent,
                              width: 3.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                        child: getTextWidget(
                            title: 'Description',
                            textColor:
                                selectedIndex == 0 ? orangecolor : background,
                            textFontSize: fontSize15,
                            textFontWeight: fontWeightMedium)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: selectedIndex == 1
                                  ? orangecolor
                                  : Colors.transparent,
                              width: 3.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                        child: getTextWidget(
                            title: 'Reviews',
                            textColor:
                                selectedIndex == 1 ? orangecolor : background,
                            textFontSize: fontSize15,
                            textFontWeight: fontWeightMedium)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTextWidget(
              textFontSize: fontSize14,
              textFontWeight: fontWeightRegular,
              maxLines: showFullDescription ? null : maxLinesToShow,
              textColor: const Color(0xFF747981),
              title: minidescription.toString()),
          minidescription!.length > maxLinesToShow ? getKnowMore() : Container()
        ],
      ),
    );
  }

  Widget getKnowMore() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            showFullDescription = !showFullDescription;
          });
        },
        child: Row(
          children: [
            getTextWidget(
              title: showFullDescription ? 'Know Less' : 'Know More',
              textFontSize: fontSize14,
              textFontWeight: fontWeightSemiBold,
              textColor: orangecolor,
            ),
            Image.asset(
              showFullDescription ? icArrowup : icArrowDown,
              color: orangecolor,
              height: 24,
              width: 24.0,
            )
          ],
        ),
      ),
    );
  }

  Widget getPrice() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: getTextWidget(
          title: ' \$ $productPrice',
          textFontSize: fontSize18,
          textFontWeight: fontWeightSemiBold,
          textColor: orangecolor),
    );
  }

  Widget getName() {
    double avgRating = double.tryParse(avgrating!) ?? 0.0;
    String formattedAvgRating = avgRating.toStringAsFixed(2);

    debugPrint(formattedAvgRating);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getTextWidget(
              title: productName.toString(),
              textFontSize: fontSize18,
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
                    title: formattedAvgRating,
                    textFontSize: fontSize13,
                    textFontWeight: fontWeightMedium,
                    textColor: background)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getImage() {
    return SizedBox(
      height: 161,
      width: MediaQuery.of(context).size.width - 40,
      child: ListView.builder(
        itemCount: productimages.length,
        // shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 7.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                    height: 161,
                    width: MediaQuery.of(context).size.width - 40,
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
                      height: 161,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: const BoxDecoration(
                          color: Colors.grey, shape: BoxShape.rectangle),
                    ),
                  ),
                  imageUrl: productimages[index].image.toString(),
                  height: 161,
                  width: MediaQuery.of(context).size.width - 40,
                  fit: BoxFit.cover,
                )),
          );
        },
      ),
    );
  }
}
