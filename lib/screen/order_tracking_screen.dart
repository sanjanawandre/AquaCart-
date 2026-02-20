import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Map order;
  OrderTrackingScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    List items = order['items'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text("Track Order #${order['id']}")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: ${order['status']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Items:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text("Quantity: ${item['quantity']} | Price: ₹${item['price']}"),
                  );
                },
              ),
            ),
            Text("Total: ₹${order['total']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
