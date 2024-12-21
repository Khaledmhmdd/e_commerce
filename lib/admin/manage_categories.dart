import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageProductCategories extends StatefulWidget {
  @override
  _ManageProductCategoriesState createState() => _ManageProductCategoriesState();
}

class _ManageProductCategoriesState extends State<ManageProductCategories> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> products = [];
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      List<Map<String, dynamic>> fetchedProducts = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID to the data map
        return data;
      }).toList();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print('Failed to fetch products: $e');
    }
  }

  Future<void> updateCategory(String productId) async {
    if (_categoryController.text.isEmpty) {
      return;
    }

    Map<String, dynamic> updatedCategory = {
      'category': _categoryController.text,
    };
    try {
      await _firestore.collection('products').doc(productId).update(updatedCategory);
      print('Category updated successfully');
      fetchProducts(); // Refresh the product list
    } catch (e) {
      print('Failed to update category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Text('Current category: ${product['category']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.update),
                      onPressed: () => updateCategory(product['id']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
