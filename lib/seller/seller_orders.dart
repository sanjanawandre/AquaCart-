import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';

class SellerOrders extends StatefulWidget {
  @override
  _SellerOrdersState createState() => _SellerOrdersState();
}

class _SellerOrdersState extends State<SellerOrders> {
  List orders = [];
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadTokenAndOrders();
  }

  Future<void> _loadTokenAndOrders() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final data = await ApiService.getOrders(token);
      setState(() => orders = data);
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  Future<void> _updateStatus(int orderId, String newStatus) async {
    final success = await ApiService.updateOrderStatus(token, orderId, newStatus);
    if (success) {
      _fetchOrders();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order updated to $newStatus")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orders.isEmpty
          ? Center(child: Text("No orders yet"))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final o = orders[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(o['product_name'] ?? 'Unknown'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer ID: ${o['customer_id']}"),
                        Text("Quantity: ${o['quantity']}"),
                        Text("Status: ${o['status']}"),
                      ],
                    ),
                    trailing: DropdownButton<String>(
                      value: o['status'],
                      items: ['Pending', 'Shipped', 'Delivered']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) _updateStatus(o['order_id'], value);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
