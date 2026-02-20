import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageOrders extends StatefulWidget {
  @override
  _ManageOrdersState createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  List orders = [];
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchOrders();
  }

  Future<void> _loadTokenAndFetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
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

  Future<void> _updateStatus(int orderId, String status) async {
    bool updated = await ApiService.updateOrderStatus(token, orderId, status);
    if (updated) _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return orders.isEmpty
        ? Center(child: Text("No orders"))
        : ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final o = orders[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(o['product_name'] ?? 'Unknown'),
                  subtitle: Text("Customer: ${o['customer_id']} | Qty: ${o['quantity']}"),
                  trailing: DropdownButton<String>(
                    value: o['status'],
                    items: ['Pending', 'Shipped', 'Delivered']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) _updateStatus(o['order_id'], value);
                    },
                  ),
                ),
              );
            },
          );
  }
}
