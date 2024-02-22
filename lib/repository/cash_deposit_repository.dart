import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdf_test/providers/network_data_provider.dart';
import 'package:path_provider/path_provider.dart';

class CashDeposityRepository {
  static final CashDeposityRepository _instance = CashDeposityRepository._();

  factory CashDeposityRepository() => _instance;
  CashDeposityRepository._();

  Future<String> getPaymentCardPath() async {
    await Future.delayed(const Duration(seconds: 2));
    return "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
  }

  Future<String> getPaymentCard(String endpoint) async {
    try {
      var response = await NetworkDataProvider().get(
        endpoint,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );
      debugPrint(response.headers.toString());

      String pocId = '0000100002';
      var tempDir = await getTemporaryDirectory();
      String path = "${tempDir.path}_payment_card_$pocId.pdf";

      File file = File(path);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return path;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }
}
