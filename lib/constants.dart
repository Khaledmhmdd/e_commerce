// ignore_for_file: constant_identifier_names
import 'package:e_commerce/screens/ProfileScreen.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:e_commerce/store_screens/cart_screen.dart';
import 'package:e_commerce/store_screens/category_screen.dart';
import 'package:e_commerce/store_screens/home_screen.dart';
import 'package:flutter/material.dart';

///////////////////////////////////////////// colors & variables
const KMainColor  = Color(0xFFF24E29);
const KMainColor1 = Color(0xFF1F3B53);
const KMainColor2 = Color(0xFFF8F8F8);
//const KMainColor3 = Color(0xFFF8F8F8);
String res = '';
 Widget buildProductCard({
  required String imagePath,
  required String productName,
  required String price,
  required int rating, 
  required bool isFavorite, 
  required VoidCallback onFavoriteToggle, 
}) 
{
  return SizedBox(
    // width: 300,
    // height: 300,
// padding(),
    child: Container(

      decoration: ShapeDecoration(
        color: Colors.white,
        
        shape: RoundedRectangleBorder(

          side: const BorderSide(width: 1, color: Color(0xFFA49D9D)),
          borderRadius: BorderRadius.circular(2),

        ),


        shadows: const [
          BoxShadow(

            color: Color(0x3F000000),
            blurRadius: 4,
          offset: Offset(0, 1.5),
          
          ),
        ],
      ),
      //////////////////////////image decoration
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.asset(
                imagePath,
             //   fit: BoxFit.cover,
              ),
            ),
          ),



         ///////////////////////////////////font decoration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                                ///2 texts for price and name
                Text(
                  productName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),



                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                  ),
                ),

                ///////////////////////////////////////////////stars
                Row(

                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),

                ////////////////////////////////////fav icon 
                Align(
                  alignment: Alignment.bottomRight,

                  child: IconButton(

                    onPressed: onFavoriteToggle,

                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color.fromARGB(255, 32, 3, 112),
                    ),


                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/////////////////////////////////////////////////////////////////////////

Widget buttonbar(context ){
return BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Category'),
         BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        
        
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              break;
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CategoryScreen(selectedCategory:'all')));
              break;
             case 2:
             Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const CartScreen()));
              break;
            case 3:
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const  ProfileScreen()));
              break;
          }
        },
      );
    


}


///////////////////////////////////list of products
 List<Map<String, String >>categories = [
  
  {
      'path':'lib/images/icons/sneaker.png',
      'category': 'shoes',
      
 },
  {
      'path':'lib/images/icons/t-shirt.png',
      'category': 'shirt',
 },
  {
      'path':'lib/images/icons/trousers.png',
      'category': 'pants',
 },
  {
      'path':'lib/images/icons/dress (2).png',
      'category': 'dress',
 },
  {
      'path':'lib/images/icons/woman-bag.png',
      'category': 'bag',
 },


{
      'path':'lib/images/icons/baseball-cap.png',
      'category': 'cap',
 },

{
      'path':'lib/images/icons/shawl.png',
      'category': 'shawl',
 },



 ];
//////////////////////////////////////logo
Widget logoo(){
return  SizedBox(
    width: 102,
    height: 49,
    child: Stack(
        children: [
            const Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                    width: 98,
                    height: 32,

                    //////////////////[text from fegma "ehhhh kol daaah"]
                    
                    child: Text(
                        'Fashion',
                        style: TextStyle(
                            color: Color(0xFFF24E29),
                            fontSize: 32,
                            fontFamily: 'Lobster',
                            fontWeight: FontWeight.w400,
                            height: 0,
                        ),
                    ),
                ),
            ),

            Positioned(
                left: 39,
                top: 41,
                child: Transform(
                    transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(3.14),
                    child: Container(
                        width: 39,
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 3.50,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF1F3B53),
                                ),
                            ),
                        ),
                    ),
                ),
            ),

            const Positioned(
                left: 43,
                top: 36,
                child: SizedBox(
                    width: 59,
                    height: 13,
                    child: Text.rich(
                        TextSpan(
                            children: [
                                TextSpan(
                                    text: 'S    t    o    r    ',
                                    style: TextStyle(
                                        color: Color(0xFF1F3B53),
                                        fontSize: 10,
                                        fontFamily: 'Lobster',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                    ),
                                ),
                                TextSpan(
                                    text: 'e',
                                    style: TextStyle(
                                        color: Color(0xFF1F3B53),
                                        fontSize: 10,
                                        fontFamily: 'Lobster',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                        letterSpacing: 1,
                                    ),
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        ],
    ),
);
}

List<bool> favorites = List.generate(products.length, (index) => false);

List<Map<String, String >> products = [

    {
      'image': 'lib/images/icons/Dress.png',
      'name': 'Dress',
      'price': '100 \$',
       //  'rating':'4',
      'category': 'dress',
    },
{
      'image': 'lib/images/icons/Chanel 1.png',
      'name': 'Chanel 1',
      'price': '100 \$',
    //  'rating':'4',
      'category': 'bag',
    },

    {
      'image': 'lib/images/icons/blue-shirt.png',
      'name': 'blue-shirt',
      'price': '300 \$',
   //   'rating':'3',
      'category': 'shirt',
    },
    {
      'image': 'lib/images/icons/Jackie.png',
      'name': 'Jackie',
      'price':'200 \$',
     // 'rating':'3',
      'category': 'bag',
    },
    {
      'image': 'lib/images/icons/Shoes.png',
      'name': 'Shoes',
      'price': '150 \$',
    //  'rating':'2',
      'category': 'shoes',
    },
    {
      'image': 'lib/images/icons/sawen-shirt.png',
      'name': 'sawen-shirt',
      'price': '300 \$',
  //    'rating':'1',
      'category': 'shirt',
    },
   
   {
      'image': 'lib/images/icons/wepik.png',
      'name': 'wepik',
      'price': '300 \$',
    //  'rating':'5',
      'category': 'cap',
    },
    {
      'image': 'lib/images/icons/prod1.png',
      'name': 'prod1',
      'price': '300 \$',
      //'rating': '4' ,
      'category': 'shawl',
    },
    {
      'image': 'lib/images/icons/Hazy Rose.png',
      'name': 'Hazy Rose',
      'price': '300 \$',
     // 'rating':'4',
      'category': 'dress',
    },
    {
      'image': 'lib/images/icons/fashionable-leather.png',
      'name': 'fashionable-leather',
      'price': '300 \$',
      //'rating':'4',
      'category': 'bag',
    },

{
      'image': 'lib/images/icons/wepik1.png',
      'name': 'wepik1',
      'price': '300 \$',
   //   'rating':'4',
      'category': 'bag',
    },


    {
      'image': 'lib/images/icons/wepik2.png',
      'name': 'wepik2',
      'price': '300 \$',
   //   'rating':'4',
      'category': 'bag',
    },


    {
      'image': 'lib/images/icons/wepik3.png',
      'name': 'wepik3',
      'price': '300 \$',
  //    'rating':'4',
      'category': 'bag',
    },


    {
      'image': 'lib/images/icons/wepik4.png',
      'name': 'wepik4',
      'price': '300 \$',
     // 'rating':'4',
      'category': 'bag',
    },


{
      'image': 'lib/images/icons/pieces 1.png',
      'name': 'pieces 1',
      'price': '300 \$',
      //'rating':'4',
      'category': 'bag',
    },


  ];



