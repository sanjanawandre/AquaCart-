import 'package:flutter/material.dart';
import 'add_product.dart';
import 'edit_product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  // Dummy product list
  List<Map<String, dynamic>> products = [
    {"id": 1, "name": "Goldfish", "price": 150, "stock": 20},
    {"id": 2, "name": "Betta Fish", "price": 250, "stock": 15},
    {"id": 3, "name": "Aquarium Plant", "price": 50, "stock": 50},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProduct()),
              );
            },
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']),
            subtitle: Text("Price: ₹${product['price']} | Stock: ${product['stock']}"),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProduct(product: product),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
