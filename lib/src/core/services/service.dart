import 'dart:convert';

import '../../../unicode_moyasar.dart';
import 'package:http/http.dart' as http_client;

class MoyasarPaymentService {
  MoyasarPaymentService._();

  ///* Call verify method
  static Future<PaymentResponse> verifyPayment(String transactionId) async {
    PaymentResponse paymentResponse = PaymentResponse();
    try {
      Uri paymentCaptureUrl = Uri.parse(
          "${MoyasarPaymentControllers.moyasarV1ApiUrl}/$transactionId/capture");

      String authKey =
          'Basic ${base64Encode(utf8.encode('${paymentProvider.moyasarPaymentData.secretKey}:'))}';
      Map<String, String> headerData = {"authorization": authKey};
      http_client.Response response =
          await http_client.post(paymentCaptureUrl, headers: headerData);
      final responseData = json.decode(response.body) ?? {};

      // printMeLog(
      //     "Capture Response: $responseData  --> ${paymentProvider.moyasarPaymentData.secretKey}");
      paymentResponse = PaymentResponse.fromMap(responseData);
      return paymentResponse;
    } catch (e) {
      // printMeLog("Capture Error: $e");
      paymentResponse.paymentSource.message = e.toString();
      return paymentResponse;
    }
  }
}
