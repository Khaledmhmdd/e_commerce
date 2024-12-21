import 'package:e_commerce/admin/bestSellingChart.dart';
import 'package:e_commerce/admin/dashboard.dart';
import 'package:e_commerce/admin/manage_categories.dart';
import 'package:e_commerce/admin/manage_products.dart';
import 'package:e_commerce/admin/reprots_screen.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:e_commerce/screens/onboarding.dart';
import 'package:e_commerce/screens/payment.dart';
import 'package:e_commerce/screens/signup_screen.dart';
import 'package:e_commerce/screens/splash_screen.dart';
import 'package:e_commerce/store_screens/cart1_screen.dart';
import 'package:e_commerce/store_screens/cart_screen.dart';
import 'package:e_commerce/store_screens/category_screen.dart';
import 'package:e_commerce/store_screens/home_screen.dart';
import 'package:e_commerce/store_screens/product_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

 //uploadProducts();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  
  @override
  void initState() {
    
    super.initState();

   
    }
    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: const LoginScreen(),
       initialRoute: '/splash', //start page
      //initialRoute:  '/admin',
      //initialRoute: '/home'  ,
      routes: {
        '/AdminDashboard':(context)=>const AdminDashboard(),
        "bestSellingChart": (context) => BestSellingChart(),
        "manage_categories": (context) =>  ManageProductCategories(),
        "manage_products": (context) =>  ManageProducts(),
        "reports_screen": (context) => TransactionReport(),
        '/splash': (context) =>const SplashScreen(),
        '/login' : (context) =>const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/onboard':(context) => const OnboardingScreen(),
        //'/payment':(context) => const PaymentPage(),
        '/home'  : (context) => FirebaseAuth.instance.currentUser == null? const LoginScreen(): const HomeScreen(),
        '/category': (context) => const CategoryScreen(selectedCategory: 'all',),
        '/product-details': (context) => ProductDetailsScreen( product: ModalRoute.of(context)!.settings.arguments as Map<String, String>, ),
        '/cart'  : (context) =>  const CartScreen(/*product: ModalRoute.of(context)!.settings.arguments as Map<String, String>,*/),
        'cart1'  : (context) =>  cart1(),

        
      },
    );
  }
}
