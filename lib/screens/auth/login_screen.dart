import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:you_chat/helper/dialogue.dart';
import 'package:you_chat/screens/home_screen.dart';

import '../../api/api.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        isAnimate = true;
      });
    });
  }

  _handleGoogleSignIn() {
    Dialogue.showProgressBar(context);
    _signInWithGoogle().then((user) async => {
          Navigator.pop(context),
          if (user != null)
            {
              if (await APIs.userExists())
                {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()))
                }
              else
                {
                  await APIs.createUser().then((value) => {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()))
                      })
                }
            },
        });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint("\n_signInWithGoogle: $e");
      Navigator.pop(context);
      Dialogue.showSnackBar(
          context, "Something went wrong (Check Internet connection)");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Welcome to কথা (katha)",
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 22),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedSize(
              curve: Curves.easeInCirc,
              duration: const Duration(milliseconds: 500),
              child: Image.asset("images/chat.png",
                  width: isAnimate ? mq.width * .4 : mq.width * .1),
            ),
          ),
          const Text(
            "কথা (katha)",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const Text(""),
          const Text(""),
          const Text(""),
          const Text(""),
          const Text(""),
          const Text(""),
          Center(
            child: InkWell(
              splashColor: Colors.green.shade900,
              onTap: () {
                _handleGoogleSignIn();
              },
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Ink(
                height: 50,
                width: mq.width * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.transparent,
                    border: Border.all(color: Colors.green, width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/google.png",
                      height: 25,
                    ),
                    const Text("    "),
                    const Text(
                      "Sign-in with Google",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
}
