import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ppc/pages/apply.dart';
import 'package:ppc/pages/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("lib/assets/bg-2.png"),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/assets/logo.png",
                  height: MediaQuery.sizeOf(context).height * 0.1,
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset("lib/assets/landing.png"),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromRGBO(224, 171, 67, 1),
                    ),
                    minimumSize: MaterialStatePropertyAll(
                      Size(
                        327,
                        48,
                      ),
                    ),
                  ),
                  child: const Text(
                    style: TextStyle(color: Colors.black),
                    "LOGIN",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Apply(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      side: BorderSide(
                        color: Color.fromRGBO(224, 171, 67, 1),
                      ),
                    ),
                    backgroundColor: Colors.black,
                    minimumSize: const Size(
                      327,
                      48,
                    ),
                  ),
                  child: const Text(
                    style: TextStyle(
                      color: Color.fromRGBO(224, 171, 67, 1),
                    ),
                    "APPLY FOR MEMBERSHIP",
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
