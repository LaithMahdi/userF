import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/OrderDetailsPage.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

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
        Uri.parse('http://10.0.2.2:3000/commande/getcommandebyuser/$userId'),
      );
      log("Base URL: ${response.request?.url}");

      if (response.statusCode == 200) {
        setState(() {
          log("----------------------------${response.body}");
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
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff19143b),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              log('Order: $orders');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OrderDetailsPage(order: orders[index])),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: const Color.fromARGB(255, 188, 186, 204),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: const Color(0xff19143b),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Order ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders[index]['produits'].length,
                    itemBuilder: (context, prodIndex) {
                      return ListTile(
                        title: Text(
                          orders[index]['produits'][prodIndex]['nomProduit'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
