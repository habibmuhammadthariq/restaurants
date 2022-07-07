import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/model/search_restaurant.dart';
import 'package:restaurant/provider/resto_search_provider.dart';
import 'package:restaurant/ui/restaurant_detail_Page.dart';

class SearchPage extends StatelessWidget {
  static const routeName = 'search_page';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestoSearchProvider(),
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(title: Text('Restaurant App')),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.0)
                        )
                    ),
                    hintText: 'Cari berdasarkan nama, kategori atau menu',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (String value) {
                    Provider.of<RestoSearchProvider>(context, listen: false).findRestaurant(value);
                  },
                ),
                Expanded(
                    child: Consumer<RestoSearchProvider>(
                      builder: (context, state, _) {
                        if (state.state == ResultState.Loading) {
                          return Center(
                            child: Icon(
                              Icons.search_rounded,
                              size: 100,
                            ),
                          );
                        } else if (state.state == ResultState.HasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.result.founded,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 3,
                                child: _buildRestaurantItem(context, state.result.restaurants[index]),
                              );
                            },
                          );
                        } else if (state.state == ResultState.NoData) {
                          return Center(child: Text(state.message),);
                        } else if (state.state == ResultState.Error) {
                          return Center(child: Text(state.message),);
                        } else {
                          return Center(child: Text(''),);
                        }
                      },
                    ),
                )

              ],
            )
        );
      },
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
