import 'package:flutter/material.dart';
import 'package:restaurant/data/api/resto_api_service.dart';
import 'package:restaurant/data/model/restaurant.dart';

import '../data/database/db.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestoProvider extends ChangeNotifier {
  final RestoApiService restoApiService;

  List<Restaurant> _restaurants = [];
  late DatabaseHelper _dbHelper;

  RestoProvider({ required this.restoApiService }) {
    _fetchAllRestaurants();

    _dbHelper = DatabaseHelper();
    _getAllRestaurants();

    // -- temp
    /*Restaurant resto = new Restaurant(
        id: "rqdv5juczeskfw1e867",
        name: "Melting Pot",
        description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
        pictureId: "14",
        city: "Medan",
        rating: 4.2
    );
    addResto(resto);*/
    // ---
  }

  late Resto _restoResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  Resto get result => _restoResult;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurants() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();

      final restaurant = await restoApiService.getAllResto();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restoResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Gagal mendapatkan data';//'$e'; //
    }
  }

  // Db Provider
  List<Restaurant> get restaurants => _restaurants;

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

  // returning bool variable if data found
  getRestoById(String id) {
    return _restaurants.map((item) => item.id).contains(id);
  }
}
