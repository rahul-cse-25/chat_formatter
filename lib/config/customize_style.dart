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

  Text impBody(String text,
      {TextAlign? textAlign,
      TextStyle? textStyle,
      Color? textColor,
      FontWeight? fontWeight,
      int? maxLines}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      textAlign: textAlign ?? TextAlign.left,
      style: textStyle ?? bodyStyle(color: textColor, fontWeight: fontWeight),
    );
  }

  // LinearGradient impLinearGradient({List<Color>? colors}) {
  //   return LinearGradient(
  //     colors: colors ?? ImpColors.nameText,
  //     begin: Alignment.topRight,
  //     end: Alignment.bottomLeft,
  //   );
  // }

  Text chatBubbleHeader(
    String text, {
    int? maxLinesOfText,
    TextOverflow? onOverFlow,
    TextAlign? textAlign,
    TextStyle? textStyle,
    bool isLevelTwo = false,
  }) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: textStyle ?? chatHeaderStyle(),
    );
  }

  TextStyle chatHeaderStyle() {
    return TextStyle(
      fontSize: 2.5 * sizes.textMultiplier,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  Text chatBubbleSubHeader(
    String text, {
    int? maxLinesOfText,
    TextOverflow? onOverFlow,
    TextAlign? textAlign,
    TextStyle? textStyle,
    bool isLevelTwo = false,
  }) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: textStyle ?? chatSubHeaderStyle(),
    );
  }

  TextStyle chatSubHeaderStyle() {
    return TextStyle(
      fontSize: 2.0 * sizes.textMultiplier,
      color: Colors.white70,
    );
  }

  Text chatBubbleBody(String text,
      {TextAlign? textAlign,
      TextStyle? textStyle,
      Color? textColor,
      double? textSize}) {
    return Text(
      text,
      textAlign: textAlign,
      style:
          textStyle ?? chatBodyStyle(textColor: textColor, textSize: textSize),
    );
  }

  TextStyle chatBodyStyle({Color? textColor, double? textSize}) {
    return TextStyle(
      fontSize: textSize ?? 1.7 * sizes.textMultiplier,
      color: textColor ?? Colors.white,
    );
  }

  Text pdfText(
    String text, {
    TextAlign? textAlign,
    TextStyle? textStyle,
  }) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: textStyle ?? pdfTextStyle(),
    );
  }

  TextStyle pdfTextStyle(
      {double? size,
      Color? darkModeColor,
      Color? lightModeColor,
      FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: size ?? 2.3 * sizes.textMultiplier,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: ImpColors.pureBlackColor,
    );
  }

  TextStyle impSloganStyle({Color? color}) {
    return TextStyle(
        fontSize: sizes.verticalBlockSize * 5.5,
        color: color ?? ImpColors.pureWhiteColor.withOpacity(0.9),
        fontWeight: FontWeight.bold);
  }

  RichText impRichText(String text1, String text2, String text3,
      {double? sizeOfText,
      TextAlign? textAlign,
      TextStyle? textStyle1,
      TextStyle? textStyle2,
      TextStyle? textStyle3,
      Color? color1,
      Color? color2,
      Color? color3}) {
    return RichText(
      textAlign: textAlign ?? TextAlign.left,
      text: TextSpan(
        children: [
          TextSpan(
              text: text1, style: textStyle1 ?? impSloganStyle(color: color1)),
          TextSpan(
              text: text2, style: textStyle2 ?? impSloganStyle(color: color2)),
          TextSpan(
              text: text3, style: textStyle3 ?? impSloganStyle(color: color3)),
        ],
      ),
    );
  }

  LinearGradient impBgGradient() {
    return LinearGradient(
      colors: ImpColors.selfBubble,
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
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

  TextStyle bodyStyle({Color? color, FontWeight? fontWeight, double? size}) {
    return TextStyle(
      fontSize: size ?? 2.0 * sizes.textMultiplier,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black,
    );
  }

  TextStyle ultraMiniStyle({double? size, Color? color}) {
    return TextStyle(
      fontSize: size ?? 1.5 * sizes.textMultiplier,
      fontWeight: FontWeight.normal,
      color: color ?? Colors.black,
    );
  }

  // // Image Styles
  // LottieBuilder ImpLottieImage(String imagePath,
  //     {double widthInPercent = 20, AnimationController? animationController}) {
  //   return Lottie.asset(
  //     imagePath,
  //     width: sizes.horizontalBlockSize * widthInPercent,
  //     fit: BoxFit.cover,
  //     controller: animationController,
  //     onLoaded: (composition) {
  //       if (animationController != null) {
  //         animationController.duration = composition.duration;
  //       }
  //     },
  //   );
  // }

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

  TextStyle hintStyle() {
    return bodyStyle(color: ImpColors.hintTextColor);
  }

  TextStyle labelStyle() {
    return bodyStyle(color: ImpColors.labelTextColor);
  }

  BorderRadius impTextFieldBorderRadius() {
    return BorderRadius.circular(sizes.textMultiplier * 2);
  }

  // Date Time Container Styles

  // Date Time text Styles

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
        helperStyle: ultraMiniStyle(color: helperColor),
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: labelStyle(),
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

  Widget impLoginSignUpTextField({
    bool needSuffixIcon = false,
    required TextEditingController controller,
    VoidCallback Function(String text)? onChangedText,
    VoidCallback? onSuffixIconPressed,
    String? hintText,
    bool obscureText = false,
    String? helperText,
    Color? helperColor,
    int? helperMaxLines,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: sizes.horizontalBlockSize * 4,
        right: sizes.horizontalBlockSize * 4,
        bottom: helperText == null ? 0 : sizes.verticalBlockSize * 1.5,
      ),
      decoration: BoxDecoration(
        borderRadius: impTextFieldBorderRadius(),
        border: Border.all(
          color: ImpColors.greyColor,
        ),
        color: ImpColors.loginSignTextFieldContainerBgLight,
      ),
      child: impTextField(
        controller: controller,
        hintText: hintText,
        obscureText: obscureText,
        suffixIcon: needSuffixIcon
            ? obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined
            : null,
        onSuffixIconPressed: onSuffixIconPressed,
        multiLine: false,
        contentPadding: false,
        outerBorder: false,
        focusOuterBorder: false,
        helperText: helperText,
        helperColor: helperColor,
        helperMaxLines: helperMaxLines,
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
