import 'package:flutter/foundation.dart';

class RazorpayConstants {
  final String _liveKey = 'rzp_live_2dDJqgy3o8syGA';
  final String _key = 'rzp_test_iJghHFoheTmkHd';
  final _options = {
    'key': 'rzp_live_2dDJqgy3o8syGA',
    'amount': 15,
    'name': 'MyMedTrip',
    'description': 'Payment for query confirmation',
    'currency': 'USD',
    'prefill': {
      'contact': '8888888888',
      'email': 'hello@mymedtrip.com'
    }
  };
  static getOptionsForQueryConfirmation({String? phoneNumber, String? name}){
    var currentOption = RazorpayConstants()._options;
    // if(kDebugMode){
      currentOption['currency'] = 'INR';
      currentOption['amount'] = '100';
    // }
    currentOption['name'] = name!;
    currentOption['prefill'] = {'contact': phoneNumber ?? '8888888888'};
    return currentOption;
  }

  static getOptionsForTeleconsultation({required int amount, String? description, String? phoneNumber, String? name}){
    var currentOption = RazorpayConstants()._options;

    currentOption['amount'] = amount * 100;
    currentOption['description'] = description??'Payment for Teleconsultation confirmation';
    currentOption['currency'] = "USD";
    currentOption['name'] = name!;
    currentOption['prefill'] = {'contact': phoneNumber ?? '8888888888'};
    // if(kDebugMode){
      currentOption['currency'] = 'INR';
      currentOption['amount'] = '100';
    // }
    return currentOption;
  }
}