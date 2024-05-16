import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ProductDetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<dynamic> favoriteProducts = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserIdFromSharedPrefs().then((_) {
      fetchFavoriteProducts();
    });
  }

  Future<void> getUserIdFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  Future<void> fetchFavoriteProducts() async {
    if (userId == null) {
      return;
    }

    final url = Uri.parse('http://127.0.0.1:3000/favoir/user/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;
        setState(() {
          favoriteProducts = responseData;
        });
      } else {
        print('Failed to load favorite products');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> removeFavoriteProduct(String productId) async {
    if (userId == null) {
      return;
    }

    final url = Uri.parse('http://127.0.0.1:3000/favoir/supprimer/$userId/$productId');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        setState(() {
          favoriteProducts = favoriteProducts.where((product) => product['produit']['_id'] != productId).toList();
        });
      } else {
        print('Failed to delete favorite product');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Color(0xff19143b),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: favoriteProducts.length,
        itemBuilder: (BuildContext context, int index) {
          final product = favoriteProducts[index]['produit'];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: product),
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  product['image'] != null
                      ? Center(
                        child: Image.network(
                          'http://127.0.0.1:3000/uploads/${product['image']}',
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const Text('Image non disponible');
                          },
                          width: MediaQuery.sizeOf(context).width * .4,
                          height: 100,
                        ),
                      )
                      : const Text('Image non disponible'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] ?? 'Nom indisponible',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${product['prix'] ?? 'Prix indisponible'} \dt',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await removeFavoriteProduct(product['_id']);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
