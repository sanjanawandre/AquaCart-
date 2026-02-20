import 'package:flutter/material.dart';

class SellerManagement extends StatefulWidget {
  const SellerManagement({super.key});

  @override
  _SellerManagementState createState() => _SellerManagementState();
}

class _SellerManagementState extends State<SellerManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy data
  List<Map<String, String>> pendingSellers = [
    {'name': 'Seller One', 'email': 'one@sellers.com'},
    {'name': 'Seller Two', 'email': 'two@sellers.com'},
  ];

  List<Map<String, String>> approvedSellers = [
    {'name': 'Seller A', 'email': 'a@sellers.com'},
    {'name': 'Seller B', 'email': 'b@sellers.com'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _approveSeller(int index) {
    setState(() {
      approvedSellers.add(pendingSellers[index]);
      pendingSellers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Seller approved")),
    );
  }

  void _rejectSeller(int index) {
    setState(() {
      pendingSellers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Seller rejected")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Management"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending Approvals"),
            Tab(text: "All Sellers"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ---------------- Pending Approvals ----------------
          ListView.builder(
            itemCount: pendingSellers.length,
            itemBuilder: (context, index) {
              final seller = pendingSellers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(seller['name']!),
                  subtitle: Text(seller['email']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _approveSeller(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _rejectSeller(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // ---------------- All Sellers ----------------
          ListView.builder(
            itemCount: approvedSellers.length,
            itemBuilder: (context, index) {
              final seller = approvedSellers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(seller['name']!),
                  subtitle: Text(seller['email']!),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
