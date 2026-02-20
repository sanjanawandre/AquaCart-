import 'package:flutter/material.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key});

  @override
  _OrderManagementState createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  // Dummy orders data
  List<Map<String, dynamic>> orders = [
    {'id': 101, 'customer': 'John Doe', 'product': 'Product A', 'quantity': 2, 'status': 'Pending'},
    {'id': 102, 'customer': 'Jane Smith', 'product': 'Product B', 'quantity': 1, 'status': 'Shipped'},
    {'id': 103, 'customer': 'Alice Lee', 'product': 'Product C', 'quantity': 3, 'status': 'Delivered'},
  ];

  void _updateStatus(int index) {
    String currentStatus = orders[index]['status'];
    String? newStatus;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Order Status"),
        content: DropdownButtonFormField<String>(
          initialValue: currentStatus,
          items: ['Pending', 'Shipped', 'Delivered']
              .map((status) => DropdownMenuItem(value: status, child: Text(status)))
              .toList(),
          onChanged: (val) => newStatus = val,
          decoration: const InputDecoration(labelText: "Select Status"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (newStatus != null) {
                setState(() {
                  orders[index]['status'] = newStatus!;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Order status updated")),
                );
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Management")),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text("Order #${order['id']} - ${order['customer']}"),
              subtitle: Text(
                  "${order['product']} x${order['quantity']} | Status: ${order['status']}"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _updateStatus(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
