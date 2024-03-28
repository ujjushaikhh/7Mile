import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../constant/image_constant.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';
import '../login/login.dart';

class MyIntro extends StatefulWidget {
  const MyIntro({super.key});

  @override
  State<MyIntro> createState() => _MyIntroState();
}

class _MyIntroState extends State<MyIntro> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();
  final List title = [
    'Find\nthe perfect\nplace',
    'Aenean\ndignissim metus\nvitae'
  ];

  final List subTitle = [
    'Find  the  perfect  home  for  your  holiday accommodation',
    'Find  the  perfect  home  for  your  holiday accommodation'
  ];
  final List image = [icHookah, icChillam];
  final List intro = [icIntor1, icIntor2];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            scrollPhysics: const NeverScrollableScrollPhysics(),
            initialPage: 0,
            viewportFraction: 1.0,
            height: MediaQuery.of(context).size.height,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          carouselController: _carouselController,
          itemCount: title.length,
          itemBuilder: (context, index, realIndex) {
            return Stack(children: [
              Image.asset(
                intro[index],
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.01, -1.00),
                    end: Alignment(0.01, 1),
                    colors: [Color(0x00111D31), Color(0xFF111D31)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 128.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    getTitle(
                      title[index],
                    ),
                    getSubTitle(subTitle[index]),
                  ],
                ),
              ),
              Positioned.fill(
                  bottom: _currentIndex == 0 ? -120.0 : -20.0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: _currentIndex == 1 ? 25.0 : 0.0),
                      child: getImage(
                          image[index],
                          _currentIndex == 0 ? 276 : 168,
                          _currentIndex == 0 ? 201 : 122),
                    ),
                  ))
            ]);
          },
        ),
        Align(alignment: Alignment.bottomCenter, child: getBottomBar())
      ]),
    );
  }

  Widget getImage(String image, double height, double width) {
    return Image.asset(
      image,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }

  void _onNextPress() {
    if (_currentIndex < title.length - 1) {
      _carouselController.nextPage();
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyLogin()));
      setState(() {
        setBool('seen', true);
      });
    }
  }

  void onSkipPress() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyLogin()),
      (route) => false,
    );
    await setBool('seen', true);
  }

  Widget getBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 16.0, bottom: 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _currentIndex == 0
              ? GestureDetector(
                  onTap: () {
                    onSkipPress();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: getTextWidget(
                        title: 'Skip',
                        textFontSize: fontSize14,
                        textFontWeight: fontWeightRegular),
                  ),
                )
              : Container(),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 50.0),
                    child: Image.asset(
                      _currentIndex == 0 ? icIndicator1 : icIndicator2,
                      height: 3,
                      width: 48,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 16.0),
                  //   child: Image.asset(
                  //     icIndicator2,
                  //     height: 3,
                  //     width: 48,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                        onTap: () {
                          _onNextPress();
                        },
                        child: _currentIndex == 0
                            ? Container(
                                width: 56,
                                height: 58,
                                decoration: ShapeDecoration(
                                  color: greencolor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      _onNextPress();
                                    },
                                    icon: Image.asset(
                                      icRightArrow,
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.cover,
                                    )),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _onNextPress();
                                },
                                child: Container(
                                  width: 122,
                                  height: 58,
                                  decoration: ShapeDecoration(
                                    color: greencolor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                  ),
                                  child: Center(
                                    child: getTextWidget(
                                        title: 'Get Started',
                                        textFontSize: fontSize14,
                                        textFontWeight: fontWeightMedium,
                                        textColor: background),
                                  ),
                                ),
                              )),
                  )
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget getTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: getTextWidget(
          title: title,
          maxLines: 3,
          textColor: whitecolor,
          textFontSize: fontSize40,
          textFontWeight: fontWeightBold),
    );
  }

  Widget getSubTitle(String subTitle) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 34),
      child: Opacity(
        opacity: 0.60,
        child: getTextWidget(
            title: subTitle,
            textColor: whitecolor,
            textFontSize: fontSize16,

            // height: 0.09,
            textFontWeight: fontWeightRegular),
      ),
    );
  }
}
