import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'payment_webview.dart';

class PaiementPage extends StatefulWidget {
  final double amount;

  PaiementPage({required this.amount});

  @override
  _PaiementPageState createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  bool _applyDiscount = false;
  bool _isLoading = false;

  double get calculatedAmount =>
      _applyDiscount ? widget.amount * 0.5 : widget.amount;

  Future<void> _fetchPaymentUrl() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("https://numbj.randever.com"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"amount": calculatedAmount.toInt()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentWebView(
                paymentUrl: data['payment_url'],
                callbackUrl: data['callback_url'],
              ),
            ),
          );
        } else {
          _showError("API Error: ${data['message']}");
        }
      } else {
        _showError("Error: Unable to fetch payment URL.");
      }
    } catch (e) {
      _showError("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paiement")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Montant à payer: ${calculatedAmount.toStringAsFixed(2)} XOF",
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Checkbox(
                  value: _applyDiscount,
                  onChanged: (value) {
                    setState(() {
                      _applyDiscount = value ?? false;
                    });
                  },
                ),
                Text("Appliquer 50% de réduction"),
              ],
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _fetchPaymentUrl,
              child: Text("Payer"),
            ),
          ],
        ),
      ),
    );
  }
}
