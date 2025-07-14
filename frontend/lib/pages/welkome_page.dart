import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

import '../providers/provider.dart';
import '../data/styles.dart';

class WelkomePage extends StatefulWidget {
  const WelkomePage({super.key});

  @override
  State<WelkomePage> createState() => _WelkomePageState();
}

class _WelkomePageState extends State<WelkomePage> {
  @override
  Widget build(BuildContext context) {
    final tripsProvider = Provider.of<TripsProvider>(context);
    tripsProvider.loadLanguage();

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
              if (kIsWeb)
                Padding(padding: const EdgeInsets.only(top: 15)),
              if (!kIsWeb)
                const Expanded(flex: 1, child: Text("")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.only(left: 15)),
                  // Button to return to WelkomePage
                  SizedBox(
                    width: 60,
                    height: 60,
                  ),
                  const Expanded(flex: 1, child: Text("")),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: IconButton(
                      onPressed: () {
                        tripsProvider.toggleLanguage();
                      },
                      icon: Icon(Icons.language, size: 34, color: buttonColor),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 15)),
                ],
              ),
              Expanded(
                flex: 1, 
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/mainmenu');
                  },
                  icon: Icon(Icons.arrow_forward, size: 40, color: invisColor),),
              ),
              const Expanded(flex: 1, child: Text("")),
              // logo
              Image(
                image: AssetImage('lib/assets/logo.png'),
                width: 200,
                height: 200,
              ),
              const Expanded(flex: 2, child: Text("")),
              Text(tripsProvider.languageCode == "en" ? "Welcome!" : "Добро пожаловать!", style: titleStyle),
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
                      child: Text(tripsProvider.languageCode == "en" ? 'SIGN  IN' : 'ВХОД'),
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
                      child: Text(tripsProvider.languageCode == "en" ? 'SIGN  UP' : 'РЕГИСТРАЦИЯ', style: buttonTextStyleInvis,),
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
