import 'dart:io';

import 'package:chat_formatter/config/colors.dart';
import 'package:chat_formatter/config/customize_style.dart';
import 'package:chat_formatter/config/images.dart';
import 'package:chat_formatter/screens/chat.dart';
import 'package:chat_formatter/screens/privacy.dart';
import 'package:chat_formatter/services/extract_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? fileContent;
  File? file;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            ImpCustomizeStyle impStyle =
                ImpCustomizeStyle.init(constraints, orientation);
            return Scaffold(
              // backgroundColor: Colors.black54,
              body: Stack(
                children: [
                  Positioned(
                      child: Container(
                    color: Colors.black87.withOpacity(0.95),
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // appBar

                      // body
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(
                                impStyle.sizes.horizontalBlockSize * 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                impStyle.impImage(ImpImages.textFile,
                                    heightInPercent: 20, widthInPercent: 50),
                                impStyle.impSubHeader(
                                    "Please upload the unzipped WhatsApp chat file in `.txt` format.",
                                    textColor: Colors.white30,
                                    fontSize:
                                        impStyle.sizes.textMultiplier * 2.0,
                                    textAlign: TextAlign.center),
                                impStyle.impVerticalGap(
                                    verticalGapSizeInPercent:
                                        impStyle.sizes.horizontalBlockSize / 2),
                                impStyle.impElevatedButton(
                                    onPressed: () =>
                                        _pickFile(context, impStyle),
                                    childOfButton: impStyle.impHeader(
                                      isLoading ? 'Uploading...' : 'Upload',
                                    ),
                                    widthInPercent: 50,
                                    backgroundColor: isLoading
                                        ? Colors.grey
                                        : Colors.green.withOpacity(0.8),
                                    borderColor: Colors.white24,
                                    heightInPercent: 6),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // bottomBar
                      impStyle.impShadedIconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return Privacy();
                                }, transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: animation.drive(Tween(
                                        begin: const Offset(0.0, 1.0),
                                        end: Offset.zero)),
                                    child: child,
                                  );
                                }));
                          },
                          icon: Icons.keyboard_double_arrow_up,
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
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickFile(
      BuildContext context, ImpCustomizeStyle impStyle) async {
    try {
      // Using File Picker to pick the file
      setState(() => isLoading = true);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (result != null) {
        // Ensure file path is not null
        String? filePath = result.files.single.path;
        if (filePath != null) {
          File file = File(filePath);

          // Read the file contents
          String content = await file.readAsString();

          // Update UI
          setState(() {
            file = file;
            fileContent = content;
            isLoading = false;
          });
          List<Map<String, String>>? chatData =
              Extraction.extractData(fileContent: fileContent!);
          // printGreen(chatData?.length);
          // printYellow("Úsers: ${Extraction.users}");

          if (chatData != null && chatData.isNotEmpty) {
            // ignore: use_build_context_synchronously
            showAlertDialog(context, impStyle, chatData);
          }
        } else {
          // printRed("Error: File path is null.");
        }
      } else {
        // User canceled the picker
        setState(() {
          isLoading = false;
          fileContent = null;
        });
        // printGreen(fileContent);
      }
    } catch (e) {
      setState(() => isLoading = false);
      // printRed("Error while picking file: $e");
    }
  }

  void showAlertDialog(BuildContext context, ImpCustomizeStyle impStyle,
      List<Map<String, String>> chatData) {
    // Set up the buttons
    Widget cancelButton = TextButton(
      child: impStyle.impSubHeader("Cancel",
          textColor: ImpColors.pureWhiteColor,
          fontSize: impStyle.sizes.textMultiplier * 2.0),
      onPressed: () {
        Navigator.of(context).pop();
        fileContent = null;
        file = null;
      },
    );

    // Set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.grey.shade900,
      title: Padding(
        padding: EdgeInsets.only(bottom: impStyle.sizes.horizontalBlockSize),
        child: Center(
            child: impStyle.impHeader('User detected',
                textColor: ImpColors.pureWhiteColor)),
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: impStyle.sizes.horizontalBlockSize * 4.0),
        child: Wrap(
          children: [
            impStyle.impSubHeader(
                "These users have been detected in your conversation. Please select the one that represents you.",
                textColor: ImpColors.pureWhiteColor,
                textAlign: TextAlign.left),
            impStyle.impVerticalGap(
                verticalGapSizeInPercent: impStyle.sizes.horizontalBlockSize),
            for (String user in Extraction.users)
              Padding(
                padding:
                    EdgeInsets.only(top: impStyle.sizes.horizontalBlockSize),
                child: impStyle.impElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chat(
                              chatData: chatData,
                              self: user,
                            ),
                          ));
                    },
                    childOfButton: impStyle.impHeader(user),
                    widthInPercent: 100,
                    backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
                    borderColor: Colors.white38,
                    heightInPercent: 5),
              ),
          ],
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
