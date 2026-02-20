import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'order_history_screen.dart';
import 'filter_search_page.dart';
import 'category_products_screen.dart';
import 'product_detail_page.dart';
import 'profile_page.dart'; // ProfilePage with Logout

class CustomerDashboard extends StatefulWidget {
  @override
  _CustomerDashboardState createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _selectedIndex = 0;
  List products = [];
  List featuredProducts = [];
  bool isLoading = true;
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadToken();
    fetchProducts();
  }

  void _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? ''; // Updated key
    });
  }

  Future<void> fetchProducts() async {
    try {
      var allProducts = await ApiService.getProducts();
      setState(() {
        products = allProducts;
        featuredProducts =
            allProducts.where((p) => p['featured'] == true).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
      if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  } else if (index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) =>  WishlistScreen(wishlistItems: [],)),
    );
  } else if (index == 3) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderHistoryScreen()),
    );
  } else if (index == 4) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfilePage()),
    );
  }
}


  AppBar _buildAppBar() {
    return AppBar(
      title: Text("AquaCart"),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FilterSearchPage()),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCategoryTile(IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CategoryProductsScreen(category: title)),
        );
      },
      child: Container(
        width: 90,
        margin: EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.indigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  )
                ],
              ),
              padding: EdgeInsets.all(14),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.shade100,
          ),
          child: product['image'] != null
              ? Image.network(product['image'], fit: BoxFit.cover)
              : Icon(Icons.image, size: 40, color: Colors.white70),
        ),
        title: Text(product['name'] ?? "Product Name",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            "₹${product['price'] ?? 0} | Stock: ${product['stock'] ?? 0}"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                product: product,
                token: token,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchProducts,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Categories",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          _buildCategoryTile(Icons.pets, "Fish"),
                          _buildCategoryTile(Icons.water, "Aquariums"),
                          _buildCategoryTile(Icons.fastfood, "Food"),
                          _buildCategoryTile(Icons.cleaning_services, "Supplies"),
                        ],
                      ),
                    ),
                    if (featuredProducts.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Featured Products",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        itemCount: featuredProducts.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(featuredProducts[index]);
                        },
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("All Products",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(products[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
