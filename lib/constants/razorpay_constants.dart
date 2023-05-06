class RazorpayConstants {
  final String _key = 'rzp_test_iJghHFoheTmkHd';
  final int _amount = 122828;
  final _options = {
    'key': 'rzp_test_iJghHFoheTmkHd',
    'amount': 122828,
    'name': 'MYMedicalTourism',
    'description': 'Payment for query confirmation',
    'prefill': {
      'contact': '8888888888',
      'email': 'test@razorpay.com'
    }
  };
  static getOptionsForQueryConfirmation(){
    return RazorpayConstants()._options;
  }

  static getQueryOrderAmount(){
    return RazorpayConstants()._amount;
  }

  static getOptionsForTeleconsultation({required int amount, String? description}){
    var currentOption = RazorpayConstants()._options;
    currentOption['amount'] = amount;
    currentOption['description'] = description??'Payment for Teleconsultation confirmation';
    return currentOption;
  }
}