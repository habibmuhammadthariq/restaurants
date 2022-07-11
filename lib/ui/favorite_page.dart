import 'package:flutter/material.dart';
import 'package:restaurant/ui/restaurant_detail_Page.dart';
import '../data/model/restaurant.dart';

class FavoritePage extends StatelessWidget {
  static const routeName = 'favorite_page';

  final List<Restaurant> restaurant;
  const FavoritePage({ Key? key, required this.restaurant }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Favorite '),),
      body: ListView.builder(
        itemCount: restaurant.length,
          itemBuilder: (context, index) {
            return _buildRestaurantItem(context, restaurant[index]);
          }
      ),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: Hero(
        tag: 'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
        child: Image.network(
          'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
          width: 100,
        ),
      ),
      title: Text(
          restaurant.name
      ),
      subtitle: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.location_pin,
                color: Colors.grey,
                size: 20,
              ),
              Text(restaurant.city)
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.grey,
                size: 20,
              ),
              Text(restaurant.rating.toString())
            ],
          )
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetailPage.routeName, arguments: restaurant.id);
      },
    );
  }
}