import 'package:flutter/material.dart';
import 'package:restaurant/data/api/resto_api_service.dart';
import 'package:restaurant/data/model/restaurant.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestoProvider extends ChangeNotifier {
  final RestoApiService restoApiService;

  RestoProvider({ required this.restoApiService }) {
    _fetchAllRestaurants();
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

      final restaurant = await restoApiService.topHeadlines();
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
}