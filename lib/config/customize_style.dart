import 'package:chat_formatter/config/sizes.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class ImpCustomizeStyle {
  late final ImpSizes sizes;

  ImpCustomizeStyle() : sizes = ImpSizes(constraints: null, orientation: null);

  ImpCustomizeStyle.init(BoxConstraints constraints, Orientation orientation)
      : sizes = ImpSizes(constraints: constraints, orientation: orientation);

  // Text Styles
  Text impHeader(
    String text, {
    int? maxLinesOfText,
    Color? textColor,
    double? fontSize,
    TextOverflow? onOverFlow,
    TextAlign? textAlign,
    TextStyle? textStyle,
    FontWeight? fontWeight2,
    bool isLevelTwo = false,
  }) {
    return Text(
      text,
      maxLines: maxLinesOfText,
      overflow: onOverFlow,
      textAlign: textAlign ?? TextAlign.left,
      style: textStyle ??
          headerStyle(
              fontWeight: fontWeight2, color: textColor, size: fontSize),
    );
  }

  Text impSubHeader(String text,
      {int? maxLinesOfText,
      Color? textColor,
      double? fontSize,
      TextOverflow? onOverFlow,
      TextAlign? textAlign,
      TextStyle? textStyle}) {
    return Text(
      text,
      // maxLines: maxLinesOfText ?? 1,
      // overflow: onOverFlow ?? TextOverflow.visible,
      textAlign: textAlign ?? TextAlign.left,
      style: textStyle ?? subHeaderStyle(color: textColor, size: fontSize),
    );
  }

  TextStyle impPrivacyStyle({Color? color, FontWeight? fontWeight, double? size}) {
    return TextStyle(
        fontSize: size,
        color: color ?? ImpColors.pureWhiteColor.withOpacity(0.9),
        fontWeight: fontWeight);
  }

  RichText impRichText(String text1, String text2,
      {double? sizeOfText,
      TextAlign? textAlign,
      TextStyle? textStyle1,
      TextStyle? textStyle2,
      Color? color1,
      Color? color2}) {
    return RichText(
      textAlign: textAlign ?? TextAlign.left,
      text: TextSpan(
        children: [
          TextSpan(
              text: text1, style: textStyle1 ?? impPrivacyStyle(color: color1, fontWeight: FontWeight.bold, size: sizes.textMultiplier * 1.5)),
          TextSpan(
              text: text2, style: textStyle2 ?? impPrivacyStyle(color: color2, fontWeight: FontWeight.normal, size: sizes.textMultiplier * 1.5)),
        ],
      ),
    );
  }

  TextStyle headerStyle({Color? color, FontWeight? fontWeight, double? size}) {
    return TextStyle(
      fontSize: size ?? 2.2 * sizes.textMultiplier,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? Colors.white,
    );
  }

  TextStyle levelTwoHeader({Color? darkModeColor, Color? lightModeColor}) {
    return TextStyle(
      fontSize: 1.8 * sizes.textMultiplier,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );
  }

  TextStyle subHeaderStyle(
      {Color? color, FontWeight? fontWeight, double? size}) {
    return TextStyle(
      fontSize: size ?? 1.5 * sizes.textMultiplier,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black,
    );
  }

  Image impImage(String imagePath,
      {double? widthInPercent,
      Key? imageKey,
      double? heightInPercent,
      BoxFit? fitting}) {
    return Image.asset(
      key: imageKey,
      imagePath,
      width: widthInPercent == null
          ? null
          : sizes.horizontalBlockSize * widthInPercent,
      height: heightInPercent == null
          ? null
          : sizes.verticalBlockSize * heightInPercent,
      fit: fitting ?? BoxFit.contain,
    );
  }

  // Button Styles
  ElevatedButton impElevatedButton(
      {required VoidCallback onPressed,
      BorderRadius? borderRadiusOfButton,
      Color? backgroundColor,
      double? widthInPercent,
      double? heightInPercent,
      Color? borderColor,
      required Widget childOfButton}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ImpColors.purePurpleColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusOfButton ??
              BorderRadius.circular(sizes.horizontalBlockSize * 4),
        ),
        side: borderColor != null
            ? BorderSide(color: borderColor, width: 1)
            : null,
        minimumSize: widthInPercent != null
            ? Size(
                sizes.horizontalBlockSize * widthInPercent,
                sizes.verticalBlockSize * (heightInPercent ?? 6.5),
              )
            : null,
      ),
      onPressed: onPressed,
      child: childOfButton,
    );
  }

