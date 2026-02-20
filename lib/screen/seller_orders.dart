import 'package:flutter/material.dart';

class SellerOrders extends StatefulWidget {
  const SellerOrders({super.key});

  @override
  State<SellerOrders> createState() => _SellerOrdersState();
}

class _SellerOrdersState extends State<SellerOrders> {
  // Dummy order data
  List<Map<String, dynamic>> orders = [
    {
      "id": 1,
      "customer": "John Doe",
      "product": "Goldfish",
      "quantity": 2,
      "status": "Pending"
    },
    {
      "id": 2,
      "customer": "Jane Smith",
      "product": "Betta Fish",
      "quantity": 1,
      "status": "Shipped"
    },
    {
      "id": 3,
      "customer": "Alice",
      "product": "Aquarium Plant",
      "quantity": 5,
      "status": "Delivered"
    },
  ];

  void _updateStatus(int index) async {
    String? newStatus = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Update Order Status"),
        children: [
          SimpleDialogOption(
            child: const Text("Pending"),
            onPressed: () => Navigator.pop(context, "Pending"),
          ),
          SimpleDialogOption(
            child: const Text("Shipped"),
            onPressed: () => Navigator.pop(context, "Shipped"),
          ),
          SimpleDialogOption(
            child: const Text("Delivered"),
            onPressed: () => Navigator.pop(context, "Delivered"),
          ),
        ],
      ),
    );

    if (newStatus != null) {
      setState(() {
        orders[index]['status'] = newStatus;
      });

      // TODO: Call API to update status in backend
      print("Order ID ${orders[index]['id']} updated to $newStatus");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order status updated to $newStatus")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seller Orders")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text("${order['product']} x${order['quantity']}"),
            subtitle: Text("Customer: ${order['customer']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(order['status'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(order['status']))),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _updateStatus(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Shipped":
        return Colors.blue;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
