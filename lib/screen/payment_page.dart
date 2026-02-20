import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  final List<Map> cartItems;
  final Function(Map<String, dynamic>) onPaymentSuccess;

  const PaymentPage({
    required this.amount,
    required this.cartItems,
    required this.onPaymentSuccess,
    super.key,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _createOrder();
  });

  }

  Future<void> _createOrder() async {
  try {
    print('Creating order for ₹${widget.amount}...');

    final response = await http.post(
      Uri.parse('${ApiConfig.nodeBaseUrl}/create-order'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'amount': widget.amount}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to create order: ${response.body}');
    }

    final orderData = json.decode(response.body);

    if (orderData['id'] == null || orderData['amount'] == null) {
      throw Exception('Invalid order data: $orderData');
    }

    var options = {
      'key': 'rzp_test_LfgZQiFmD61mGl',
      'amount': orderData['amount'],
      'order_id': orderData['id'],
      'name': 'AquaCart',
      'description': 'Order Payment',
      'prefill': {'contact': '9876543210', 'email': 'user@example.com'},
    };

    print('Opening Razorpay checkout...');
    _razorpay.open(options);
  } catch (e) {
    print('Error creating Razorpay order: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error creating Razorpay order: $e')),
    );
  }
}

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    widget.onPaymentSuccess({
      'paymentId': response.paymentId,
      'orderId': response.orderId,
      'signature': response.signature
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet Selected: ${response.walletName}');
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Payment")),
        body: Center(child: Text("Processing your payment...")),
      );
}