// Icon Styles
  IconButton impIconButton(
    IconData iconData, {
    required VoidCallback onPressed, // Click functionality
    Color? color,
    double? sizeOfIcon,
  }) {
    return IconButton(
      icon: impIcon(
        iconData,
        color: color,
        sizeOfIcon: sizeOfIcon,
      ),
      onPressed: onPressed,
    );
  }

  Icon impIcon(IconData iconData, {Color? color, double? sizeOfIcon}) {
    return Icon(
      iconData,
      size: sizeOfIcon ?? 3.0 * sizes.textMultiplier,
      color: color ?? Colors.white,
    );
  }

  Widget impVerticalGap({double? verticalGapSizeInPercent}) {
    return SizedBox(
      height: sizes.getVerticalGapSize(
          verticalGapSizeInPercent:
              verticalGapSizeInPercent ?? sizes.verticalBlockSize),
    );
  }

  Expanded impVerticalGapExpanded() {
    return const Expanded(
      child: SizedBox.shrink(),
    );
  }

  Widget impHorizontalGap({double? horizontalGapSizeInPercent}) {
    return SizedBox(
      width: sizes.getHorizontalGapSize(
          horizontalGapSizeInPercent:
              horizontalGapSizeInPercent ?? sizes.horizontalBlockSize),
    );
  }

  Widget impGapSize(
      {required double horizontalGapSizeInPercent,
      required double verticalGapSizeInPercent}) {
    return SizedBox(
      width: sizes.getHorizontalGapSize(
          horizontalGapSizeInPercent: horizontalGapSizeInPercent),
      height: sizes.getVerticalGapSize(
          verticalGapSizeInPercent: verticalGapSizeInPercent),
    );
  }

  // Padding of all screen
  EdgeInsets impAllScreenPadding() {
    return EdgeInsets.symmetric(
        horizontal: sizes.horizontalBlockSize * 4,
        vertical: sizes.horizontalBlockSize * 2);
  }

  EdgeInsets chatScreenBottomNavPadding() {
    return EdgeInsets.only(
      top: sizes.horizontalBlockSize * 3,
      left: sizes.horizontalBlockSize * 4,
      right: sizes.horizontalBlockSize * 4,
      bottom: sizes.horizontalBlockSize * 3,
    );
  }

  // Margin of all screen
  EdgeInsets impTextFieldContainerPadding() {
    return EdgeInsets.symmetric(
        horizontal: sizes.horizontalBlockSize * 4,
        vertical: sizes.horizontalBlockSize * 1.5);
  }

  BorderRadius impTextFieldBorderRadius() {
    return BorderRadius.circular(sizes.textMultiplier * 2);
  }


  // TextField Styles
  TextField impTextField({
    required TextEditingController controller,
    Function(String text)? onChangedText,
    VoidCallback? onPrefixIconPressed,
    FocusNode? focusNode,
    IconData? prefixIcon,
    IconData? suffixIcon,
    IconData? suffixIcon2,
    VoidCallback? onSuffixIconPressed,
    VoidCallback? onSuffixIcon2Pressed,
    String? hintText,
    Color? hintTextColor,
    String? labelText,
    String? helperText,
    Color? helperColor,
    int? helperMaxLines,
    bool multiLine = true,
    bool outerBorder = true,
    bool focusOuterBorder = true,
    bool contentPadding = true,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChangedText,
      maxLines: multiLine ? 4 : 1,
      minLines: 1,
      obscureText: obscureText,
      style: subHeaderStyle(color: ImpColors.pureWhiteColor),
      cursorColor: ImpColors.successGreenColor,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? IconButton(
                onPressed: onPrefixIconPressed,
                icon: impIcon(prefixIcon,
                    sizeOfIcon: 3.0 * sizes.textMultiplier,
                    color: ImpColors.pureLightOrangeColor),
              )
            : null,
        suffixIcon: suffixIcon != null || suffixIcon2 != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (suffixIcon != null)
                    IconButton(
                      onPressed: onSuffixIconPressed,
                      icon: impIcon(
                        suffixIcon,
                        sizeOfIcon: 3.0 * sizes.textMultiplier,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  if (suffixIcon2 != null)
                    IconButton(
                      onPressed: onSuffixIcon2Pressed,
                      icon: impIcon(
                        suffixIcon2,
                        sizeOfIcon: 3.0 * sizes.textMultiplier,
                        color: ImpColors.pureLightOrangeColor,
                      ),
                    ),
                ],
              )
            : null,
        alignLabelWithHint: true,
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor ?? ImpColors.hintTextColor,
          fontSize: 16.0,
        ),
        contentPadding: contentPadding
            ? impTextFieldContainerPadding()
            : EdgeInsets.all(sizes.textMultiplier),
        enabledBorder: OutlineInputBorder(
          borderRadius: impTextFieldBorderRadius(),
          borderSide: outerBorder
              ? const BorderSide(color: ImpColors.hintTextColor, width: 1)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: impTextFieldBorderRadius(),
          borderSide: focusOuterBorder
              ? const BorderSide(
                  color: ImpColors.loginSignUpSuffixIconColor, width: 1)
              : BorderSide.none,
        ),
      ),
    );
  }

  Widget impShadedIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    Color? iconColor,
    Color? backgroundColor,
    Color? borderColor,
    double? iconSize,
  }) {
    return Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade800,
                spreadRadius: 1,
              ),
            ]),
        child: impIconButton(
          icon,
          onPressed: onPressed,
          color: iconColor,
          sizeOfIcon: iconSize,
        ));
  }
}
