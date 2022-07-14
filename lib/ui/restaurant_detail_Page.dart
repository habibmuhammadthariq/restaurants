import 'package:flutter/material.dart';
import 'package:restaurant/data/model/restaurant_detail.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/resto_detail_provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final String id;
  const RestaurantDetailPage({ required this.id });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestoDetailProvider>(
      create: (_) => RestoDetailProvider(id: id),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant Detail'),
        ),
        body: Consumer<RestoDetailProvider>(
            builder: (context, state, _) {
              if (state.state == ResultState.Loading) {
                return const Center(child: CircularProgressIndicator(),);
              } else if (state.state == ResultState.HasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return _buildRestaurantDetail(context, state.result.restaurant);
                  },
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
      )
    );
  }

  Widget _buildRestaurantDetail(BuildContext context, RestaurantDetail restaurant) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Hero(tag: 'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
              child: Image.network('https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}')),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Restaurant Name : ${restaurant.name}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Center(
                  child: Text(
                    'Location : ${restaurant.city}',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    'Rating : ${restaurant.rating}',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'Deskripsi',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  restaurant.description,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Foods Menu',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Container(
                                height: 120,
                                child: ListView.builder(
                                    itemCount: restaurant.menus.foods.length,
                                    itemBuilder: (context, index) {
                                      return Text(''
                                        '${index+1}. ${restaurant.menus.foods[index].name}'
                                      );
                                    }
                                )
                            ),
                          ],
                        )
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Drinks Menu',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Container(
                                height: 120,
                                child: ListView.builder(
                                    itemCount: restaurant.menus.drinks.length,
                                    itemBuilder: (context, index) {
                                      return Text(''
                                        '${index+1}. ${restaurant.menus.drinks[index].name}'
                                      );
                                    }
                                )
                            )
                          ],
                        )
                    )
                  ],
                ),
                const SizedBox(height: 8,)
              ],
            ),)
        ],
      ),
    );
  }
}