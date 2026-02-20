import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/api_service.dart';
import 'register_screen.dart';
import 'seller/seller_dashboard.dart';
import 'admin/admin_dashboard.dart';
import 'customer_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  late AnimationController _bubbleController;
  late AnimationController _fishController;

  @override
  void initState() {
    super.initState();
    _bubbleController =
        AnimationController(vsync: this, duration: Duration(seconds: 20))..repeat();
    _fishController =
        AnimationController(vsync: this, duration: Duration(seconds: 15))..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _fishController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() { isLoading = true; });
    try {
      var result = await ApiService.login(emailController.text.trim(), passwordController.text.trim());
      setState(() { isLoading = false; });

      if (result['success'] == true) {
        String token = result['token'];
        String role = result['role'];
        int userId = result['user_id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', role);
        await prefs.setInt('user_id', userId);

        if (role == 'admin') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
        } else if (role == 'seller') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SellerDashboard()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerDashboard()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? "Login failed")));
      }
    } catch (e) {
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900, Colors.blue.shade600],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _bubbleController,
            builder: (context, child) => CustomPaint(painter: BubblePainter(_bubbleController.value), child: Container()),
          ),
          AnimatedBuilder(
            animation: _fishController,
            builder: (context, child) => CustomPaint(painter: FishPainter(_fishController.value), child: Container()),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(25),
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: Colors.blue.shade900.withOpacity(0.4), blurRadius: 15, offset: Offset(0, 6))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water, size: 60, color: Colors.white),
                    SizedBox(height: 10),
                    Text("Welcome to AquaLogin", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    SizedBox(height: 25),
                    TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                        prefixIcon: Icon(Icons.email, color: Colors.white, size: 20),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                        prefixIcon: Icon(Icons.lock, color: Colors.white, size: 20),
                      ),
                    ),
                    SizedBox(height: 25),
                    isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : ElevatedButton(
                            onPressed: loginUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade400,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 6,
                              shadowColor: Colors.blueAccent,
                            ),
                            child: Text("Dive In"),
                          ),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
                      child: Text("Don't have an account? Register", style: TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bubble Painter
class BubblePainter extends CustomPainter {
  final double animationValue;
  BubblePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);
    final random = math.Random(2);
    for (int i = 0; i < 25; i++) {
      double x = random.nextDouble() * size.width;
      double y = (size.height * (1 - animationValue) + i * 40) % size.height;
      double radius = random.nextDouble() * 10 + 4;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) => true;
}

/// Fish Painter
class FishPainter extends CustomPainter {
  final double animationValue;
  FishPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paintFish = Paint()..color = Colors.orangeAccent;
    double yPos1 = size.height * 0.3 + math.sin(animationValue * 2 * math.pi) * 20;
    double xPos1 = size.width * animationValue;
    canvas.drawOval(Rect.fromCenter(center: Offset(xPos1, yPos1), width: 40, height: 20), paintFish);

    final paintFish2 = Paint()..color = Colors.lightBlueAccent;
    double yPos2 = size.height * 0.6 + math.cos(animationValue * 2 * math.pi) * 25;
    double xPos2 = size.width * (1 - animationValue);
    canvas.drawOval(Rect.fromCenter(center: Offset(xPos2, yPos2), width: 35, height: 18), paintFish2);
  }

  @override
  bool shouldRepaint(covariant FishPainter oldDelegate) => true;
}
