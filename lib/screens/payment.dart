
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double totalPrice;
  const PaymentPage({Key? key, required this.totalPrice}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _PaymentPageState createState() => _PaymentPageState();
}

///////////////////////////////////////////////////////////////////////////////////////////////
class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethod;

  // ignore: recursive_getters

  //double totalPrice = PriceCalculator(deliveryFee: 10).calculateTotalPrice(cartItems);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: KMainColor2,
        shadowColor: Colors.black,
        elevation: 15,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: KMainColor1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Total Price: \$${widget.totalPrice}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedPaymentMethod = 'Visa';
                });
              },
              child: paymentOption('Visa', 'lib/images/icons/VISA.png',
                  selectedPaymentMethod == 'Visa'),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedPaymentMethod = 'Mastercard';
                });
              },
              child: paymentOption(
                  'Mastercard',
                  'lib/images/icons/mastercard.png',
                  selectedPaymentMethod == 'Mastercard'),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedPaymentMethod = 'Cash on delivery';
                });
              },
              child: paymentOption('Cash on delivery', null,
                  selectedPaymentMethod == 'Cash on delivery'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedPaymentMethod == 'Cash on delivery') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderDonePage()),
                    );
                  } else if (selectedPaymentMethod == 'Visa' ||
                      selectedPaymentMethod == 'Mastercard') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: KMainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Checkout',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buttonbar(context),
    );
  }

  Widget paymentOption(String name, String? assetPath, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey : Colors.transparent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(name, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          if (assetPath != null) Image.asset(assetPath, height: 30),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  
 

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  Future<void> validPayment() async {
    if (cardHolderController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Please enter the CardHolder Name',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else if (cardNumberController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Please enter the Card Number',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else if (!RegExp(r'^\d{14}$').hasMatch(cardNumberController.text)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Invalid Card Number',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else if (expiryDateController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Please enter the Expiry Date',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{4}$')
        .hasMatch(expiryDateController.text)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Expiry Date must be in MM/YYYY format',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else if (cvvController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Please enter the CVV',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else if (!RegExp(r'^\d{3}$').hasMatch(cvvController.text)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'CVV must be 3 digits',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else {
      await checkout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDonePage(),
        ),
      );
    }
  }

  bool savePaymentMethod = false;
  Future<void> checkout() async {
    try {
      // Step 1: Fetch items from the cart collection
      QuerySnapshot snapshot = await _firestore.collection('cart').get();
      List<DocumentSnapshot> cartItems = snapshot.docs;

      if (cartItems.isEmpty) {
        print('No items in the cart to checkout.');
        return;
      }

      // Step 2: Prepare and add items to the TransactionReport collection
      WriteBatch batch = _firestore.batch();
      CollectionReference transactionReportRef =
          _firestore.collection('TransactionReport');
      CollectionReference productRef = _firestore.collection('products');

      for (DocumentSnapshot cartItem in cartItems) {
        Map<String, dynamic> transactionData =
            cartItem.data() as Map<String, dynamic>;

        // Add transaction-specific fields
        transactionData['transactionDate'] = Timestamp.now();
        transactionData['status'] = 'completed';

        // Add to TransactionReport
        DocumentReference newDoc = transactionReportRef.doc();
        batch.set(newDoc, transactionData);

        // Deduct the purchased quantity from the product collection
        String productName =
            transactionData['full_name']; // Name of the product
        int purchasedCount = transactionData['count'];

        // Query the product by name
        QuerySnapshot productQuery = await productRef
            .where('name', isEqualTo: productName)
            .limit(1)
            .get();

        if (productQuery.docs.isNotEmpty) {
          DocumentSnapshot productSnapshot = productQuery.docs.first;
          Map<String, dynamic> productData =
              productSnapshot.data() as Map<String, dynamic>;
          int currentCount = productData['count'] ?? 0;

          if (currentCount >= purchasedCount) {
            batch.update(productSnapshot.reference,
                {'count': currentCount - purchasedCount});
          } else {
            print('Insufficient stock for product: $productName');
            // Optionally, handle insufficient stock here
          }
        } else {
          print('Product not found: $productName');
          // Optionally, handle product not found here
        }

        // Step 3: Schedule cart item for deletion
        batch.delete(cartItem.reference);
      }

      // Commit the batch operation (move and delete)
      await batch.commit();

      print(
          'Checkout completed successfully. Items moved to TransactionReport.');

      //Step 4: Navigate to the OrderDonePage
    } catch (e) {
      print('Failed to complete checkout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: KMainColor2,
        shadowColor: Colors.black,
        elevation: 15,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
           /* Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: KMainColor1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Total: \$${}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),*/
            const SizedBox(height: 20),
            TextFormField(
              controller: cardHolderController,
              decoration: const InputDecoration(labelText: 'CardHolder Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: cardNumberController,
              decoration: const InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: expiryDateController,
                    decoration: const InputDecoration(
                        labelText: 'Expiry Date (MM/YYYY)'),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: cvvController,
                    decoration: const InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: savePaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      savePaymentMethod = value ?? false;
                    });
                  },
                ),
                const Text('Save the Payment Method'),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  validPayment();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: KMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buttonbar(context),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
class OrderDonePage extends StatelessWidget {
  const OrderDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Thank you for your purchase!'),
        backgroundColor: KMainColor2,
        shadowColor: Colors.black,
        elevation: 15,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Order Done',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              style: ElevatedButton.styleFrom(
                backgroundColor: KMainColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text('Back to Home Page',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buttonbar(context),
    );
  }
}