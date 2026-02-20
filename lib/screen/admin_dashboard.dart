import 'package:flutter/material.dart';

// ---------------- Dummy Pages ----------------
class ManageSellersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Sellers")),
      body: const Center(child: Text("Here you can manage all sellers")),
    );
  }
}

class ManageCustomersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Customers")),
      body: const Center(child: Text("Here you can manage all customers")),
    );
  }
}

class ManageProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Products")),
      body: const Center(child: Text("Here you can manage all products")),
    );
  }
}

class ViewOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Orders")),
      body: const Center(child: Text("Here you can view all orders")),
    );
  }
}

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports & Analytics")),
      body: const Center(child: Text("Reports and analytics will show here")),
    );
  }
}

class InventoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory Monitoring")),
      body: const Center(child: Text("Inventory monitoring details here")),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: const Center(child: Text("Send or manage notifications here")),
    );
  }
}

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support & Complaints")),
      body: const Center(child: Text("Handle complaints and support tickets here")),
    );
  }
}

// ---------------- Admin Dashboard ----------------
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    int totalUsers = 150;
    int totalOrders = 120;
    double totalRevenue = 45000;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🌊 AquaCart Admin Dashboard"),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.indigo,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF4F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Title
            _sectionTitle("📊 Overview"),

            // Status Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _animatedStatusCard("Users", totalUsers.toString(),
                    Icons.people, Colors.blue),
                _animatedStatusCard("Orders", totalOrders.toString(),
                    Icons.shopping_cart, Colors.orange),
                _animatedStatusCard("Revenue", "₹${totalRevenue.toStringAsFixed(2)}",
                    Icons.attach_money, Colors.green),
              ],
            ),
            const SizedBox(height: 30),

            // 🔹 Clickable Sections
            _sectionTitle("👥 Seller Management"),
            _infoCard(
              "View all sellers, approve/reject requests, suspend/block accounts.",
              Icons.store,
              Colors.indigo,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => ManageSellersPage())),
            ),

            _sectionTitle("🛒 Customer Management"),
            _infoCard(
              "View customers, block fake accounts, track orders.",
              Icons.person,
              Colors.teal,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => ManageCustomersPage())),
            ),

            _sectionTitle("📦 Product Management"),
            _infoCard(
              "Approve product listings, manage categories, remove illegal products.",
              Icons.inventory,
              Colors.orange,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => ManageProductsPage())),
            ),

            _sectionTitle("🚚 Order Management"),
            _infoCard(
              "View all orders across sellers, filter by status, handle disputes.",
              Icons.local_shipping,
              Colors.blueGrey,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewOrdersPage())),
            ),

            _sectionTitle("📈 Reports & Analytics"),
            _infoCard(
              "Daily/weekly/monthly sales reports, revenue breakdown, top products.",
              Icons.insights,
              Colors.purple,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportsPage())),
            ),

            _sectionTitle("📊 Inventory Monitoring"),
            _infoCard(
              "Low stock alerts, out-of-stock list, restock suggestions.",
              Icons.warning,
              Colors.redAccent,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => InventoryPage())),
            ),

            _sectionTitle("🔔 Notifications & Announcements"),
            _infoCard(
              "Send global notifications and platform updates.",
              Icons.notifications,
              Colors.green,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsPage())),
            ),

            _sectionTitle("🛠️ Support & Complaints"),
            _infoCard(
              "Handle customer complaints and seller disputes.",
              Icons.support_agent,
              Colors.deepOrange,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => SupportPage())),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Section Title ----------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.indigo,
        ),
      ),
    );
  }

  // ---------------- Animated Status Card ----------------
  Widget _animatedStatusCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.8, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Card(
              elevation: 10,
              shadowColor: color.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.15), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      radius: 26,
                      child: Icon(icon, size: 30, color: color),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- Info Card for Sections ----------------
  Widget _infoCard(String text, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
