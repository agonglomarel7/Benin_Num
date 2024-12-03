import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final String callbackUrl;

  PaymentWebView({required this.paymentUrl, required this.callbackUrl});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Intercept callback URL
            if (request.url.startsWith(widget.callbackUrl)) {
              final uri = Uri.parse(request.url);
              final status = uri.queryParameters['status']; // Example parameter

              // Display a message or navigate to the next step
              if (status == 'success') {
                Navigator.pop(context, 'Paiement réussi');
              } else {
                Navigator.pop(context, 'Paiement échoué');
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paiement"),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
