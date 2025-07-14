import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../data/styles.dart';

class WelkomePage extends StatefulWidget {
  const WelkomePage({super.key});

  @override
  State<WelkomePage> createState() => _WelkomePageState();
}

class _WelkomePageState extends State<WelkomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kIsWeb ? 'lib/assets/fon1.png' : 'lib/assets/fon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(flex: 2, child: Text("")),
              Expanded(
                flex: 1, 
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/mainmenu');
                  },
                  icon: Icon(Icons.arrow_forward, size: 40, color: invisColor),),
              ),
              const Expanded(flex: 2, child: Text("")),
              // logo
              Image(
                image: AssetImage('lib/assets/logo.png'),
                width: 200,
                height: 200,
              ),
              const Expanded(flex: 2, child: Text("")),
              Text("Welcome!", style: titleStyle),
              const Expanded(flex: 1, child: Text("")),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Sign in button
                  SizedBox(
                    width: 295,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          buttonColor,
                        ),
                        textStyle: WidgetStateProperty.all<TextStyle>(
                          buttonTextStyle,
                        ),
                        shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                      ),
                      onPressed: () {
                        // Go to sign in page
                        Navigator.of(context).pushNamed('/signin');
                      },
                      child: const Text('SIGN  IN'),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25)),
                  // Sign up button
                  SizedBox(
                    width: 295,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          buttonColorInvis,
                        ),
                        shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        side: WidgetStateProperty.all<BorderSide>(
                          BorderSide(color: whiteColor, width: 1),
                        ),
                      ),
                      onPressed: () {
                        // Go to sign up page
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text('SIGN  UP', style: buttonTextStyleInvis,),
                    ),
                  ),
                ],
              ),
              const Expanded(flex: 6, child: Text("")),
            ],
          ),
        ),
      ),
    );
  }
}
