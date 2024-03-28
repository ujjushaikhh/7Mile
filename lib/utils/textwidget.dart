import 'package:flutter/material.dart';

import '../constant/color_constant.dart';
import '../constant/font_constant.dart';

Widget getTextWidget(
        {required String title,
        Color textColor = whitecolor,
        double textFontSize = fontSize14,
        FontWeight? textFontWeight,
        TextAlign? textAlign,
        String? fontfamily = fontfamilybeVietnam,
        TextDecoration? textDecoration,
        FontStyle? textFontStyle,
        TextDirection? textDirection,
        double? height,
        int? maxLines}) =>
    Text(title,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
        textDirection: textDirection,
        style: TextStyle(
            height: height,
            fontSize: textFontSize,
            fontFamily: fontfamily,
            color: textColor,
            decoration: textDecoration,
            fontWeight: textFontWeight,
            fontStyle: textFontStyle));
