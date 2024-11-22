import 'package:chat_formatter/config/colors.dart';
import 'package:chat_formatter/config/customize_style.dart';
import 'package:chat_formatter/config/debug_purpose.dart';
import 'package:chat_formatter/services/extract_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Chat extends StatefulWidget {
  final String self;
  final List<Map<String, String>> chatData;

  const Chat({super.key, required this.chatData, required this.self});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ImpCustomizeStyle impStyle = ImpCustomizeStyle();
  List<int> tappedIndex = [];
  String otherUser = '';
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  bool showScrollButton = true;
  bool isSearchingOpen = false;
  FocusNode focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  bool isEmpty = true;
  List<int> searchResults = [];
  int? searchedIndex;

  @override
  void initState() {
    super.initState();
    for (String user in Extraction.users) {
      if (user != widget.self) {
        otherUser = user;
      }
    }
    for (String date in Extraction.dates) {
      printYellow(date);
    }
    itemPositionsListener.itemPositions.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    tappedIndex.clear();
    tappedIndex = [];
    Extraction.users.clear();
    Extraction.dates.clear();
    itemPositionsListener.itemPositions.removeListener(scrollListener);
    // scrollController.dispose();
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

  void scrollListener() {
    // Get the list of currently visible items
    final visibleItems = itemPositionsListener.itemPositions.value;

    // Find the first visible item (minimum index)
    int firstVisibleIndex = visibleItems
        .where((position) => position.itemLeadingEdge >= 0)
        .map((position) => position.index)
        .reduce((min, index) => index < min ? index : min);

    // Calculate the remaining bubbles
    int remainingItems = widget.chatData.length - firstVisibleIndex - 1;

    setState(() {
      // If there are 100 or more bubbles below, show the button
      showScrollButton = remainingItems >= 100;
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void searchForText(String query) {
    searchResults.clear(); // Clear previous search results
    String lowerCaseQuery = query.toLowerCase();

    for (int i = 0; i < widget.chatData.length; i++) {
      String message = widget.chatData[i]['message']!.toLowerCase();

      if (message.contains(lowerCaseQuery)) {
        searchResults.add(i);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToIndex(searchResults.first);
          searchedIndex = 0;
        });
      }
    }

    printYellow(searchResults);
    setState(() {});
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
                          child: impStyle.impHeader(otherUser,
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
                    return {'Go to Top', 'Search', 'More'}.map((String choice) {
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
                  icon: impStyle.impIcon(Icons.more_vert,
                      color: Colors.white), // "More" icon (three dots)
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
                        },
                        hintText: 'Search...',
                        controller: searchController,
                        focusNode: focusNode,
                        suffixIcon: !isEmpty ? Icons.cancel_outlined : null,
                        onSuffixIconPressed: () {
                          searchController.clear();
                          setState(() {
                            isEmpty = true;
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
                            searchedIndex =
                                (searchedIndex! + 1) % searchResults.length;
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
                            searchedIndex =
                                (searchedIndex! - 1) % searchResults.length;
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
                  bottom: widget.chatData.indexOf(data) ==
                          widget.chatData.length - 1
                      ? impStyle.sizes.horizontalBlockSize * 2
                      : 0),
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
              child: impStyle.impSubHeader(data['message']!,
                  textColor: widget.self == data['user']
                      ? ImpColors.pureWhiteColor
                      : ImpColors.pureBlackColor),
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
        ],
      ),
    );
  }

}
