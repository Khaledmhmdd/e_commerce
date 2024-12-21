
class PriceCalculator {
  final double deliveryFee;

  PriceCalculator({required this.deliveryFee});

  double calculateTotalPrice(List<Map<String, dynamic>> cartItems) {
    double total = 0.0;
    for (var item in cartItems) {
      final itemPrice = double.parse(item['Price'].toString());
      final itemCount = int.parse(item['count'].toString());
      total += itemPrice * itemCount;
    }
    return total + deliveryFee;
  }
}
