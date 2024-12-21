import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageProducts extends StatefulWidget {
  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> products = [];
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
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

  Future<void> addProduct() async {
    Map<String, dynamic> newProduct = {
      'image': _imageController.text,
      'name': _nameController.text,
      'price': _priceController.text,
      'category': _categoryController.text,
    };
    try {
      await _firestore.collection('products').add(newProduct);
      print('Product added successfully');
      fetchProducts(); // Refresh the product list
    } catch (e) {
      print('Failed to add product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      print('Product deleted successfully');
      fetchProducts(); // Refresh the product list
    } catch (e) {
      print('Failed to delete product: $e');
    }
  }

  Future<void> editProduct(String productId) async {
    Map<String, dynamic> updatedProduct = {
      'image': _imageController.text,
      'name': _nameController.text,
      'price': _priceController.text,
      'category': _categoryController.text,
    };
    try {
      await _firestore.collection('products').doc(productId).update(updatedProduct);
      print('Product updated successfully');
      fetchProducts(); // Refresh the product list
    } catch (e) {
      print('Failed to update product: $e');
    }
  }

  Future<void> editCategory(String productId, String newCategory) async {
    Map<String, dynamic> updatedCategory = {
      'category': newCategory,
    };
    try {
      await _firestore.collection('products').doc(productId).update(updatedCategory);
      print('Category updated successfully');
      fetchProducts(); // Refresh the product list
    } catch (e) {
      print('Failed to update category: $e');
    }
  }

  void showEditCategoryDialog(String productId, String currentCategory) {
    _categoryController.text = currentCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category'),
          content: TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              labelText: 'New Category',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                editCategory(productId, _categoryController.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Image Path'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: addProduct,
                  child: const Text('Add Product'),
                ),
                
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Text('Price: ${product['price']}, Category: ${product['category']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showEditCategoryDialog(product['id'], product['category']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteProduct(product['id']),
                        ),
                      ],
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
