

/*************************************************************************************************************************************/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screens/payment.dart';
import 'package:e_commerce/store_screens/home_screen.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Firestore references
  final CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  final CollectionReference report = FirebaseFirestore.instance.collection('report');

  static const double deliveryFee = 10.00; // Delivery fee constant

  Future<void> addToReport(DocumentSnapshot item, double totalPrice) async {
    try {
      await report.add({
        'date': DateTime.now(),
        'full_name': item['full_name'] ?? 'No Name',
        'Price': item['Price'] ?? '0.00',
        'count': item['count'] ?? '0',
        'total': totalPrice.toStringAsFixed(2),
      });
      print("Report Added");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report updated successfully!')),
      );
    } catch (error) {
      print("Failed to add to report: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update report')),
      );
    }
  }

  Future<void> clearCart() async {
    try {
      final cartDocs = await cart.get();
      for (var doc in cartDocs.docs) {
        await cart.doc(doc.id).delete();
      }
      print("Cart cleared successfully!");
    } catch (error) {
      print("Failed to clear cart: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cart.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!.docs;

          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                    },
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            );
          }

          // Calculate total price
          double totalPrice = cartItems.fold(0.0, (sum, item) {
            final Price = double.tryParse(item['Price'].toString()) ?? 0.0;
            final Count = int.tryParse(item['count']?.toString() ?? '0') ?? 0;
            return sum + (Price * Count);
          }) + deliveryFee;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final itemName = item['full_name'] ?? 'No Name';
                    final itemPrice = item['Price'];
                    final itemCount = int.tryParse(item['count']?.toString() ?? '0') ?? 0;
                    final itemImage = item['imageUrl'] ?? '';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: itemImage.isNotEmpty
                            ? Image.asset(
                                itemImage,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                              )
                            : const Icon(Icons.image),
                        title: Text(itemName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: \$$itemPrice'),
                            Text('Quantity: $itemCount'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text('Are you sure you want to delete this item?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await cart.doc(item.id).delete();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPaymentDetailRow('Delivery Fee', deliveryFee),
                    const Divider(),
                    _buildPaymentDetailRow('Total Price', totalPrice, isBold: true),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          for (var item in cartItems) {
                            await addToReport(item, totalPrice); // Add each item to the report
                          }
                          await clearCart(); // Clear the cart
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  PaymentPage(totalPrice:totalPrice)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaymentDetailRow(String title, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
