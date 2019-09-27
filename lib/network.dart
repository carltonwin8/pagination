import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pagination/model.dart';

class API {
  final String url = "https://jsonplaceholder.typicode.com/photos";

  Future<List<Photo>> getPhotos(int albumId) async {
    var response = await http.get('$url?albumId=$albumId');
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((p) => Photo.fromJson(p)).toList();
  }
}
