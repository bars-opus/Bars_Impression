class ProcessingFeeCalculator {
  static double calculateProcessingFee(double totalPrice) {
    if (totalPrice < 100) {
      return 5.0;
    } else if (totalPrice < 500) {
      return 10.0;
    } else if (totalPrice < 1000) {
      return 20.0;
    } else if (totalPrice < 1500) {
      return 30.0;
    } else if (totalPrice < 2000) {
      return 40.0;
    } else if (totalPrice < 2500) {
      return 50.0;
    } else if (totalPrice < 3000) {
      return 60.0;
    } else if (totalPrice < 3500) {
      return 70.0;
    } else if (totalPrice < 4000) {
      return 80.0;
    } else if (totalPrice < 4500) {
      return 90.0;
    } else if (totalPrice < 5000) {
      return 100.0;
    } else if (totalPrice < 5500) {
      return 110.0;
    } else if (totalPrice < 6000) {
      return 120.0;
    } else if (totalPrice < 6500) {
      return 130.0;
    } else if (totalPrice < 7000) {
      return 140.0;
    } else if (totalPrice < 7500) {
      return 150.0;
    } else if (totalPrice < 8000) {
      return 160.0;
    } else if (totalPrice < 8500) {
      return 170.0;
    } else if (totalPrice < 9000) {
      return 180.0;
    } else if (totalPrice < 9500) {
      return 190.0;
    } else if (totalPrice < 10000) {
      return 200.0;
    } else {
      return 300.0;
    }
  }
}
