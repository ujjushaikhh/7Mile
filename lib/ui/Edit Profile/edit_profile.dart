import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerflow/constant/api_constant.dart';
import 'package:customerflow/ui/Edit%20Profile/model/updateprofilemodel.dart';
import 'package:customerflow/utils/sharedprefs.dart';
import 'package:customerflow/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/button.dart';
import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/textfeild.dart';
import '../../utils/textwidget.dart';

class MyEditProfile extends StatefulWidget {
  const MyEditProfile({super.key});

  @override
  State<MyEditProfile> createState() => _MyEditProfileState();
}

class _MyEditProfileState extends State<MyEditProfile> {
  @override
  void initState() {
    // getUserProfileapi();
    super.initState();
    _emailcontroller.text = getuseremail;
    _mobilecontroller.text = getusermobile;
    _fullnamecontroller.text = getusername;
  }

  final _fullnamecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _mobilecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _image;

  final picker = ImagePicker();

  var token = getString('token');
  var getuserimg = getString('userimage');
  var getusername = getString('name');
  var getuseremail = getString('email');
  var getusermobile = getString('mobilenum');

  // Future<void> getUserProfileapi() async {
  //   if (await checkUserConnection()) {
  //     if (!mounted) return;
  //     ProgressDialogUtils.showProgressDialog(context);
  //     try {
  //       var apiurl = getProfileurl;
  //       debugPrint(apiurl);
  //       var headers = {
  //         'Authorization': 'Bearer' '$token',
  //         'Content-Type': 'application/json',
  //       };

  //       debugPrint(token);

  //       var request = http.Request('GET', Uri.parse(apiurl));
  //       request.headers.addAll(headers);
  //       http.StreamedResponse response = await request.send();
  //       final responsed = await http.Response.fromStream(response);
  //       var jsonResponse = jsonDecode(responsed.body);
  //       var getProfile = GetProfileModel.fromJson(jsonResponse);

  //       if (response.statusCode == 200) {
  //         debugPrint(responsed.body);
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (getProfile.status == 1) {
  //           setState(() {
  //             _fullnamecontroller.text = getProfile.data!.name ?? '';

  //             // username.text = getProfile.data!.fullName ?? "";
  //             _emailcontroller.text = getProfile.data!.email!;
  //             // _mobilecontroller= getProfile.data!.;
  //             getuserimg = getProfile.data!.image!;
  //             // totalOrder = getProfile.totalOrders!;
  //             // totalTicket = getProfile.totalTickets!;
  //             // isLoad = false;
  //           });
  //           debugPrint('is it success');
  //         } else {
  //           debugPrint('failed to load');
  //           ProgressDialogUtils.dismissProgressDialog();
  //         }
  //       } else if (response.statusCode == 401) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getProfile.message}',
  //           onPressed: () {
  //             // Navigator.pushAndRemoveUntil(
  //             //     context,
  //             //     MaterialPageRoute(builder: (context) => LoginScreen()),
  //             //     (route) => false);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 404) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getProfile.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 400) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getProfile.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 500) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getProfile.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       }
  //     } catch (e) {
  //       ProgressDialogUtils.dismissProgressDialog();
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

  Future<void> updateProfileapi() async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var apiurl = updateprofileurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer' '$token',
          'Content-Type': 'application/json',
        };

