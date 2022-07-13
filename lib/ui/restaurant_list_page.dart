import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/provider/resto_provider.dart';
import 'package:restaurant/ui/favorite_page.dart';
import 'package:restaurant/ui/restaurant_detail_Page.dart';
import 'package:restaurant/ui/search_page.dart';

import '../main.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  late List<Restaurant> _restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant List'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, FavoritePage.routeName, arguments: _restaurant);
              },
              icon: const Icon(
                  Icons.favorite,
                color: Colors.pink,
              )
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.routeName);
              },
              icon: const Icon(Icons.search)
          ),
        ],
      ),
      body: Consumer<RestoProvider>(
          builder: (context, state, _) {
            _restaurant = state.restaurants;

            if (state.state == ResultState.Loading) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (state.state == ResultState.HasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.result.count,
                itemBuilder: (context, index) {
                  // print('Nilainya apa nih ${state.getRestoById(state.result.restaurants[index].id)}');
                  return ModuleTile(
                    restaurant: state.result.restaurants[index],
                    // restoProvider: state,
                    isFavorite: Provider.of<RestoProvider>(context, listen: false).getRestoById(state.result.restaurants[index].id),
                    onClick: Provider.of<RestoProvider>(context, listen: false).getRestoById(state.result.restaurants[index].id)
                        ? () {
                            setState(() {
                              Provider.of<RestoProvider>(context, listen: false).deleteResto(state.result.restaurants[index].id);
                            });
                            print('kapan nih giliranku gan');
                          }
                        : () {
                            setState(() {
                              Provider.of<RestoProvider>(context, listen: false).addResto(state.result.restaurants[index]);
                            });
                            print('Yeay, akhirnya aku dipanggil');
                          },
                  );
                }
              );
            } else if (state.state == ResultState.NoData) {
              return Center(child: Text(state.message),);
            } else if (state.state == ResultState.Error) {
              return Center(child: Text(state.message),);
            } else {
              return const Center(child: Text(''),);
            }
          }
      )
    );
  }
}

class ModuleTile extends StatelessWidget {
  final Restaurant restaurant;
  // final RestoProvider restoProvider;
  final bool isFavorite;
  final Function() onClick;

  const ModuleTile({
    Key? key,
    required this.restaurant,
    // required this.restoProvider
    required this.isFavorite,
    required this.onClick
  }) : super(key: key);


  Widget build(BuildContext context) {
    return ListTile(
      // isThreeLine: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      trailing: IconButton(
        onPressed: onClick,
        icon: const Icon(Icons.favorite),
        color: isFavorite
            ?  Colors.pink
            : Colors.grey,
      ),
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
              const Icon(
                Icons.location_pin,
                color: Colors.grey,
                size: 20,
              ),
              Text(restaurant.city)
            ],
          ),
          Row(
            children: [
              const Icon(
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

