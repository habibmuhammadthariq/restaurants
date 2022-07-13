import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant/data/api/resto_api_service.dart';

void main() {
  test('Should contain restaurants list when "restaurants" function being called', () async {
    // arrange
    RestoApiService restoApiService = RestoApiService();
    // act
    var resto = await restoApiService.getAllResto();

    // assert
    var result = resto.count == 20;
    expect(result, true);
  });
}