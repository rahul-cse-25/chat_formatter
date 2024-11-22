import 'dart:async';

import 'package:chat_formatter/config/colors.dart';
import 'package:chat_formatter/config/customize_style.dart';
import 'package:chat_formatter/services/extract_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Chat extends StatefulWidget {
  final List<Map<String, String>> chatData;
  final String self;

  const Chat({super.key, required this.chatData, required this.self});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ImpCustomizeStyle impStyle = ImpCustomizeStyle();

  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  Timer? hideDateTimer;

  List<int> tappedIndex = [];
  List<int> searchResults = [];
  String otherUser = '';
  String visibleDate = '';
  int? searchedIndex;

  bool showScrollButton = true;
  bool isSearchingOpen = false;
  bool isEmpty = true;
  bool isScrolling = false;

  @override
  void initState() {
    super.initState();
    for (String user in Extraction.users) {
      if (user != widget.self) {
        otherUser = user;
      }
    }
    // for (String date in Extraction.dates) {
    //   printYellow(date);
    // }
    if (widget.chatData.isNotEmpty) {
      visibleDate = widget.chatData.first['date']!;
    }
    itemPositionsListener.itemPositions.addListener(scrollListener);
  }

  void scrollListener() {
    // Get the list of currently visible items
    final visibleItems = itemPositionsListener.itemPositions.value;

    // Find the first visible item (minimum index)
    int firstVisibleIndex = visibleItems
        .where((position) => position.itemLeadingEdge >= 0)
        .map((position) => position.index)
        .reduce((min, index) => index < min ? index : min);

    int remainingItems = widget.chatData.length - firstVisibleIndex - 1;

    // Update the visible date based on the first visible item's date
    String newVisibleDate = widget.chatData[firstVisibleIndex]['date']!;
    if (newVisibleDate != visibleDate) {
      setState(() {
        visibleDate = newVisibleDate;
        isScrolling = true;
        showScrollButton = remainingItems >= 50;
      });
    }

    hideDateTimer?.cancel();

    // Start a new timer to hide the date container after 2 seconds
    hideDateTimer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isScrolling =
            false; // Hide date container after 2 seconds of no scrolling
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SafeArea(
        child: Column(children: [
          // appbar
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: impStyle.sizes.horizontalBlockSize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      impStyle.impIconButton(
                        Icons.arrow_back,
                        onPressed: Navigator.of(context).pop,
                        sizeOfIcon: impStyle.sizes.textMultiplier * 3,
                      ),
                      Container(
                          padding: EdgeInsets.all(
                              impStyle.sizes.horizontalBlockSize * 2.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white12,
                          ),
                          child: impStyle.impIcon(Icons.person,
                              color: Colors.white)),
                      impStyle.impHorizontalGap(horizontalGapSizeInPercent: 2),
                      Expanded(
                          child: impStyle.impHeader(
                              Extraction.users.length > 2
                                  ? 'Chat-mates'
                                  : otherUser,
                              textColor: Colors.white,
                              maxLinesOfText: 1,
                              onOverFlow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  color: Colors.grey.shade900,
                  offset: Offset(-impStyle.sizes.horizontalBlockSize * 5.0,
                      impStyle.sizes.horizontalBlockSize * 10.0),
                  onSelected: (value) {
                    // Handle the selected menu option here
                    switch (value) {
                      case 'Go to Top':
                        scrollToTop();
                        break;
                      case 'Search':
                        setState(() {
                          isSearchingOpen = true;
                          focusNode.requestFocus();
                        });
                        break;
                      case 'More':
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Go to Top', 'Search'}.map((String choice) {
                      return PopupMenuItem<String>(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                impStyle.sizes.horizontalBlockSize * 4.0),
                        value: choice,
                        child: impStyle.impSubHeader(choice,
                            textColor: Colors.white),
                      );
                    }).toList();
                  },
                  icon: Row(
                    children: [
                      if (isSearchingOpen &&
                          searchedIndex != null &&
                          searchResults.isNotEmpty)
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    impStyle.sizes.horizontalBlockSize * 2.0,
                                vertical:
                                    impStyle.sizes.horizontalBlockSize * 1.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(
                                    impStyle.sizes.textMultiplier),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    spreadRadius: 2,
                                    // blurRadius: 7,
                                  ),
                                ]),
                            child: impStyle.impSubHeader(
                                '${searchedIndex! + 1}/${searchResults.length}',
                                textColor: Colors.white)),
                      impStyle.impHorizontalGap(horizontalGapSizeInPercent: 4),
                      impStyle.impIcon(Icons.more_vert, color: Colors.white),
                    ],
                  ), // "More" icon (three dots)
                ),
              ],
            ),
          ),

          // body
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: impStyle.sizes.horizontalBlockSize * 4.0),
              child: Stack(
                children: [
                  ScrollablePositionedList.builder(
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                    itemCount: widget.chatData.length,
                    itemBuilder: (context, index) {
                      return _messageBubble(widget.chatData[index], onTap: () {
                        setState(() {
                          if (tappedIndex.contains(index)) {
                            tappedIndex.remove(index);
                          } else {
                            tappedIndex.add(index);
                          }
                        });
                      });
                    },
                  ),
                  if (isScrolling)
                    Positioned(
                      top: impStyle.sizes.horizontalBlockSize,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    impStyle.sizes.horizontalBlockSize * 4.0,
                                vertical:
                                    impStyle.sizes.horizontalBlockSize * 1.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    impStyle.sizes.textMultiplier * 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.grey.shade800.withOpacity(0.6),
                                    spreadRadius: 2,
                                    // blurRadius: 7,
                                  ),
                                ]),
                            child: impStyle.impSubHeader(visibleDate,
                                textColor: Colors.white)),
                      ),
                    ),
                  if (showScrollButton)
                    Positioned(
                      bottom: impStyle.sizes.horizontalBlockSize * 4.0,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: scrollToBottom,
                        child: Container(
                          padding: EdgeInsets.all(
                              impStyle.sizes.horizontalBlockSize * 2.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white10,
                          ),
                          child: impStyle.impIcon(Icons.arrow_downward_rounded,
                              color: Colors.white),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),

          if (isSearchingOpen)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: impStyle.sizes.horizontalBlockSize * 4.0,
                  vertical: impStyle.sizes.horizontalBlockSize * 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: impStyle.impTextField(
                        onChangedText: (text) {
                          setState(() => isEmpty = text.isEmpty);
                          searchForText(text);
                          if (text.isEmpty) {
                            setState(() {
                              searchedIndex = null;
                              searchResults.clear();
                            });
                          }
                        },
                        hintText: 'Search...',
                        controller: searchController,
                        focusNode: focusNode,
                        suffixIcon: !isEmpty ? Icons.cancel_outlined : null,
                        onSuffixIconPressed: () {
                          searchController.clear();
                          setState(() {
                            isEmpty = true;
                            searchedIndex = null;
                            searchResults.clear();
                          });
                        }),
                  ),
                  if (!isEmpty || searchResults.isNotEmpty)
                    impStyle.impHorizontalGap(horizontalGapSizeInPercent: 2),
                  if (!isEmpty || searchResults.isNotEmpty)
                    impStyle.impShadedIconButton(
                        onPressed: () {
                          if (searchResults.isNotEmpty) {
                            setState(() {
                              searchedIndex =
                                  (searchedIndex! + 1) % searchResults.length;
                            });
                            scrollToIndex(searchResults[searchedIndex!]);
                          } else {
                            searchForText(searchController.text);
                          }
                        },
                        icon: searchResults.isEmpty
                            ? Icons.search
                            : Icons.keyboard_arrow_down_outlined,
                        backgroundColor: Colors.grey.shade900),
                  if (isEmpty || searchResults.isNotEmpty)
                    impStyle.impHorizontalGap(horizontalGapSizeInPercent: 2),
                  if (isEmpty || searchResults.isNotEmpty)
                    impStyle.impShadedIconButton(
                        onPressed: () {
                          if (searchResults.isEmpty) {
                            setState(() => isSearchingOpen = false);
                            focusNode.unfocus();
                          } else {
                            setState(() {
                              searchedIndex =
                                  (searchedIndex! - 1) % searchResults.length;
                            });
                            scrollToIndex(searchResults[searchedIndex!]);
                          }
                        },
                        icon: searchResults.isEmpty
                            ? Icons.cancel_outlined
                            : Icons.keyboard_arrow_up_outlined,
                        backgroundColor: Colors.grey.shade900),
                ],
              ),
            ),
        ]),
      ),
    );
  }

  Widget _messageBubble(Map<String, String> data,
      {required VoidCallback onTap}) {
    return Align(
      alignment: widget.self == data['user']
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: widget.self == data['user']
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (widget.chatData.indexOf(data) == 0 ||
              (data['date'] != null &&
                  widget.chatData.indexOf(data) != 0 &&
                  data['date']! !=
                      widget.chatData[widget.chatData.indexOf(data) - 1]
                          ['date']))
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: impStyle.sizes.horizontalBlockSize * 4.0),
                padding: EdgeInsets.symmetric(
                    horizontal: impStyle.sizes.horizontalBlockSize * 4.5,
                    vertical: impStyle.sizes.horizontalBlockSize * 2.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(
                      impStyle.sizes.horizontalBlockSize * 4.0),
                ),
                child: impStyle.impSubHeader(data['date']!,
                    textColor: Colors.grey.shade600),
              ),
            ),
          GestureDetector(
            onTap: onTap,
            onLongPress: () =>
                Clipboard.setData(ClipboardData(text: data['message']!)),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: impStyle.sizes.screenWidth *
                    0.75, // Set max width as 70% of screen width
              ),
              margin: EdgeInsets.only(
                top: impStyle.sizes.horizontalBlockSize,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: impStyle.sizes.horizontalBlockSize * 4.0,
                  vertical: impStyle.sizes.horizontalBlockSize * 2.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: widget.self == data['user']
                        ? ImpColors.selfBubble
                        : ImpColors.otherBubble),
                borderRadius: BorderRadius.circular(
                    impStyle.sizes.horizontalBlockSize * 4.0),
              ),
              child: Column(
                crossAxisAlignment: widget.self == data['user']
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  _highlightSearchText(data),
                  if (Extraction.users.length > 2 &&
                      widget.self != data['user'])
                    impStyle.impSubHeader(
                      data['user']!,
                      textColor: Colors.deepPurpleAccent,
                      fontSize: impStyle.sizes.textMultiplier,
                    ),
                ],
              ),
            ),
          ),
          if (tappedIndex.contains(widget.chatData.indexOf(data)))
            Align(
              alignment: widget.self == data['user']
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: impStyle.sizes.horizontalBlockSize * 2.0,
                    vertical: impStyle.sizes.horizontalBlockSize),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      impStyle.impIcon(Icons.access_time,
                          color: ImpColors.appBar,
                          sizeOfIcon: 1.5 * impStyle.sizes.textMultiplier),
                      impStyle.impHorizontalGap(
                          horizontalGapSizeInPercent:
                              impStyle.sizes.horizontalBlockSize * 0.3),
                      impStyle.impSubHeader(data['time']!,
                          textColor: ImpColors.appBar),
                    ]),
              ),
            ),
          if (widget.chatData.indexOf(data) == widget.chatData.length - 1)
            SizedBox(
              height: impStyle.sizes.horizontalBlockSize * 4.0,
            ),
        ],
      ),
    );
  }

  Widget _highlightSearchText(Map<String, String> data) {
    if (searchController.text.isEmpty) {
      return impStyle.impSubHeader(data['message']!,
          textColor: widget.self == data['user']
              ? ImpColors.pureWhiteColor
              : ImpColors.pureBlackColor);
    }

    String lowerCaseMessage = data['message']!.toLowerCase();
    String lowerCaseSearch = searchController.text.toLowerCase();
    List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;

    while ((indexOfHighlight =
            lowerCaseMessage.indexOf(lowerCaseSearch, start)) !=
        -1) {
      if (indexOfHighlight > start) {
        // Add non-highlighted text
        spans.add(TextSpan(
            text: data['message']!.substring(start, indexOfHighlight),
            style: TextStyle(
              color: widget.self == data['user']
                  ? ImpColors.pureWhiteColor
                  : ImpColors.pureBlackColor,
            )));
      }

      // Add highlighted text
      spans.add(TextSpan(
          text: data['message']!.substring(
              indexOfHighlight, indexOfHighlight + lowerCaseSearch.length),
          style: TextStyle(
            backgroundColor:
                widget.self == data['user'] ? Colors.purple : Colors.yellow,
            color: widget.self == data['user']
                ? ImpColors.pureWhiteColor
                : ImpColors.pureBlackColor,
          )));

      // Move the start index
      start = indexOfHighlight + lowerCaseSearch.length;
    }

    // Add remaining text after the last highlight
    if (start < data['message']!.length) {
      spans.add(TextSpan(
          text: data['message']!.substring(start),
          style: TextStyle(
            color: widget.self == data['user']
                ? ImpColors.pureWhiteColor
                : ImpColors.pureBlackColor,
          )));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tappedIndex.clear();
    tappedIndex = [];
    Extraction.users.clear();
    Extraction.dates.clear();
    itemPositionsListener.itemPositions.removeListener(scrollListener);
  }

  void searchForText(String query) {
    searchResults.clear(); // Clear previous search results
    String lowerCaseQuery = query.toLowerCase();

    for (int i = 0; i < widget.chatData.length; i++) {
      String message = widget.chatData[i]['message']!.toLowerCase();

      if (message.contains(lowerCaseQuery)) {
        searchResults.add(i);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (searchResults.isNotEmpty) {
            scrollToIndex(searchResults.first);
            setState(() {
              searchedIndex = 0;
            });
          }
        });
      }
    }
    if (searchResults.isEmpty) showToast('No results found');
  }

  void scrollToIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void scrollToBottom() {
    itemScrollController.scrollTo(
      index: widget.chatData.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void scrollToTop() {
    itemScrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey.shade800,
        textColor: Colors.white,
        fontSize: impStyle.sizes.horizontalBlockSize * 2.5);
  }
}
