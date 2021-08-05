import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:flutterwave/flutterwave.dart';

class PaymentUI {
  static String publicKey = "enter public key";
  static String encryptionKey = "enter encryption key";

  static makePayment(
      {@required context,
        String type,
      @required String currency,
      String intention,
      @required String email,
      @required String number,
      @required String amount,
      @required MainModel model,
      @required String name}) async {
    final flutterwave = Flutterwave.forUIPayment(
      context: context,
      currency: currency,
      fullName: name,
      email: email,
      acceptBankTransfer: true,
      isDebugMode: true,
      phoneNumber: number,
      amount: '$amount',
      txRef: "rave_flutter-${DateTime.now().toString()}",
      acceptAccountPayment: true,
      acceptCardPayment: true,
      acceptUSSDPayment: true,
      publicKey: publicKey,
      encryptionKey: encryptionKey,
    );

    final response = await flutterwave.initializeForUiPayments();
    if (response != null) {
      if (response.data.status == FlutterwaveConstants.SUCCESSFUL) {
        model.addWedding(name, intention, null, null, type);
        dialog('Payment Was Successful!', context);
      } else {
        print(response.data);
        dialog(response.data.status, context);
      }
    } else {
      dialog("No Response! Please try again", context);
    }
  }

  static dialog(String value, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 2,
        title: Text('FeedBack'),
        content: Text(value),
        actions: [
          Container(
            color: Colors.green,
            padding: EdgeInsets.all(2),
            child: TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          )
        ],
      ),
    );
  }
}
