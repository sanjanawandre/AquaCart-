import 'package:aquacart/screens/product_detail_page.dart';
import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterSearchPage extends StatefulWidget {
  @override
  _FilterSearchPageState createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  List products = [];
  List filteredProducts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  void fetchProducts() async {
    try {
      var data = await ApiService.getProducts();
      setState(() { products = data; filteredProducts = data; isLoading = false; });
    } catch (e) {
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void filterProducts(String query) {
    List filtered = products.where((p) => p['name'].toLowerCase().contains(query.toLowerCase())).toList();
    setState(() { filteredProducts = filtered; });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search & Filter")),
      body: isLoading ? Center(child: CircularProgressIndicator()) :
      Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by product name",
                suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: () => filterProducts(searchController.text)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index){
                var product = filteredProducts[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text("₹${product['price']} | Stock: ${product['stock']}"),
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String token = prefs.getString('jwt_token') ?? "";
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product, token:token)));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
