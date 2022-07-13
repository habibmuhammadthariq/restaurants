import 'package:flutter/material.dart';

import '../data/api/resto_api_service.dart';
import '../data/model/search_restaurant.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestoSearchProvider extends ChangeNotifier {

  final restoApiService = RestoApiService();

  RestoSearchProvider() {
    _state = ResultState.Loading;
  }

  late SearchResto _restoResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  SearchResto get result => _restoResult;
  ResultState get state => _state;

  Future<dynamic> _fetchRestaurantByQuery(String searchString) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();

      final restaurant = await restoApiService.findResto(searchString);
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
      return _message = 'Gagal mendapatkan data ';
    }
  }

  void findRestaurant(String searchString) {
    _fetchRestaurantByQuery(searchString);
    notifyListeners();
  }

}