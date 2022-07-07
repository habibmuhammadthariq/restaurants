import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/data/model/restaurant_detail.dart';

class RestoDetailApi {
  final String id;
  const RestoDetailApi({ required this.id });


  Future<DetailResto> topHeadlines() async {
    final String _baseUrl = 'https://restaurant-api.dicoding.dev/detail/$id';
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      return DetailResto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Restaurants Detail');
    }
  }
}
