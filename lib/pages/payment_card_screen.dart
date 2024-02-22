import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PaymentCardScreen extends StatefulWidget {
  const PaymentCardScreen({super.key, required this.path});

  final String path;

  @override
  State<PaymentCardScreen> createState() => _PaymentCardScreenState();
}

class _PaymentCardScreenState extends State<PaymentCardScreen> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('PDF Viewer'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            PDFView(
              filePath: widget.path,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage!,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              onRender: (totalPages) {
                setState(() {
                  pages = totalPages;
                  isReady = true;
                });
                debugPrint("It's done");
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                debugPrint(error.toString());
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                debugPrint('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onPageChanged: (int? page, int? total) {
                debugPrint('page change: $page/$total');
                setState(() {
                  currentPage = page;
                });
              },
            ),
            if (!isReady) const Center(child: CircularProgressIndicator()),
            if (errorMessage.isNotEmpty) Center(child: Text(errorMessage)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => Navigator.maybePop(context),
        child: const Icon(Icons.chevron_left_rounded),
      ),
    );
  }
}
