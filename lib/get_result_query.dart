import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class GetResultQuery {
  String apiURL = "https://s.polarspetroll.repl.co/api?";
  String query;
  String queryType;

  GetResultQuery(this.query, this.queryType);

  Future<String> getResultQuery() async {
    apiURL += "method=$queryType&";
    apiURL += "data=$query";

    Response res = await get(Uri.parse(apiURL));

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      String result = body["data"];

      return result;
    } else {
      throw "Unable to retrieve data.";
    }
  }
}
