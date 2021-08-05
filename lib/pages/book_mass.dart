import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:st_peters_chaplaincy_unn/ui_widgets/payment_widget.dart';

class BookMass extends StatefulWidget {
  @override
  _BookMassState createState() => _BookMassState();
}

class _BookMassState extends State<BookMass> {
  final formKey = GlobalKey<FormState>();

  String email;
  double amount;
  String currency;
  String country;
  String name;
  String intention;

  // String lastName;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, MainModel model)  {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Email'),
                          onSaved: (value) => email = value,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Amount to charge'),
                          onSaved: (value) {
                            String _amount = value
                                .toString()
                                .replaceAll(',', '')
                                .replaceAll('-', '')
                                .trim();
                            amount = double.parse(_amount);
                            return amount;
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            String _value = value
                                .toString()
                                .replaceAll(',', '')
                                .replaceAll('-', '')
                                .trim();
                            if (value.startsWith('.') || (value.startsWith(','))) {
                              return 'enter a valid amount';
                            }
                            if (_value.isEmpty) {
                              return 'enter amount';
                            }
                            if (_value.isNotEmpty &&
                                double.tryParse(_value) < 100) {
                              return 'must be #100 and above';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Name(Optional)'),
                          onSaved: (value) => name = value,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Mass intention'),
                          onSaved: (value) {
                            intention = value;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          validator: (value) =>
                              value.isEmpty ? 'enter mass intention' : null,
                        ),
                        SizedBox(height: 20),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText:
                                  'Currency code e.g NGN(It is already NGN by default)'),
                          onSaved: (value) => currency = value,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText:
                                  'Country code e.g NG(It is already NG by default)'),
                          onSaved: (value) => country = value,
                        ),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () => validateInputs(model),
                  child: Text(
                    'BOOK MASS',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void validateInputs(MainModel model) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      startPayment(model);
    }
  }

  startPayment(MainModel model) {
    return PaymentUI.makePayment(
        context: context,
        type: 'massIntentions',
        currency: currency.isNotEmpty ? currency : "NGN",
        email: email.isEmpty ? model.authentication.email : email,
        number: model.authentication.number,
        amount: '$amount',
        model: model,
        name: name.isEmpty ? model.authentication.sname : name);
  }
}
