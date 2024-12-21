import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String image;
  final String name;
  final double price;
  final String category;
  final int count;
  // Optional fields like rating can be included later if needed.

  Product({
    required this.image,
    required this.name,
    required this.price,
    required this.category,
    required this.count,
  });

  // Convert a Product object to a map (to store in Firebase)
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'price': price,
      'category': category,
      'count': count,
    };
  }

  // Create a Product object from a map (to fetch from Firebase)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      image: map['image'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      category: map['category'] as String,
      count: map['count'] as int,
    );
  }
}

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
      print('Product added successfully');
    } catch (e) {
      print('Failed to add product: $e');
    }
  }

  Future<void> addMultipleProducts(List<Product> products) async {
    WriteBatch batch = _firestore.batch();

    try {
      for (var product in products) {
        var docRef = _firestore.collection('products').doc();
        batch.set(docRef, product.toMap());
      }
      await batch.commit();
      print('All products added successfully');
    } catch (e) {
      print('Failed to add products: $e');
    }
  }
}

void uploadProducts() async {
  List<Product> productsList = [
    Product(
        image: 'lib/images/icons/Dress.png',
        name: 'Dress',
        price: 100,
        //  'rating':'4',
        category: 'dress',
        count: 8),
    Product(
        image: 'lib/images/icons/Chanel 1.png',
        name: 'Chanel 1',
        price: 100,
        //  'rating':'4',
        category: 'bag',
        count: 5),
    Product(
        image: 'lib/images/icons/blue-shirt.png',
        name: 'blue-shirt',
        price: 300,
        //   'rating':'3',
        category: 'shirt',
        count: 7),
    Product(
        image: 'lib/images/icons/Jackie.png',
        name: 'Jackie',
        price: 200,
        // 'rating':'3',
        category: 'bag',
        count: 13),
    Product(
        image: 'lib/images/icons/Shoes.png',
        name: 'Shoes',
        price: 150,
        //  'rating':'2',
        category: 'shoes',
        count: 16),
    Product(
        image: 'lib/images/icons/sawen-shirt.png',
        name: 'sawen-shirt',
        price: 300,
        //    'rating':'1',
        category: 'shirt',
        count: 17),
    Product(
        image: 'lib/images/icons/wepik.png',
        name: 'wepik',
        price: 300,
        //  'rating':'5',
        category: 'cap',
        count: 12),
    Product(
        image: 'lib/images/icons/prod1.png',
        name: 'prod1',
        price: 300,
        //'rating': '4' ,
        category: 'shawl',
        count: 18),
    Product(
        image: 'lib/images/icons/Hazy Rose.png',
        name: 'Hazy Rose',
        price: 300,
        // 'rating':'4',
        category: 'dress',
        count: 100),
    Product(
        image: 'lib/images/icons/fashionable-leather.png',
        name: 'fashionable-leather',
        price: 300,
        //'rating':'4',
        category: 'bag',
        count: 74),
    Product(
        image: 'lib/images/icons/wepik1.png',
        name: 'wepik1',
        price: 300,
        //   'rating':'4',
        category: 'bag',
        count: 20),
    Product(
        image: 'lib/images/icons/wepik2.png',
        name: 'wepik2',
        price: 300,
        //   'rating':'4',
        category: 'bag',
        count: 12),
    Product(
        image: 'lib/images/icons/wepik3.png',
        name: 'wepik3',
        price: 300,
        //    'rating':'4',
        category: 'bag',
        count: 6),
    Product(
        image: 'lib/images/icons/wepik4.png',
        name: 'wepik4',
        price: 100,
        // 'rating':'4',
        category: 'bag',
        count: 7),
    Product(
        image: 'lib/images/icons/pieces 1.png',
        name: 'pieces 1',
        price: 300,
        //'rating':'4',
        category: 'bag',
        count: 10)
  ];

  ProductService productService = ProductService();
  await productService.addMultipleProducts(productsList);
}