/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:e_commerce/store_screens/category_screen.dart';
import 'package:e_commerce/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List to hold products
  List<Map<String, dynamic>> products = [];
  Set<String> favoriteProducts = {}; // Store IDs of favorite products

  // Speech-to-text instance
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  // Fetch all products from Firestore
  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('products').get();
      final data =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();

      setState(() {
        products = data;
      });
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  // Search products based on name
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      fetchProducts(); // Load all products if search query is empty
      return;
    }

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff') // Firestore prefix search
          .get();

      final searchResults =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();

      setState(() {
        products = searchResults;
      });
    } catch (e) {
      print("Error searching products: $e");
    }
  }

  // Search products by barcode
  Future<void> searchByBarcode() async {
    try {
      String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanResult != '-1') {
        final QuerySnapshot snapshot = await _firestore
            .collection('products')
            .where('barcode', isEqualTo: barcodeScanResult)
            .get();

        setState(() {
          products = snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();
        });
      }
    } catch (e) {
      print("Barcode error: $e");
    }
  }

  // Start listening for voice input
  void startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _searchController.text = result.recognizedWords;
        });
        searchProducts(result.recognizedWords);
      });
    }
  }

  void stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //////////////////////////// AppBar
      appBar: AppBar(
        backgroundColor: KMainColor2,
        shadowColor: Colors.black,
        elevation: 15,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search products...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  searchProducts(value); // Trigger search
                },
              )
            : logoo(),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.black),
            onPressed: searchByBarcode, // Trigger barcode search
          ),
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                color: _isListening ? Colors.red : Colors.black),
            onPressed: _isListening ? stopListening : startListening, // Trigger voice search
          ),
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  fetchProducts(); // Reset to all products when closing search
                }
              });
            },
          ),
        ],
      ),

      ///////////////////////////////////////////////////////////////// Body
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Special Discount Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: KMainColor1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Special Discount',
                          style: TextStyle(color: KMainColor2, fontSize: 16),
                        ),
                        Row(
                          children: [
                            Text(
                              '50%',
                              style: TextStyle(
                                color: Color(0xFFF24E29),
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              ' up to',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: KMainColor,
                      ),
                      child: const Text('Get Now'),
                    ),
                  ],
                ),
              ),
            ),

            // Categories Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(
                            selectedCategory: category['category']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Image.asset(category['path']!, height: 60, width: 60),
                          const SizedBox(height: 8),
                          Text(category['category']!),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // All Products Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'All Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return buildProductCard(
                    imagePath: product['image'] ?? 'assets/default_image.png',
                    productName: product['name'] ?? 'No Name',
                    price: product['price']?.toString() ?? '0.0',
                    rating: 4,
                    isFavorite: favoriteProducts.contains(product['id']),
                    onFavoriteToggle: () {
                      setState(() {
                        if (favoriteProducts.contains(product['id'])) {
                          favoriteProducts.remove(product['id']);
                        } else {
                          favoriteProducts.add(product['id']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      ///////////////////////////////////////////////////////////////// Bottom Navigation
      bottomNavigationBar: buttonbar(context),
    );
  }
}*/
/**********************************************************************************************************************/
/*
import 'package:e_commerce/searchproduct.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/store_screens/category_screen.dart';
import 'package:e_commerce/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List to hold products
  List<Map<String, dynamic>> products = [];
  List<bool> favorites = [];

  // Fetch products from Firestore
  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('products').get();
      final data = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      setState(() {
        products = data;
        favorites = List<bool>.filled(products.length, false); // Initialize favorites list
      });
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ////////////////////////////AppBar
      appBar: AppBar(
        backgroundColor: KMainColor2,
        shadowColor: Colors.black,
        elevation: 15,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  // Future functionality: Implement search filter
                  print("Searching for: $value");
                  
                },
              )
            : logoo(),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(products));
             /* setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });*/
            },
          ),
        ],
      ),
      

