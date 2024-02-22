import 'package:flutter/material.dart';
import 'package:pdf_test/business/cash_deposit_cubit.dart';
import 'package:pdf_test/pages/payment_card_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  //Initialize Method on Cubit
  Future<void> initialize() async {
    setState(() => isLoading = true);

    await CashDepositCubit().initialize();

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (!isLoading) ...[
              ElevatedButton.icon(
                onPressed: () async {
                  // Share Function on Cubit
                  await CashDepositCubit().sharePaymentCard(
                    CashDepositCubit().state.paymentCardFilePath!,
                    context,
                  );
                },
                icon: const Icon(
                  Icons.file_download,
                  color: Colors.white,
                ),
                label: const Text('Share Payment Card'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 38.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    //Show payment card function on Cubit
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentCardScreen(
                          path: CashDepositCubit().state.paymentCardFilePath!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.white,
                  ),
                  label: const Text('Show Payment Card'),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
