import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/data/model/search_restaurant.dart';

class SearchApiService {
  // final String query;
  // const SearchApiService({ required this.query });

  Future<SearchResto> topHeadlines(String text) async {
    final String baseUrl = 'https://restaurant-api.dicoding.dev/search?q=$text';
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return SearchResto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Restaurants Detail');
    }
  }
}
