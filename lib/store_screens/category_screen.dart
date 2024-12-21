import 'package:flutter/material.dart';
import 'package:e_commerce/store_screens/product_details_screen.dart';
import 'package:e_commerce/constants.dart';

class CategoryScreen extends StatefulWidget {
  final String selectedCategory;
  const CategoryScreen({super.key, required this.selectedCategory});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Map<String, bool> favorites = {};
  bool _isSearching = false; // Track if the search bar is active
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredProducts;
    if (widget.selectedCategory == 'all') {
      filteredProducts = products.toList();
    } else {
      filteredProducts = products.where((product) {
        return product['category'] == widget.selectedCategory;
      }).toList();
    }

    return Scaffold(
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
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Product count
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredProducts.length} Products',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
               /* IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Add filter functionality here
                  },
                ),*/
              ],
            ),
          ),
          // Products in selected category
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final isFavorite = favorites[product['name']] ?? false;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                product['image']!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        product['price']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        '850 \$',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Sale 15%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              favorites[product['name']!] = !isFavorite;
                            });
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KMainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  product: product,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Product Details',
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
       bottomNavigationBar: buttonbar(context ),
    );
  }
}
