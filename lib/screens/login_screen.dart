
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
//////////////////////////IMPORTS/////////////////////

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> SignUp(BuildContext context) async {
    if (passwordController.text.isEmpty || emailController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Email or Password Cannot be Empty',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Invalid Email',
        desc: 'Please enter a valid email address',
        btnOkOnPress: () {},
      ).show();
      return;
    } else {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        await saveRememberMeState(isRememberMeChecked);

        if (await getUserIsAdmin() == true) {
          Navigator.of(context).pushReplacementNamed('/AdminDashboard');
        } else {
          Navigator.of(context).pushReplacementNamed("/onboard");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'No user found for that email',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Wrong password provided for that user',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
        }
      }
    }
  }

  Future<bool?> getUserIsAdmin() async {
    try {
      // Get the current user's UID
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not logged in");
      }

      // Reference to the user's document in Firestore
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
      print("I am on the GetUserIsAdmin");

      // Fetch the document
      final snapshot = await userDoc.get();

      // Check if the document exists and extract 'isAdmin'
      if (snapshot.exists) {
        return snapshot.data()?['isAdmin'] as bool?;
      } else {
        throw Exception("User document does not exist");
      }
    } catch (e) {
      print("Error getting isAdmin value: $e");
      return null; // Return null or handle error as needed
    }
  }

  bool isRememberMeChecked = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRememberMeState();
  }

  Future signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context)
        .pushNamedAndRemoveUntil("/onboard", (route) => false);
  }

  Future<void> loadRememberMeState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isRememberMeChecked = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> saveRememberMeState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    //fashion box

                    'Fashion',
                    style: TextStyle(
                      color: KMainColor,
                      fontSize: 64,
                      fontFamily: 'Lobster',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),

                  const SizedBox(
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

                  const SizedBox(height: 20),
                  const Text(
                    "Login",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter your email and password",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      labelText: "Email",
                      //fillColor: Colors.black,

                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFA49D9D),
                          width: 380,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xFFA49D9D)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),

                  ///////////////////////////////[REMEMBER ME ]///////////////////////////////////////////
                  ///

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Checkbox(
                        value: isRememberMeChecked,
                        splashRadius: 15,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        onChanged: (value) {
                          setState(() {
                            isRememberMeChecked = value!;
                          });
                        },
                        activeColor: Colors.blue,
                      ),

                      const Text(
                        "Remember Me",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 47, 39, 39),
                        ),
                      ),

                      const SizedBox(width: 100),
                      /////////////////////////////forget paaswrd

                      Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: emailController.text);
                                
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Forgot Password?',
                        desc:
                            'Please follow the instructions sent to your email to reset your password.',
                        btnOkOnPress: () {},
                      ).show();
                          },
                          child: const Text(
                            "Forget Password?",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 47, 39, 39)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KMainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await SignUp(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          "Signup",
                          style: TextStyle(color: KMainColor),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Divider with OR
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('or'),
                      ),
                      Expanded(
                        child: Divider(thickness: 1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          //side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFA49D9D)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        icon: Image.asset(
                          'lib/images/icons/Capa_1.png',
                          height: 20,
                          width: 20,
                        ),
                        label: const Text(
                          'facebook',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => signInWithGoogle(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFA49D9D)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        icon: Image.asset(
                          'lib/images/icons/google-icon-logo 1.png',
                          height: 20,
                          width: 20,
                        ),
                        label: const Text(
                          'Google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}