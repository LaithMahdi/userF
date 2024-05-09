import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ProductDetailsPage.dart';
import 'side_menu_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();

  List<dynamic> produits = [];
  List<dynamic> filteredProduits = [];
  String? userId;
  TextEditingController searchController = TextEditingController();

  Future<void> getAllProduits() async {
    final url = Uri.parse('http://127.0.0.1:3000/produit/all');

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as List<dynamic>;
      setState(() {
        produits = responseData.map((produit) {
          produit['isFavorite'] = false;
          return produit;
        }).toList();
        filteredProduits = produits;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllProduits();
    getUserIdFromSharedPrefs();
     WidgetsBinding.instance!.addPostFrameCallback((_) {
    showLikeDialog(); // Appelez showLikeDialog ici directement
  });
  }
void showLikeDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool isLiked = false; // État initial

      return AlertDialog(
        title: Text('Do you like our application?'),
        actions: [
          IconButton(
            icon: Icon(Icons.thumb_up, color: Colors.green, size: 30), // Modifier la couleur en vert
            onPressed: () {
              // Mettre à jour l'état d'appréciation dans la base de données
              updateLikeStatus(true); // Envoyer true pour liked
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Merci pour votre avis'),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.thumb_down, color: Colors.red, size: 30), // Modifier la couleur en rouge
            onPressed: () {
              // Mettre à jour l'état d'appréciation dans la base de données
              updateLikeStatus(false); // Envoyer false pour liked
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Merci pour votre avis'),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}



 Future<void> updateLikeStatus(bool liked) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userId = prefs.getString('userId'); // Utilisez la variable de classe userId

  final url = Uri.parse('http://127.0.0.1:3000/user/feedback');
  final body = json.encode({'userId': userId, 'liked': liked});

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final responseData = json.decode(response.body);
    print(responseData['message']);
  } catch (error) {
    print(error);
  }
}


  Future<void> getUserIdFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  void searchProduits(String query) {
    setState(() {
      filteredProduits = produits.where((produit) =>
          produit['name'].toString().toLowerCase().contains(query.toLowerCase())).toList();
    });
  }




  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: sideMenuKey,
      background: Color(0xff19143b),
      menu: SideMenuList(
        menuKey: sideMenuKey,
        getProduitsByCat: getProduitsByCat,
        getAllProduits: getAllProduits,
        context: context,
      ),
      maxMenuWidth: 370,
      type: SideMenuType.slideNRotate,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.white,
          leading: IconButton(
            splashColor: Colors.white,
            iconSize: 32,
            onPressed: () {
              if (sideMenuKey.currentState!.isOpened) {
                sideMenuKey.currentState!.closeSideMenu();
              } else {
                sideMenuKey.currentState!.openSideMenu();
              }
            },
            icon: Icon(Icons.menu),
          ),
          title: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xff19143b).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            searchProduits(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Color(0xff19143b),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: GNav(
              backgroundColor: Color(0xff19143b),
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              gap: 8,
              padding: EdgeInsets.all(16),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.favorite,
                  text: 'Likes',
                ),
                GButton(
                  icon: Icons.shopping_cart,
                  text: 'My cart',
                ),
                GButton(
                  icon: Icons.feedback,
                  text: 'Feedbacks',
                )
              ],
              selectedIndex: 0,
              onTabChange: (index) {
                if (index == 3) {
                  showFeedbackDialog();
                } else if (index == 1) {
                  filterProductsByFavorites();
                } else if (index == 0) {
                  getAllProduits();
                }
              },
            ),
          ),
        ),
        body: GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredProduits.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product: filteredProduits[index]),
                  ),
                );
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    filteredProduits[index]['image'] != null
                        ? Center(
                          child: Image.network(
                              'http://127.0.0.1:3000/uploads/${filteredProduits[index]['image']}',
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
                            filteredProduits[index]['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${filteredProduits[index]['prix']} \dt',
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
                            filteredProduits[index]['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                            color: filteredProduits[index]['isFavorite'] ? Colors.red : null,
                          ),
                          onPressed: () async {
                            setState(() {
                              filteredProduits[index]['isFavorite'] = !filteredProduits[index]['isFavorite'];
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            // Add the product to the cart
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
      ),
    );
  }

  void showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String feedbackText = '';

        return AlertDialog(
          title: Text('Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  feedbackText = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your feedback...',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  addFeedback(feedbackText);
                  Navigator.of(context).pop();
                },
                child: Text('Send'),
              ),
            ],
          ),
        );
      },
    );
  }

  void filterProductsByFavorites() {
    setState(() {
      filteredProduits = produits.where((produit) => produit['isFavorite'] == true).toList();
    });
  }

  Future<void> getProduitsByCat(String categoryId) async {
    final url = Uri.parse('http://127.0.0.1:3000/produit/getbycat/$categoryId');

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as List<dynamic>;
      setState(() {
        produits = responseData.map((produit) {
          produit['isFavorite'] = false;
          return produit;
        }).toList();
        filteredProduits = produits;
      });
    } catch (error) {
      print(error);
    }
  }









Future<void> addFeedback(String feedbackText) async {
  final url = Uri.parse('http://127.0.0.1:3000/feedback/add');
  final body = json.encode({'userId': userId, 'feedbackText': feedbackText});

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    final responseData = json.decode(response.body);
    print(responseData['message']);
    
    // Afficher une alerte de succès
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Feedback sent successfully'),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 153, 175, 154),
      ),
    );
  } catch (error) {
    print(error);
  }
}

  }

