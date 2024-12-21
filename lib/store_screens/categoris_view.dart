import 'package:flutter/material.dart';
import 'package:e_commerce/store_screens/product_details_screen.dart';
import 'package:e_commerce/constants.dart';



class categoris_view extends StatefulWidget {
  final String selectedCategory;
  const categoris_view({super.key, required this.selectedCategory});

  @override
  _categoris_viewState createState() => _categoris_viewState();
}

class _categoris_viewState extends State<categoris_view> {
  final Map<String, bool> favorites = {};


  @override
  Widget build(BuildContext context) {


    List<Map<String, String>> filteredProducts ;
    
    
                      

    if (widget.selectedCategory == 'all') {
      filteredProducts = products.toList();
  
    } 


else if (widget.selectedCategory == ( 'dress') || widget.selectedCategory ==  ('shoes')|| widget.selectedCategory == ('cap')|| widget.selectedCategory == ('pants')||widget.selectedCategory == ('shawl')||widget.selectedCategory == ('shirt')||widget.selectedCategory == ('bag')){
      filteredProducts = products.where((product) {
        return product['category'] == widget.selectedCategory;
      }).toList();
    }



// else if (products.single['category']!.contains(widget.selectedCategory)){

//       filteredProducts = products.where((product) {
//         return product['category'] == widget.selectedCategory;
//       }).toList();
//     }



else{
   filteredProducts = products.where((product) {
        return product['name'] == widget.selectedCategory;
      }).toList();

}


    return 
          
         
        ListView.builder(
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
                            'Add to Cart',
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
    );
    // filteredProducts.clear();
  }
}
