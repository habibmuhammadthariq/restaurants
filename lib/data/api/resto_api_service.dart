import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/data/model/restaurant.dart';

class RestoApiService {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/list';

  Future<Resto> topHeadlines() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      return Resto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Restaurants list');
    }
  }
}
