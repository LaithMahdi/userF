import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/OrderDetailsPage.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:3000/commande/getcommandebyuser/$userId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
        });
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle error
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff19143b),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(order: orders[index]),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Color.fromARGB(255, 188, 186, 204),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Color(0xff19143b),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Order ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orders[index]['produits'].length,
                    itemBuilder: (context, prodIndex) {
                      return ListTile(
                        title: Text(
                          orders[index]['produits'][prodIndex]['nomProduit'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
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
