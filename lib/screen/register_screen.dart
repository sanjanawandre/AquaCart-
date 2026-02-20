import 'package:flutter/material.dart';
import 'dart:math';
import '/services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String role = "customer";
  bool isLoading = false;

  late AnimationController _bubbleController;
  late List<Bubble> bubbles;

  void registerUser() async {
    setState(() => isLoading = true);
    try {
      var result = await ApiService.register(
        emailController.text.trim(),
        passwordController.text.trim(),
        role,
      );

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Registration successful")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _bubbleController =
        AnimationController(vsync: this, duration: Duration(seconds: 15))
          ..repeat();

    // Create bubbles at random positions
    final random = Random();
    bubbles = List.generate(
      20,
      (index) => Bubble(
        random.nextDouble() * 400, // x position
        random.nextDouble() * 800, // y position
        random.nextDouble() * 20 + 5, // size
        random.nextDouble() * 0.5 + 0.2, // speed
      ),
    );
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Aquarium Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900, Colors.blue.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Animated bubbles
          AnimatedBuilder(
            animation: _bubbleController,
            builder: (context, child) {
              return CustomPaint(
                painter: BubblePainter(bubbles, _bubbleController.value),
                child: Container(),
              );
            },
          ),

          // Register Form Card
          Center(
            child: SingleChildScrollView(
              child: Card(
                color: Colors.white.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 12,
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Create Your Account 🐠",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade900)),

                      SizedBox(height: 20),

                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email, color: Colors.teal),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      SizedBox(height: 15),

                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock, color: Colors.teal),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      SizedBox(height: 15),

                      DropdownButtonFormField<String>(
                        value: role,
                        items: ["admin", "seller", "customer"].map((r) {
                          return DropdownMenuItem(
                              value: r, child: Text(r.toUpperCase()));
                        }).toList(),
                        onChanged: (val) => setState(() => role = val!),
                        decoration: InputDecoration(
                          labelText: "Select Role",
                          prefixIcon:
                              Icon(Icons.person_outline, color: Colors.teal),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),

                      SizedBox(height: 20),

                      isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: registerUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 10,
                              ),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Bubble class
class Bubble {
  double x;
  double y;
  double size;
  double speed;

  Bubble(this.x, this.y, this.size, this.speed);
}

// Painter for bubbles
class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  final double animationValue;

  BubblePainter(this.bubbles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);

    for (var bubble in bubbles) {
      double y = bubble.y - (animationValue * 100 * bubble.speed);
      if (y < 0) y += size.height;
      canvas.drawCircle(Offset(bubble.x, y), bubble.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
