import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ import
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic>  product;
  final Function(Map)? onAddToCart;
  final Function(Map)? onAddToWishlist;
  final String token;

  ProductDetailPage({required this.product,required this.token,this.onAddToCart, this.onAddToWishlist}); // ✅ token removed from constructor

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  TextEditingController quantityController = TextEditingController(text: "1");
  bool isLoading = false;
// ✅ token variable

  @override
  void initState() {
    super.initState();
     // ✅ load token on init
  }


  void placeOrder() async {
    int quantity = int.tryParse(quantityController.text) ?? 1;
    setState(() { isLoading = true; });

    try {
      var result = await ApiService.placeOrder(widget.product['id'], quantity, widget.token); // ✅ use token
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? "Order result")));
    } catch (e) {
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name'])),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: ₹${widget.product['price']}", style: TextStyle(fontSize: 18)),
            Text("Stock: ${widget.product['stock']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(controller: quantityController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Quantity")),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text("Add to Cart"),
                    onPressed: () {
                      final productData = {
                        'id': widget.product['id'],
                        'name': widget.product['name'],
                        'price': widget.product['price'],
                      };
                      Provider.of<CartProvider>(context, listen: false).addItem(productData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to Cart')),
                      );
                    },

   ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    child: Text("Add to Wishlist"),
                    onPressed: () {
                       Provider.of<WishlistProvider>(context, listen: false)
      .addToWishlist(widget.product);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Added to Wishlist")),
  );
},
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            isLoading ? CircularProgressIndicator() : ElevatedButton(child: Text("Place Order"), onPressed: placeOrder)
          ],
        ),
      ),
    );
  }
}
