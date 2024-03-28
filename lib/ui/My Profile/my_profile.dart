import 'package:customerflow/ui/Change%20Password/change_password.dart';
import 'package:customerflow/ui/Favourites/favourite.dart';
import 'package:customerflow/ui/My%20Address/my_address.dart';
import 'package:customerflow/ui/My%20Orders/my_orders.dart';
import 'package:customerflow/ui/My%20Payment/my_payment.dart';
import 'package:customerflow/ui/Terms&Condition/terms_condition.dart';
import 'package:customerflow/ui/login/login.dart';
import 'package:customerflow/utils/dailog.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/textwidget.dart';
import '../Edit Profile/edit_profile.dart';
import '../Setting/settings.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var getUserimg = getString('userimage');
  var getUsername = getString('name');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 17.0),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                        height: 147.0,
                        width: 147.0,
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
                      imageUrl: getUserimg.toString(),
                      height: 147.0,
                      width: 147.0,
                      fit: BoxFit.cover,
                    ),
                  ),

                  //  Container(
                  //   height: 147,
                  //   width: 147,
                  //   decoration: const BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       image: DecorationImage(
                  //           image: AssetImage(icUserimg), fit: BoxFit.cover)),
                  // ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: getTextWidget(
                    title: getUsername.toString(),
                    textAlign: TextAlign.center,
                    textFontSize: fontSize20,
                    textFontWeight: fontWeightSemiBold,
                    textColor: background),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: GridView.builder(
                  itemCount: myprofile.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      mainAxisExtent: 112,
                      crossAxisSpacing: 15),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (myprofile[index]['route'] != null) {
                          if (myprofile[index]['title'] == 'Edit Profile') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => myprofile[index]
                                        ['route'])).whenComplete(() {
                              setState(() {
                                getUserimg = getString('userimage');
                                getUsername = getString('name');
                              });
                            });
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        myprofile[index]['route']));
                          }
                        } else {
                          Fluttertoast.showToast(msg: 'There is no route');
                        }
                      },
                      child: Container(
                        width: 164,
                        // height: 112,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: orangeBorder, width: 1)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const ShapeDecoration(
                                  color: orangeBorder,
                                  shape: OvalBorder(),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      if (myprofile[index]['route'] != null) {
                                        if (myprofile[index]['title'] ==
                                            'Edit Profile') {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          myprofile[index]
                                                              ['route']))
                                              .whenComplete(() {
                                            setState(() {
                                              getUserimg =
                                                  getString('userimage');
                                              getUsername = getString('name');
                                            });
                                          });
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      myprofile[index]
                                                          ['route']));
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'There is no route');
                                      }
                                    },
                                    icon: Image.asset(
                                      myprofile[index]['icon'],
                                      height: 24.0,
                                      width: 24.0,
                                      fit: BoxFit.cover,
                                      color: orangecolor,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: getTextWidget(
                                  title: myprofile[index]['title'],
                                  textFontSize: fontSize13,
                                  textFontWeight: fontWeightRegular,
                                  textColor: background),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  showOkCancelAlertDialog(
                      context: context,
                      message: 'Are you sure you want to logout ',
                      okButtonTitle: 'Ok',
                      isCancelEnable: true,
                      cancelButtonTitle: 'Cancel',
                      okButtonAction: () {
                        // clear();
                        setString('userlogin', '0');
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyLogin()),
                            (route) => false);
                        // setString('userlogin', '0');
                        // setBool('seen', true);
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 147.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        icLogout,
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                        color: orangecolor,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      getTextWidget(
                          title: 'Logout',
                          textFontSize: fontSize13,
                          textFontWeight: fontWeightRegular,
                          textColor: orangecolor)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigateToProfileUpdateScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyEditProfile()),
    );

    // Update the variables with the result from the profile update screen
    if (result != null) {
      setState(() {
        getUsername = result['name'];
        getUserimg = result['userimage'];
      });
    }
  }

  List myprofile = [
    {
      'icon': icEditProfile,
      'title': 'Edit Profile',
      'route': const MyEditProfile()
    },
    {'icon': icWallet, 'title': 'Payment Options', 'route': const MyPayment()},
    {'icon': icDelivery, 'title': 'My Orders', 'route': const MyOrders()},
    {'icon': icLocation, 'title': 'My Address', 'route': const MyAddress()},
    {'icon': icHeart, 'title': 'Favorites', 'route': const MyFavourites()},
    {
      'icon': icPassword,
      'title': 'Change Password',
      'route': const MyChangePassword()
    },
    {'icon': icSetting, 'title': 'Settings', 'route': const MySetting()},
    {
      'icon': icTerms,
      'title': 'Terms & Condition',
      'route': const MyTermsandCondition()
    }
  ];
}
