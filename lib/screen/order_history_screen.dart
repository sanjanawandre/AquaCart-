import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'order_tracking_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List orders = [];
  bool isLoading = true;
  String token = "";

  void fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token') ?? "";

    try {
      var response = await ApiService.getOrders(token); // We'll define this in api_service.dart
      setState(() {
        orders = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order History")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(child: Text("No orders yet"))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text("Order #${order['id']}"),
                        subtitle: Text("Total: ₹${order['total']} | Status: ${order['status']}"),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => OrderTrackingScreen(order: order)));
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
