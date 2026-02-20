import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'package:aquacart/screens/product_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CategoryProductsScreen extends StatefulWidget {
  final String category;

  CategoryProductsScreen({required this.category});

  @override
  _CategoryProductsScreenState createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List products = [];
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    fetchCategoryProducts();
  }
  void _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('user_token') ?? '';
    });
  }


  void fetchCategoryProducts() async {
    try {
      var allProducts = await ApiService.getProducts();
      setState(() {
        products = allProducts
            .where((p) =>
                (p['category']?.toString().toLowerCase() ?? '') ==
                widget.category.toLowerCase())
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(child: Text("No products found in this category"))
              : GridView.builder(
                  padding: EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var product = products[index];
                    return GestureDetector(
                      onTap: () {
                        if(token!=null && token!.isNotEmpty){
                          final currentToken = token!;
                        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ProductDetailPage(
      product: product,
      token: currentToken, // TODO: fetch token if required
      onAddToCart: (prod) {
        // you can connect this later to your cart logic
      },
      onAddToWishlist: (prod) {
        // you can connect this later to your wishlist logic
      },
    ),
  ),
);
} else {
    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(content: Text("Token not loaded yet")),
    );
  }
},


                      
                      child: Card(
                        child: Column(
                          children: [
                            Expanded(
                              child: Icon(Icons.image,
                                  size: 60, color: Colors.blueAccent),
                            ),
                            Text(product['name'] ?? "No name"),
                            Text("₹${product['price'] ?? 0}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