        var request = http.MultipartRequest('POST', Uri.parse(apiurl));
        if (_image != null) {
          var imageFile =
              await http.MultipartFile.fromPath('image', _image!.path);
          request.files.add(imageFile);
        }
        request.fields['name'] = _fullnamecontroller.text;
        request.fields['phone'] = _mobilecontroller.text;

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var updateProfile = UpdateProfileModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);

          ProgressDialogUtils.dismissProgressDialog();
          if (updateProfile.status == 1) {
            setState(() {
              setString('name', updateProfile.data!.name!.toString());
              setString('userimage', updateProfile.data!.image!.toString());
              // getUserProfileapi();
              Fluttertoast.showToast(
                msg: 'Profile updated Successfully',
              );

              Navigator.pop(context, true);
            });
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
            if (!mounted) return;
            vapeAlertDialogue(
              context: context,
              desc: '${updateProfile.message}',
              onPressed: () {
                Navigator.pop(context);
              },
            ).show();
          }
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();

          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${updateProfile.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${updateProfile.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 401) {
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${updateProfile.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          if (!mounted) return;
          vapeAlertDialogue(
            context: context,
            desc: '${updateProfile.message}',
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
          desc: 'Something went Wrong ',
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ).show();
      }
    } else {
      ProgressDialogUtils.dismissProgressDialog();

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
    debugPrint(token);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whitecolor,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0.0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: getTextWidget(
              title: 'Edit Profile',
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
                color: whitecolor,
                size: 24,
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getImage(),
              Padding(
                padding: const EdgeInsets.only(top: 29.0),
                child: getTextWidget(
                    title: 'Full Name',
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightMedium,
                    textColor: background),
              ),
              getFullname(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: getTextWidget(
                    title: 'Email',
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightMedium,
                    textColor: background),
              ),
              getEmail(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: getTextWidget(
                    title: 'Mobile',
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightMedium,
                    textColor: background),
              ),
              getMobile(),
              // Padding(
              //   padding: const EdgeInsets.only(top: 30.0),
              //   child: getTextWidget(
              //       title: 'Legal Documents & Details',
              //       textFontSize: fontSize20,
              //       textFontWeight: fontWeightBold,
              //       textColor: background),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20.0),
              //   child: getTextWidget(
              //       title: 'Driving Licence',
              //       textFontSize: fontSize15,
              //       textColor: background,
              //       textFontWeight: fontWeightMedium),
              // ),
              // _getImageDriving(),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20.0),
              //   child: getTextWidget(
              //       title: 'Vehicle Registration Documents',
              //       textFontSize: fontSize15,
              //       textColor: background,
              //       textFontWeight: fontWeightMedium),
              // ),
              // _getImageRegistration(),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20.0),
              //   child: getTextWidget(
              //       title: 'Vehicle Insurance Number',
              //       textFontSize: fontSize15,
              //       textColor: background,
              //       textFontWeight: fontWeightMedium),
              // ),
              // _getImageInsaurance(),
              getButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget getFullname() {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: TextFormDriver(
        borderColor: dropdownborder,
        fillColor: whitecolor,
        prefixiconcolor: background,
        controller: _fullnamecontroller,
        validation: (value) => Validation.validateName(value),
        hintText: 'Bessie Cooper',
        hintColor: background,
        textstyle: background,
        fontWeight: fontWeightMedium,
        prefixIcon: icUser,
      ),
    );
  }

  Widget getEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: TextFormDriver(
        borderColor: dropdownborder,
        fillColor: whitecolor,
        textstyle: background,
        enable: false,
        // validation: (value) => Validation.validateEmail() ,
        prefixiconcolor: background,
        keyboardType: TextInputType.emailAddress,
        controller: _emailcontroller,
        hintText: 'debra.holt@example.com',
        hintColor: background,
        fontWeight: fontWeightMedium,
        prefixIcon: icEmail,
      ),
    );
  }

  Widget getMobile() {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: TextFormDriver(
        borderColor: dropdownborder,
        fillColor: whitecolor,
        // validation: (value) => Validation.()
        enable: false,
        prefixiconcolor: background,
        textstyle: background,
        keyboardType: TextInputType.number,
        controller: _mobilecontroller,
        hintText: '(219) 555-0114',
        hintColor: background,
        fontWeight: fontWeightMedium,
        prefixIcon: icMobile,
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150.0,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  // Handle camera button tap
                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  // Handle gallery button tap
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void getImage(ImageSource source) async {
    try {
      final image = await picker.pickImage(source: source);
      if (image == null) {
        return;
      }
      final imgTemp = File(image.path);

      setState(() {
        _image = imgTemp;
      });
    } catch (e) {
      debugPrint("Failed to open $e");
    }
  }

  Widget _getImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: [
          Positioned(
            child: Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: ClipOval(
                child: _image == null
                    ? CachedNetworkImage(
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
                        imageUrl: getuserimg.toString(),
                        height: 147.0,
                        width: 147.0,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        _image!,
                        height: 147.0,
                        width: 147.0,
                        fit: BoxFit.cover,
                      ),
                // ? CachedNetworkImage(
                //     imageUrl: '$baseurl${getprofileImage.toString()}',
                //     imageBuilder: (context, imageProvider) => Container(
                //       height: 130.0,
                //       width: 130.0,
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: imageProvider,
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //     placeholder: (context, url) => Image.asset(
                //       'assets/images/person_icon.png',
                //       height: 130.0,
                //       width: 130.0,
                //       fit: BoxFit.cover,
                //     ),
                //     errorWidget: (context, url, error) =>
                //         const Icon(Icons.error),
                //   )
              ),
            ),
          ),
          Positioned(
              bottom: 0.0,
              right: 2.0,
              child: GestureDetector(
                onTap: () {
                  _showBottomSheet();
                },
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(icCamera), fit: BoxFit.cover)),
                ),
              )

              // IconButton(
              //   onPressed: () {
              //     _showBottomSheet();
              //   },
              //   icon: Image.asset(
              //     icCamera,
              //     height: 38.0,
              //     width: 38.0,
              //     fit: BoxFit.cover,
              //   ),
              // ),

              )
        ]),
      ],
    );
  }

  Widget getButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CustomizeButton(
            text: 'Save',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                updateProfileapi();
              } else {
                debugPrint("Else part");
              }
            },
          ),
        ),
      ),
    );
  }
}
