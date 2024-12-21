import 'package:e_commerce/constants.dart';
// ignore: unused_import
import 'package:e_commerce/screens/payment.dart';
import 'package:e_commerce/store_screens/home_screen.dart';
import 'package:flutter/material.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
   String description = "Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s";
 
 
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {  


                setState(() {
                  _currentPage = index;
                });

              },



              children: [
                buildOnboardingPage(
                  image: 'lib/images/icons/Online wishes list-pana 1.png',
                  title: 'Heading Here',
                  description: description,
                ),

                buildOnboardingPage(
                  image: 'lib/images/icons/Group 22 (1).png',

              //E:\FLUTTERprojects\e_commerce\lib\images\icons\Group 22 (1).png
                  title: 'Heading Here',
                  description: description,
                ),

                buildOnboardingPage(
                  image: 'lib/images/icons/Group 27.png',

                  //E:\FLUTTERprojects\e_commerce\lib\images\icons\Group 27.png
                  title: 'Heading Here',
                  description: description,
                ),

              ],
            ),
          ),

        /////////////////////////////////////(...) sliding
          Row(

            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => buildDot(index)),
          ),


          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
           
            child: 
           
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                 backgroundColor: KMainColor, 

                 shape: const RoundedRectangleBorder(
                     borderRadius: //BorderRadius.circular(50),
                                 BorderRadius.vertical(),
                            ),

                   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Padding inside the button
                       elevation: 5, // Shadow elevation
                           ),





              onPressed: () {// Navigate to the next screen
                if (_currentPage == 2) {
                                             
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const NextScreen()),
                  );

                } 
                
                else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },

              child: Text(_currentPage == 2 ? 'Get Started' : 'Next',

              style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 16, 
                     //fontWeight: FontWeight.bold, 
                       ),
              
              
              ),
            ),
          ),



          TextButton(
            onPressed: () {
              // Skip to the next screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: const Text('Skip'
            ,
             style: TextStyle(
                color: Colors.grey, 
                fontSize: 16,
            
            
            
            ),
          ),
          //const SizedBox(height: 20),
          )
        ],
      ),
    );
  }

/////////////////////////////////////////////////////


  Widget buildOnboardingPage({

    required String image,
    required String title,
    required String description,


  }) {



    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
          children: [
         Image.asset(image, height: 300),
        const SizedBox(height: 20),
        ////////////////////////text
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            color: KMainColor,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }





  Widget buildDot(int index) {
    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,


      width: _currentPage == index ? 16 : 8,

      decoration: BoxDecoration(
        color: _currentPage == index ? KMainColor: Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),


    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return  const HomeScreen();

  //  Navigator.push(
  //     context,
  //   MaterialPageRoute(builder: (context) => const OnboardingScreen()),);
  
  }
}
