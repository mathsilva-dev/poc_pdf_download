import 'package:flutter/material.dart';
import 'package:pdf_test/business/cash_deposit_state.dart';
import 'package:pdf_test/pages/payment_card_downloaded_screen.dart';
import 'package:pdf_test/repository/cash_deposit_repository.dart';
import 'package:share_plus/share_plus.dart';

class CashDepositCubit {
  static final CashDepositCubit _instance = CashDepositCubit._();
  late CashDepositState state;

  CashDepositCubit._();
  factory CashDepositCubit() => _instance;

  Future<void> initialize() async {
    //Get payment card url from backend
    var paymentCardPath = await CashDeposityRepository().getPaymentCardPath();

    //Download payment card
    var paymentCardFilePath =
        await CashDeposityRepository().getPaymentCard(paymentCardPath);

    //Emit new state
    state = CashDepositState(
      paymentCardPath: paymentCardPath,
      paymentCardFilePath: paymentCardFilePath,
    );
  }

  Future<void> sharePaymentCard(
    String paymentCardFilePath,
    BuildContext context, //It's not necessary with the Modular Implementation
  ) async {
    final result = await Share.shareXFiles([XFile(paymentCardFilePath)],
        text: 'Tarjeta de Recaudo');

    if (result.status == ShareResultStatus.success) {
      //Navigate to payment card downloaded screen
      Future.delayed(Duration.zero).then(
        (value) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentCardDownloadedScreen(),
          ),
        ),
      );
    }
  }
}
