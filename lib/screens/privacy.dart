import 'package:chat_formatter/config/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/customize_style.dart';

class Privacy extends StatelessWidget {
  Privacy({super.key});

  final ImpCustomizeStyle impStyle = ImpCustomizeStyle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: impStyle.sizes.horizontalBlockSize * 8.0,
              horizontal: impStyle.sizes.horizontalBlockSize * 2.0),
          decoration: BoxDecoration(
              color: Colors.black87.withOpacity(0.8),
              borderRadius: BorderRadius.circular(
                impStyle.sizes.horizontalBlockSize * 10.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade800,
                  spreadRadius: 4,
                  blurStyle: BlurStyle.outer,
                ),
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: impStyle.sizes.horizontalBlockSize * 5.0,
                vertical: impStyle.sizes.horizontalBlockSize * 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                impStyle.impVerticalGap(verticalGapSizeInPercent: 1.0),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: impStyle.sizes.horizontalBlockSize * 8.0,
                        vertical: impStyle.sizes.horizontalBlockSize * 2.0),
                    decoration: BoxDecoration(
                        color: Colors.black87.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(
                            impStyle.sizes.horizontalBlockSize * 5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade800,
                            spreadRadius: 2,
                            blurStyle: BlurStyle.outer,
                          ),
                        ]),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: impStyle.sizes.horizontalBlockSize * 5.0,
                          height: impStyle.sizes.horizontalBlockSize * 5.0,
                          decoration: BoxDecoration(
                              color: Colors.black45.withOpacity(0.5),
                              shape: BoxShape.circle),
                        ),
                        impStyle.impHorizontalGap(
                            horizontalGapSizeInPercent: 3.0),
                        impStyle.impHeader('Privacy Statement'),
                      ],
                    )),
                impStyle.impVerticalGap(verticalGapSizeInPercent: 2.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        impStyle.impRichText(ImpStrings.privacyOneTitle,
                            ImpStrings.privacyOneContent),
                        impStyle.impVerticalGap(verticalGapSizeInPercent: 2.0),
                        impStyle.impRichText(ImpStrings.privacyTwoTitle,
                            ImpStrings.privacyTwoContent),
                        impStyle.impVerticalGap(verticalGapSizeInPercent: 2.0),
                        impStyle.impRichText(ImpStrings.privacyThreeTitle,
                            ImpStrings.privacyThreeContent),
                        impStyle.impVerticalGap(verticalGapSizeInPercent: 2.0),
                        impStyle.impRichText(ImpStrings.privacyFourTitle,
                            ImpStrings.privacyFourContent),
                        impStyle.impVerticalGap(verticalGapSizeInPercent: 2.0),
                        impStyle.impRichText(ImpStrings.privacyFiveTitle,
                            ImpStrings.privacyFiveContent),
                        impStyle.impVerticalGap(verticalGapSizeInPercent: 2.0),
                        impStyle.impRichText(ImpStrings.privacySixTitle,
                            ImpStrings.privacySixContent),
                      ],
                    ),
                  ),
                ),
                impStyle.impVerticalGap(verticalGapSizeInPercent: 2.0),
                Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        impStyle.impSubHeader(
                          'Rahul Prajapati',
                          textStyle: GoogleFonts.monteCarlo(
                              textStyle: impStyle.subHeaderStyle(
                                  color: Colors.white54,
                                  size: impStyle.sizes.textMultiplier * 2.0)),
                        ),
                        impStyle.impSubHeader('Signature',
                            textColor: Colors.white30),
                      ],
                    )),
                impStyle.impVerticalGap(verticalGapSizeInPercent: 2.0),
                impStyle.impShadedIconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.keyboard_double_arrow_down,
                    backgroundColor: Colors.grey.shade900),
                impStyle.impVerticalGap(
                    verticalGapSizeInPercent:
                        impStyle.sizes.horizontalBlockSize / 2),
                impStyle.impSubHeader(
                  'Created by @Rahul Prajapati',
                  textColor: Colors.white12,
                ),
                impStyle.impVerticalGap(
                    verticalGapSizeInPercent:
                        impStyle.sizes.horizontalBlockSize / 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
