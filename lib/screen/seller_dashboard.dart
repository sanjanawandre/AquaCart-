import 'package:flutter/material.dart';

// ---------------- Dummy Pages ----------------
class AddProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text("Add Product")));
}

class ManageListingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text("Manage Listings")));
}

class EarningsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text("Earnings")));
}

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Order $orderId")),
        body: Center(child: Text("Details for Order $orderId")),
      );
}

class SalesReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Sales Report")),
        body: const Center(child: Text("Sales Report Details")),
      );
}

class InventoryDetailPage extends StatelessWidget {
  final String product;
  const InventoryDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(product)),
        body: Center(child: Text("Details for $product")),
      );
}

class NotificationDetailPage extends StatelessWidget {
  final String title;
  const NotificationDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Notification")),
        body: Center(child: Text(title)),
      );
}

class SellerTipPage extends StatelessWidget {
  final String tip;
  const SellerTipPage({super.key, required this.tip});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Seller Tip")),
        body: Center(child: Text(tip)),
      );
}

// ---------------- Seller Dashboard ----------------
class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Dashboard"),
        centerTitle: true,
        elevation: 6,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Quick Actions ----------
            Text("Quick Actions",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo,
                    )),
            const SizedBox(height: 12),
            _quickActions(context),
            const SizedBox(height: 24),

            // ---------- Sales Overview ----------
            Text("Sales Overview",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo,
                    )),
            const SizedBox(height: 12),
            _salesOverviewCard(context),
            const SizedBox(height: 24),

            // ---------- Inventory Status ----------
            Text("Inventory Status",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo,
                    )),
            const SizedBox(height: 12),
            _inventoryStatus(context),
            const SizedBox(height: 24),

            // ---------- Orders Section ----------
            Text("Recent Orders",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo,
                    )),
            const SizedBox(height: 12),
            _ordersSection(context),
            const SizedBox(height: 24),

            // ---------- Notifications ----------
            Text("Notifications",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo,
                    )),
            const SizedBox(height: 12),
            _notificationsList(context),
            const SizedBox(height: 24),

            // ---------- Seller Tips ----------
            Text("Seller Tips",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo,
                    )),
            const SizedBox(height: 12),
            _tipsSection(context),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F7FB),
    );
  }

  // ---------------- Quick Actions ----------------
  Widget _quickActions(BuildContext context) {
    final actions = [
      {"title": "Add Product", "icon": Icons.add_box, "color": Colors.teal, "page": AddProductPage()},
      {"title": "Manage Listings", "icon": Icons.list, "color": Colors.orange, "page": ManageListingsPage()},
      {"title": "Earnings", "icon": Icons.account_balance_wallet, "color": Colors.green, "page": EarningsPage()},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((a) {
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => a["page"] as Widget));
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: (a["color"] as Color).withOpacity(0.2),
                child: Icon(a["icon"] as IconData, color: a["color"] as Color, size: 28),
              ),
              const SizedBox(height: 6),
              Text(a["title"] as String, style: const TextStyle(fontWeight: FontWeight.w600))
            ],
          ),
        );
      }).toList(),
    );
  }

  // ---------------- Sales Overview Card ----------------
  Widget _salesOverviewCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SalesReportPage()));
      },
      child: Card(
        elevation: 8,
        shadowColor: Colors.indigo.withOpacity(0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _overviewItem("Orders", "120", Icons.shopping_cart, Colors.blue),
              _overviewItem("Revenue", "₹45000", Icons.attach_money, Colors.green),
              _overviewItem("Pending", "8", Icons.pending_actions, Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _overviewItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(radius: 22, backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600))
      ],
    );
  }

  // ---------------- Inventory Status ----------------
  Widget _inventoryStatus(BuildContext context) {
    final items = [
      {"product": "Goldfish Tank", "status": "Low Stock", "color": Colors.red},
      {"product": "Water Filter", "status": "In Stock", "color": Colors.green},
      {"product": "Aquarium Plants", "status": "Out of Stock", "color": Colors.orange},
    ];

    return Column(
      children: items.map((i) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => InventoryDetailPage(product: i["product"] as String)),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: (i["color"] as Color).withOpacity(0.2),
                  child: Icon(Icons.inventory, color: i["color"] as Color)),
              title: Text(i["product"] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(i["status"] as String),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------- Orders Section ----------------
  Widget _ordersSection(BuildContext context) {
    final List<Map<String, dynamic>> orders = [
      {"id": "#101", "status": "Processing", "color": Colors.blue},
      {"id": "#102", "status": "Delivered", "color": Colors.green},
      {"id": "#103", "status": "Pending", "color": Colors.orange},
    ];

    return Column(
      children: orders.map((o) {
        final String orderId = o["id"]?.toString() ?? "Unknown";
        final String status = o["status"]?.toString() ?? "Unknown";
        final Color color = (o["color"] is Color) ? o["color"] as Color : Colors.grey;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: orderId)),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(Icons.shopping_bag, color: color)),
              title: Text("Order $orderId", style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text("Status: $status"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------- Notifications ----------------
  Widget _notificationsList(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {"title": "New order received", "time": "5 min ago", "type": "order"},
      {"title": "Product low in stock", "time": "1 hour ago", "type": "stock"},
      {"title": "Weekly sales report ready", "time": "Yesterday", "type": "report"},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final n = notifications[index];
        final color = _typeColor(n["type"]);
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationDetailPage(title: n["title"]!)),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(_typeIcon(n["type"]), color: color)),
              title: Text(n["title"]!, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(n["time"]!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        );
      },
    );
  }

  IconData _typeIcon(String? type) {
    switch (type) {
      case "order":
        return Icons.shopping_bag;
      case "stock":
        return Icons.inventory_2;
      case "report":
        return Icons.bar_chart;
      default:
        return Icons.notifications;
    }
  }

  Color _typeColor(String? type) {
    switch (type) {
      case "order":
        return Colors.green;
      case "stock":
        return Colors.redAccent;
      case "report":
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
  }

  // ---------------- Seller Tips ----------------
  Widget _tipsSection(BuildContext context) {
    final tips = [
      {"title": "Add 3+ images per product", "detail": "Listings with more images get higher conversion.", "icon": "light"},
      {"title": "Use limited-time offers", "detail": "Short discounts can spike weekend sales.", "icon": "offer"},
    ];

    return Column(
      children: tips.map((t) {
        final isLight = t["icon"] == "light";
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SellerTipPage(tip: t["title"]!)),
            );
          },
          child: Card(
            color: isLight ? Colors.blue.shade50 : Colors.teal.shade50,
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(
                  isLight ? Icons.lightbulb : Icons.local_offer,
                  size: 30,
                  color: isLight ? Colors.orange : Colors.teal),
              title: Text(t["title"]!, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(t["detail"]!),
            ),
          ),
        );
      }).toList(),
    );
  }
}
