import 'dart:convert';
import 'package:http/http.dart';
import 'package:convert/convert.dart';
import 'package:intl/intl.dart';

//class of api containing all websites
class ContestSites {
  Future<dynamic> getSitesList() async {
    try {
      //make api request
      Response response =
          await get(Uri.parse("https://kontests.net/api/v1/sites"));
      // print(response.body);
      var lists = json.decode(response.body);
      return lists;
    } catch (e) {
      print("Error Occured");
      return [];
    }
  }
}
