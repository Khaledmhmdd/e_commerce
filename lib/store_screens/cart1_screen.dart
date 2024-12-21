import 'package:flutter/material.dart';
/*


class cart1 extends StatelessWidget {
  const cart1({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body:const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Cart - 0 Product',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  }
*/




class cart1 extends StatefulWidget {
  @override
  State<cart1> createState() => _cart1State();
}

class _cart1State extends State<cart1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.deepOrangeAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/category");
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cart - 0 Product',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 85),
            Row(
              children: [
                
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   SizedBox(
                    height: 100,

                   ),
                  
                   
                    
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price', style: TextStyle(fontSize: 18)),
                Text('\$00.0', style: TextStyle(fontSize: 18)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery', style: TextStyle(fontSize: 18)),
                Text('\$00.0', style: TextStyle(fontSize: 18)),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('\$00.0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
