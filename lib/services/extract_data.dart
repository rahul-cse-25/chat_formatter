import 'package:chat_formatter/config/debug_purpose.dart';

class Extraction {
  static Set<String> users = {};
  static Set<String> dates = {};


  static List<Map<String, String>>? extractData({required String fileContent}) {
    try {
      // Define the RegExp pattern for the valid message format
      RegExp regExp = RegExp(
        r'(\d{1,2}/\d{1,2}/\d{4}), (\d{1,2}:\d{2}\s?[ap]m) - (.*?): (.*?)(?=\n\d{1,2}/\d{1,2}/\d{4}, \d{1,2}:\d{2}\s?[ap]m|$)',
        dotAll: true,
      );

      // Split the content by line to process it
      List<String> lines = fileContent.split('\n');

      // Filter out system messages or invalid lines that don't match the pattern
      List<String> validLines = lines.where((line) {
        return regExp.hasMatch(line);
      }).toList();

      // Iterate over the valid lines and extract matches
      List<Map<String, String>> extractedMessages = [];

      for (String line in validLines) {
        Iterable<RegExpMatch> matches = regExp.allMatches(line);

        for (var match in matches) {
          users.add(match.group(3)!);
          dates.add(match.group(1)!);
          extractedMessages.add({
            'date': match.group(1)!,
            'time': match.group(2)!,
            'user': match.group(3)!,
            'message': match.group(4)!,
          });
        }
      }

      return extractedMessages;
    } catch (e) {
      printRed('Error while Extracting the data: $e');
    }
    return null;
  }
}
