// import 'package:e_commerce/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      backgroundColor: Colors.white,



      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
  SizedBox(
    width: 214,
    height: 97,
    child: Stack(
        children: [
            const Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                    width: 214,
                    height: 65,
                    child: Text(
                        'Fashion',
                        style: TextStyle(
                            color: Color(0xFFF24E29),
                            fontSize: 64,
                            fontFamily: 'Lobster',
                            fontWeight: FontWeight.w400,
                            height: 0,
                        ),
                    ),
                ),
            ),
            Positioned(
                left: 72,
                top: 80,
                child: Transform(
                    transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(3.14),
                    child: Container(
                        width: 64,
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
                left: 90,
                top: 73,
                child: SizedBox(
                    width: 97,
                    height: 24,
                    child: Text.rich(
                        TextSpan(
                            children: [
                                TextSpan(
                                    text: 'S    t    o    r    e',
                                    style: TextStyle(
                                        color: Color(0xFF1F3B53),
                                        fontSize: 15,
                                        fontFamily: 'Lobster',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                    ),
                                ),
                              
                            ],
                        ),
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
}
