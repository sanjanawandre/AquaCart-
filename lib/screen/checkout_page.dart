import 'package:flutter/material.dart';
import 'payment_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map> cartItems;
  final Function? onOrderPlaced;

  CheckoutPage({required this.cartItems, this.onOrderPlaced});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double get totalPrice =>
      widget.cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));

  void proceedToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          amount: totalPrice,
          cartItems: widget.cartItems,
          onPaymentSuccess: (order) {
            if (widget.onOrderPlaced != null) widget.onOrderPlaced!(order);
            widget.cartItems.clear(); // clear cart after successful payment
            Navigator.popUntil(context, (route) => route.isFirst); // back to dashboard
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  var item = widget.cartItems[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text("₹${item['price']} x ${item['quantity']}"),
                  );
                },
              ),
            ),
            Text(
              "Total: ₹$totalPrice",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: proceedToPayment,
              child: Text("Proceed to Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
