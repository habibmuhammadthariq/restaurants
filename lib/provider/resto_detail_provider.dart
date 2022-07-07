import 'package:flutter/material.dart';
import 'package:restaurant/data/model/restaurant_detail.dart';

import '../data/api/resto_api_service.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestoDetailProvider extends ChangeNotifier {
  final restoApiService = RestoApiService();
  final String id;

  RestoDetailProvider({required this.id}) {
    _fetchRestaurantDetail();
  }

  late DetailResto _detailResto;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  DetailResto get result => _detailResto;
  ResultState get state => _state;

  Future<dynamic> _fetchRestaurantDetail() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();

      final detailRestaurant = await restoApiService.getRestoDetail(id);
      if (detailRestaurant.restaurant.id.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _detailResto = detailRestaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Gagal mendapatkan data';
    }
  }
}