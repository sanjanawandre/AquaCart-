import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageProducts extends StatefulWidget {
  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  List products = [];
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchProducts();
  }

  Future<void> _loadTokenAndFetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final allProducts = await ApiService.getProducts();
      setState(() => products = allProducts);
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  Future<void> _deleteProduct(int id) async {
    final result = await ApiService.deleteProduct(token, id);
    if (result['success'] == true) {
      _fetchProducts();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product deleted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? Center(child: Text("No products"))
        : ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(p['name']),
                  subtitle: Text("₹${p['price']} | Stock: ${p['stock']} | Seller: ${p['seller_id']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteProduct(p['id']),
                  ),
                ),
              );
            },
          );
  }
}
