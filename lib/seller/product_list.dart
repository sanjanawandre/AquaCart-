import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';
import 'add_product.dart';
import 'edit_product.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List products = [];
  String token = '';
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadTokenAndProducts();
  }

  Future<void> _loadTokenAndProducts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      userId = prefs.getInt('user_id');
    });
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final allProducts = await ApiService.getProducts();
      setState(() {
        products = allProducts.where((p) => p['seller_id'] == userId).toList();
      });
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  Future<void> _deleteProduct(int id) async {
    try {
      final result = await ApiService.deleteProduct(token, id);
      if (result['success'] == true) {
        _fetchProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product deleted successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Delete failed")),
        );
      }
    } catch (e) {
      print("Delete Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Products")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddProductPage()),
        ).then((value) {
          if (value == true) _fetchProducts();
        }),
      ),
      body: products.isEmpty
          ? Center(child: Text("No products added yet"))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(p['name']),
                    subtitle: Text("₹${p['price']} | Stock: ${p['stock']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditProductPage(product: p)),
                          ).then((value) {
                            if (value == true) _fetchProducts();
                          }),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(p['id']),
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
