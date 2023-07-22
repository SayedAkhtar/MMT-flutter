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
  static getOptionsForQueryConfirmation(){
    return RazorpayConstants()._options;
  }

  static getOptionsForTeleconsultation({required int amount, String? description}){
    var currentOption = RazorpayConstants()._options;
    currentOption['amount'] = amount;
    currentOption['description'] = description??'Payment for Teleconsultation confirmation';
    currentOption['currency'] = "USD";
    return currentOption;
  }
}