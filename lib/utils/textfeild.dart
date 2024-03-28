import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/color_constant.dart';
import '../constant/font_constant.dart';
import '../constant/image_constant.dart';

class TextFormDriver extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? prefixIcon, suffixIcon;
  final bool filled;
  final String? Function(String?)? validation;
  final Color fillColor;
  final Color borderColor;
  final Color prefixiconcolor;
  final Color suffixiconcolor;
  final bool obscureText;
  final String? image;
  final List<TextInputFormatter>? inputFormatters;
  final bool enable;
  final Widget? suffix;
  // final String suffixText;
  // final TextStyle? suffixtextstyle;
  final Function(String)? onfeildSubmitted;

  final Function(String)? onChange;
  final Color hintColor;
  final Color textstyle;
  final bool autoFocus;
  final double fontSize;
  final FontWeight fontWeight;

  const TextFormDriver(
      {Key? key,
      this.suffix,
      required this.controller,
      required this.hintText,
      this.inputFormatters,
      this.keyboardType,
      this.onfeildSubmitted,
      // this.suffixText = '',
      this.prefixIcon,
      this.autoFocus = false,
      // this.suffixtextstyle,
      this.suffixiconcolor = whitecolor,
      this.textstyle = whitecolor,
      this.prefixiconcolor = whitecolor,
      this.onChange,
      this.hintColor = hintcolor,
      this.fontSize = fontSize14,
      this.fontWeight = fontWeightRegular,
      this.enable = true,
      this.filled = true,
      this.fillColor = background,
      this.borderColor = bordercolor,
      this.suffixIcon,
      this.validation,
      this.image,
      this.obscureText = false})
      : super(key: key);

  @override
  State<TextFormDriver> createState() => _TextFormDriverState();
}

class _TextFormDriverState extends State<TextFormDriver> {
  bool _obscureText = true;

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _oncrosspressed() {
    setState(() {
      widget.controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validation,
      controller: widget.controller,
      onChanged: widget.onChange,
      autofocus: widget.autoFocus,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: widget.onfeildSubmitted,
      keyboardType: widget.keyboardType,
      // autofocus: true,
      obscureText: widget.obscureText ? _obscureText : false,
      style: TextStyle(
          color: widget.textstyle,
          fontFamily: fontfamilybeVietnam,
          fontWeight: fontWeightMedium,
          fontSize: fontSize14),
      decoration: InputDecoration(
        // suffixText: widget.suffixText,
        // suffixStyle: widget.suffixtextstyle,
        suffix: widget.suffix,

        contentPadding: const EdgeInsets.only(left: 16.0),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintColor,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          fontFamily: fontfamilybeVietnam,
        ),
        fillColor: widget.fillColor,
        filled: widget.filled,
        enabled: widget.enable,
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      widget.prefixIcon!,
                      color: widget.prefixiconcolor,
                    ),
                  ),
                ),
              )
            : null,
        suffixIcon: widget.suffixIcon != null
            ? widget.suffixIcon != icClose
                ? widget.suffixIcon != icApply
                    ? GestureDetector(
                        onTap: _togglePassword,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              _obscureText ? icCloseeye : icOpeneye,
                              color: widget.suffixiconcolor,
                              height: 24.0,
                              width: 24.0,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: _onApplyPressed,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              icApply,
                              color: widget.suffixiconcolor,
                              height: 18.0,
                              width: 42.0,
                            ),
                          ),
                        ),
                      )
                : GestureDetector(
                    onTap: _oncrosspressed,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          icClose,
                          color: widget.suffixiconcolor,
                          height: 24.0,
                          width: 24.0,
                        ),
                      ),
                    ),
                  )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            width: 1.0,
            color: widget.borderColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: bordererror),
        ),
      ),
    );
  }

  void _onApplyPressed() {
    debugPrint("Apply is pressed");
  }
}