/////////////////////////////////////////////////END OF APP BAR

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: KMainColor1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Special Discount',
                          style: TextStyle(color: KMainColor2, fontSize: 16),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 98,
                                  height: 50,
                                  child: Text(
                                    '50%',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color(0xFFF24E29),
                                      fontSize: 40,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50),
                                Text(
                                  'up to',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Segoe UI',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 50),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: KMainColor,
                      ),
                      child: const Text('Get Now'),
                    ),
                  ],
                ),
                
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: Color(0xFF060000),
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CategoryScreen(
                                    selectedCategory: 'all',
                                  )),
                        );
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(color: Color.fromARGB(255, 41, 242, 152)),
                      ),
                    ),
                  ),
                ],

              ),
            ), const SizedBox(height: 8),
    SizedBox(
    height: 100,
    ///////////////////////////////////////////////////////category bar
    child: ListView.builder(
      scrollDirection: Axis.horizontal,

      itemCount: categories.length,
      itemBuilder: (context, index) 

      {
        final category = categories[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
                                    context,
              MaterialPageRoute(
                builder: (context) => CategoryScreen(
                                   selectedCategory: category['category']!,
                ),
              ),
            );
          },

          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(

              children: [
                Image.asset(category['path']!, height: 40, width: 60 , filterQuality: FilterQuality.high, ),
                const SizedBox(height: 20),

                Text(

                  category['category']!,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ),


////////////////////////////////////////////end of category bar

            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
//////////////////////////////////////////////////////////////////////////

            const SizedBox(height: 8),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () { 
                      /*
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Go to Categories',
                              desc:
                                  'Please follow the instructions to  know more Product Details ',
                              btnOkOnPress: () {},
                            ).show();*/
                    /* Navigator.push( context, MaterialPageRoute( builder: (context) => ProductDetailsScreen( product: product, ), ), );*/

                    },
                    child: buildProductCard(
                      imagePath: product['image'],
                      productName: product['name'],
                      price: product['price'],
                      rating: 4,
                      isFavorite: favorites[index],
                      onFavoriteToggle: () {
                        setState(() {
                          favorites[index] = !favorites[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

///////////////////////////////////////////////////////////////////////down bar

      bottomNavigationBar: buttonbar(context),
    );
  }
}*/
/****************************************************************************************************** */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/store_screens/category_screen.dart';
import 'package:e_commerce/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List to hold products
  List<Map<String, dynamic>> products = [];
  Set<String> favoriteProducts = {}; // Store IDs of favorite products

  // Fetch all products from Firestore
  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('products').get();
      final data =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();

      setState(() {
        products = data;
      });
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  // Search products based on name
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      fetchProducts(); // Load all products if search query is empty
      return;
    }

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff') // Firestore prefix search
          .get();

      final searchResults =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();

      setState(() {
        products = searchResults;
      });
    } catch (e) {
      print("Error searching products: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //////////////////////////// AppBar
      appBar: AppBar(
        backgroundColor: KMainColor2,
        shadowColor: Colors.black,
        elevation: 15,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search products...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  searchProducts(value); // Trigger search
                },
              )
            : logoo(),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  fetchProducts(); // Reset to all products when closing search
                }
              });
            },
          ),
        ],
      ),

      ///////////////////////////////////////////////////////////////// Body
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Special Discount Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: KMainColor1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Special Discount',
                          style: TextStyle(color: KMainColor2, fontSize: 16),
                        ),
                        Row(
                          children: [
                            Text(
                              '50%',
                              style: TextStyle(
                                color: Color(0xFFF24E29),
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              ' up to',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CategoryScreen(
                                    selectedCategory: 'all')));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: KMainColor,
                      ),
                      child: const Text('Get Now'),
                    ),
                  ],
                ),
              ),
            ),

            // Categories Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(
                            selectedCategory: category['category']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Image.asset(category['path']!, height: 60, width: 60),
                          const SizedBox(height: 8),
                          Text(category['category']!),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // All Products Section
            Row(
              children: [
                const SizedBox(width: 10,),
                const Text(
                  'All Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 230,),

                 TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoryScreen(
                                  selectedCategory: 'all',
                                )),
                      );
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(color: KMainColor),
                    ),
                  ),

                

              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return buildProductCard(
                    imagePath: product['image'] ?? 'assets/default_image.png',
                    productName: product['name'] ?? 'No Name',
                    price: product['price']?.toString() ?? '0.0',
                    rating: 4,
                    isFavorite: favoriteProducts.contains(product['id']),
                    onFavoriteToggle: () {
                      setState(() {
                        if (favoriteProducts.contains(product['id'])) {
                          favoriteProducts.remove(product['id']);
                        } else {
                          favoriteProducts.add(product['id']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      ///////////////////////////////////////////////////////////////// Bottom Navigation
      bottomNavigationBar: buttonbar(context),
    );
  }
}
