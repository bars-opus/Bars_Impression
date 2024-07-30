class IsGhanain {
  // Static method to determine if the user is in Ghana or using GHS currency
  static bool isGhanaOrCurrencyGHS(String country, String currency) {
    if (currency.isNotEmpty) {
      final List<String> currencyPartition =
          currency.trim().replaceAll('\n', ' ').split("|");

      // Check if the country is Ghana and the currency code is GHS
      String currencyPartition2 =
          currencyPartition.length > 1 ? currencyPartition[1] : '';
      print(currencyPartition2);

      return country == 'Ghana' && currencyPartition2.trim() == 'GHS';
    } else {
      return false;
    }
  }
}
