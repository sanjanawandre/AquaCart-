import 'package:aquacart/screens/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class WishlistScreen extends StatefulWidget {
  final List<Map<String,dynamic>> wishlistItems;
  WishlistScreen({required this.wishlistItems});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String token='';
  void initState() {
    super.initState();
    _loadToken(); // ✅ Load token
  }

  void _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('user_token') ?? '';
    });
  }
  
  
  void removeItem(int index) {
    setState(() {
      widget.wishlistItems.removeAt(index);
    });
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wishlist")),
      body: widget.wishlistItems.isEmpty
          ? Center(child: Text("Your wishlist is empty"))
          : ListView.builder(
              itemCount: widget.wishlistItems.length,
              itemBuilder: (context, index) {
                var item = widget.wishlistItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text("₹${item['price']}"),
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => removeItem(index)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: item, token:token)));
                  },
                );
              },
            ),
    );
  }
}
