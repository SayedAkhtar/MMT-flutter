import 'package:flutter/foundation.dart';

class RazorpayConstants {
  final String _liveKey = 'rzp_live_2dDJqgy3o8syGA';
  final String _key = 'rzp_test_iJghHFoheTmkHd';
  final int multiplier = 100;
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
  static getOptionsForQueryConfirmation({String? phoneNumber, String? name, int? amount}){
    var currentOption = RazorpayConstants()._options;
    if(kDebugMode || phoneNumber == "7602121828"){
      currentOption['currency'] = 'INR';
      currentOption['amount'] = '100';
      currentOption['key'] = RazorpayConstants()._key;
    }
    if(amount!=null && amount > 0){
      currentOption['amount'] =  amount * RazorpayConstants().multiplier;
    }
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
    if(kDebugMode || phoneNumber == "7602121828"){
      currentOption['currency'] = 'INR';
      currentOption['amount'] = '100';
      currentOption['key'] = RazorpayConstants()._key;
    }
    return currentOption;
  }
}