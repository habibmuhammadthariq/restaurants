import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/provider/resto_provider.dart';
import 'package:restaurant/ui/restaurant_detail_Page.dart';
import 'package:restaurant/ui/search_page.dart';

class RestaurantListPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.routeName);
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Consumer<RestoProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.Loading) {
              return Center(child: CircularProgressIndicator(),);
            } else if (state.state == ResultState.HasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.result.count,
                itemBuilder: (context, index) {
                  // var restaurant = state.result.restaurants[index];
                  return _buildRestaurantItem(context, state.result.restaurants[index]);
                },
              );
            } else if (state.state == ResultState.NoData) {
              return Center(child: Text(state.message),);
            } else if (state.state == ResultState.Error) {
              return Center(child: Text(state.message),);
            } else {
              return Center(child: Text(''),);
            }
          }
      )
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      // isThreeLine: true,
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

