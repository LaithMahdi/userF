import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Your order has been placed successfully."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    final response = await http.post(
      Uri.parse('http://127.0.0.1:3000/commande/passer-commande'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': userId,
        'produits': [
          {'produit': widget.product['_id'], 'quantite': _quantity}
        ],
      }),
    );

    if (response.statusCode == 201) {
      // Afficher l'alerte de succès si la commande est passée avec succès
      _showSuccessAlert();
    } else {
      // Gérer les erreurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff19143b),
        title: Text(
          'Product Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 188, 186, 204),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.product['image'] != null 
                ? Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage('http://127.0.0.1:3000/uploads/${widget.product['image']}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
              SizedBox(height: 20),
              Text(
                widget.product['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xff19143b)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Price: ${widget.product['prix']} DT',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff19143b)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                widget.product['description'],
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Quantity: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff19143b)),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (_quantity > 1) {
                          _quantity--;
                        }
                      });
                    },
                  ),
                  Text(
                    _quantity.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff19143b)),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff19143b),
                  ),
                  child: Text('Place Order', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
