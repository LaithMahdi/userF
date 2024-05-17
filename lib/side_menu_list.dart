import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:user/OrdersPage.dart';
import 'package:user/TestColorsScreen.dart';
import 'package:user/core/constant/app_cache.dart';

class SideMenuList extends StatelessWidget {
  final GlobalKey<SideMenuState> menuKey;
  final Function(String) getProduitsByCat;
  final Function() getAllProduits;
  final BuildContext context;

  const SideMenuList({
    super.key,
    required this.menuKey,
    required this.getProduitsByCat,
    required this.getAllProduits,
    required this.context,
  });

  Future<List<dynamic>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/categorie/getall'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: ListView(
        children: [
          ListTile(
            leading: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const Divider(
            color: Colors.black54,
          ),
          const SizedBox(
            height: 18,
          ),
          buttonDecoration(
            name: 'Home',
            iconData: Icons.home,
            boxColor: Colors.grey.shade300,
            onTap: () {
              getAllProduits();
              if (menuKey.currentState!.isOpened) {
                menuKey.currentState!.closeSideMenu();
              } else {
                menuKey.currentState!.openSideMenu();
              }
            },
          ),
          const SizedBox(
            height: 40,
          ),
          buttonDecoration(
            name: 'Favorites',
            iconData: Icons.favorite,
            boxColor: Colors.transparent,
            onTap: () {},
          ),
          const SizedBox(
            height: 40,
          ),
          buttonDecoration(
            name: 'My orders',
            iconData: Icons.shopping_bag,
            boxColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersPage()),
              );
            },
          ),
          const SizedBox(
            height: 40,
          ),
          buttonDecoration(
            name: 'Test Colors',
            iconData: Icons.camera_alt,
            boxColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestColorsScreen(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 40,
          ),
          ExpansionTile(
            title: const Row(
              children: [
                Icon(
                  Icons.category,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Categories',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
            children: [
              FutureBuilder<List<dynamic>>(
                future: fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: List.generate(snapshot.data!.length, (index) {
                        return ListTile(
                          title: Text(
                            snapshot.data![index]['name'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            getProduitsByCat(snapshot.data![index]['_id']);
                          },
                        );
                      }),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 34,
          ),
          const Divider(
            color: Colors.black54,
          ),
          const SizedBox(
            height: 40,
          ),
          buttonDecoration(
            name: 'LogOut',
            iconData: Icons.logout,
            boxColor: Colors.transparent,
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  buttonDecoration({
    required String name,
    required IconData iconData,
    required VoidCallback onTap,
    required Color boxColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: boxColor,
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 28,
              color: Colors.white,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  void _logout() async {
    AppCache().clearCache();
    Navigator.pushReplacementNamed(context, '/');
  }
}
