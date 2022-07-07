import 'package:flutter/material.dart';
import 'package:restaurant/data/api/resto_search_service.dart';

import '../data/model/search_restaurant.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestoSearchProvider extends ChangeNotifier {
  static var searchApiService = SearchApiService();

  RestoSearchProvider() {
    // _fetchAllRestaurants();
    _state = ResultState.Loading;
  }

  late String _searchString = '';

  late SearchResto _restoResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  SearchResto get result => _restoResult;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurants() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();

      final restaurant = await searchApiService.topHeadlines(_searchString);
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
      return _message = 'Error --> $e';
    }
  }

  void changeSearchString(String searchString) {
    _searchString = searchString;
    _fetchAllRestaurants();
    notifyListeners();
  }

}