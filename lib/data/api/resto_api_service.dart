import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/data/model/restaurant.dart';

import '../model/restaurant_detail.dart';
import '../model/search_restaurant.dart';

class RestoApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<Resto> getAllResto() async {
    final response = await http.get(Uri.parse('${_baseUrl}list'));

    if (response.statusCode == 200) {
      return Resto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Restaurants list');
    }
  }

  Future<DetailResto> getRestoDetail(String id) async {
    final response = await http.get(Uri.parse('${_baseUrl}detail/$id'));

    if (response.statusCode == 200) {
      return DetailResto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Restaurants Detail');
    }
  }


  Future<SearchResto> findResto(String text) async {
    final response = await http.get(Uri.parse('${_baseUrl}search?q=$text'));

    if (response.statusCode == 200) {
      return SearchResto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Restaurants Detail');
    }
  }
}
