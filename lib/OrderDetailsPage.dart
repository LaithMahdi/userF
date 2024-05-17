import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderDetailsPage extends StatelessWidget {
  final dynamic order;

  const OrderDetailsPage({super.key, required this.order});

  static String getOrderID(dynamic order) {
    if (order != null && order['_id'] != null) {
      return order['_id'].toString();
    } else {
      return '';
    }
  }

  Future<void> cancelOrder(BuildContext context, String commandeId) async {
    try {
      if (commandeId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID de commande invalide')),
        );
        return;
      }
      log('Commande ID: $commandeId');

      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/commande/commandeannuler/$commandeId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Commande annulée avec succès')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erreur lors de l\'annulation de la commande')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une erreur s\'est produite')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String commandeId = getOrderID(order);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff19143b),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: order != null
          ? Center(
              child: Container(
                color: const Color.fromARGB(255, 188, 186, 204),
                child: Center(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Order Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xff19143b),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: order['produits'].length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    order['produits'][index]['nomProduit'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Quantity: ${order['produits'][index]['quantite']}',
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Total: ${order['total']} Dt',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Date: ${order['Date']}',
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Center(child: Text('Aucune commande trouvée')),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 188, 186, 204),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              cancelOrder(context, order['_id']);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xff19143b),
            ),
            child: const Text('Annuler la commande'),
          ),
        ),
      ),
    );
  }
}
