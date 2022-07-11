import 'package:flutter/material.dart';
import 'package:restaurant/data/database/db.dart';

import '../data/model/restaurant.dart';

class DbProvider extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  late DatabaseHelper _dbHelper;

  List<Restaurant> get Restaurants => _restaurants;

  DbProvider() {
    _dbHelper = DatabaseHelper();
    _getAllRestaurants();
  }

  void _getAllRestaurants() async {
    _restaurants = await _dbHelper.getResto();
    notifyListeners();
  }

  Future<void> addResto(Restaurant restaurant) async {
    await _dbHelper.insertResto(restaurant);
    _getAllRestaurants();
  }

  void deleteResto(String id) async {
    await _dbHelper.deleteRestaurant(id);
    _getAllRestaurants();
  }
}