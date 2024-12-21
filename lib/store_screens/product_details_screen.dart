import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/store_screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String,dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int count = 1;

  CollectionReference cart = FirebaseFirestore.instance.collection('cart');

  Future<void> addToCart() {
    final price = widget.product['price'];

    // Print the price to debug
    print("Price from product: $price");

    // Remove the dollar sign and whitespace, then try parsing the price
    double parsedPrice = 0.0;
    if (price is String) {
      // Remove any non-numeric characters (like the dollar sign)
      final cleanedPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
      parsedPrice = double.tryParse(cleanedPrice) ?? 0.0;
    } else if (price is num) {
      parsedPrice =
          price.toDouble(); // If price is already a num, convert it to double
    }

    // Print the parsed price to verify
    print("Parsed Price: $parsedPrice");

    return cart
        .add({
          'imageUrl': widget.product['image'],
          'full_name': widget.product['name'],
          'Price': parsedPrice, // Use parsed price
          'count': count, // Store count as an int
        })
        .then((value) => print("Cart Added"))
        .catchError((error) => print("Failed to add to Cart: $error"));
  }


  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      widget.product['image']!,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.product['name']!,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 250.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: imgList.map((item) => Image.asset(item)).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.product['name']!,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  widget.product['price']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (count > 0) count--;
                    });
                  },
                  icon: const Icon(Icons.remove_circle_outline, size: 30),
                ),
                Text(
                  "$count",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      count++;
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline, color: Colors.orange, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem ipsum has been the industry\'s standard dummy text since the 1500s.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                addToCart();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(
                      /*product: widget.product,*/
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*************************************************************************************** */
