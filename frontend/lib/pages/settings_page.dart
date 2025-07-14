import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../providers/provider.dart';
import '../data/styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  String language = 'Русский';
  bool obscure = false;

  @override
  Widget build(BuildContext context) {
    final tripsProvider = Provider.of<TripsProvider>(context);

    tripsProvider.loadMyPersonalInfo();

     return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              kIsWeb ? 'lib/assets/fon1.png' : 'lib/assets/fon.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (kIsWeb)
                Padding(padding: const EdgeInsets.only(top: 20)),
              if (!kIsWeb)
                const Expanded(flex: 1, child: Text("")),
              SizedBox(
                width: 400,
                child: Column(
                  children: [
                    Container(
                      width: 400,
                      height: 477,
                      decoration: BoxDecoration(
                        color: buttonColorInvis,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: buttonColor, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Icon(Icons.account_circle_rounded, size: 200, color: buttonColor,),
                            Padding(padding: const EdgeInsets.only(top: 10)),
                            Row(
                              children: [
                                Padding(padding: const EdgeInsets.only(left: 29)),
                                Text("Nickname", style: basicTextStyle,),
                                Padding(padding: const EdgeInsets.only(left: 250)),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top: 7)),
                            Container(
                              width: 320,
                              height: 35,
                              decoration: BoxDecoration(
                                color: fieldProfileColorInvis,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(padding: const EdgeInsets.only(left: 15)),
                                    SelectableText(tripsProvider.myName, style: basicTextStyle,),
                                    Expanded(flex: 1, child: Text("")),
                                  ],
                                ),
                              ),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 18),),
                            // - - - - - Email - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                            Row(
                              children: [
                                Padding(padding: const EdgeInsets.only(left: 29)),
                                Text("Email address", style: basicTextStyle,),
                                Padding(padding: const EdgeInsets.only(left: 225)),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top: 7)),
                            Container(
                              width: 320,
                              height: 35,
                              decoration: BoxDecoration(
                                color: fieldProfileColorInvis,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(padding: const EdgeInsets.only(left: 15)),
                                    SelectableText(tripsProvider.email, style: basicTextStyle,),
                                    Expanded(flex: 1, child: Text("")),
                                  ],
                                ),
                              ),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 18),),
                            // - - - - - Password - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                            Row(
                              children: [
                                Padding(padding: const EdgeInsets.only(left: 29)),
                                Text("Password", style: basicTextStyle,),
                                Padding(padding: const EdgeInsets.only(left: 250)),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top: 7)),
                            Container(
                              width: 320,
                              height: 35,
                              decoration: BoxDecoration(
                                color: fieldProfileColorInvis,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(padding: const EdgeInsets.only(left: 15)),
                                    Text(obscure ? tripsProvider.password : "•" * tripsProvider.password.length, style: basicTextStyle,),
                                    Expanded(flex: 1, child: Text("")),
                                    IconButton(
                                      onPressed: () {
                                        // TODO: change password
                                        setState(() {
                                          obscure = !obscure;
                                        });
                                      },
                                      icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 20, color: buttonColor,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]
                        )
                      )
                    ),
                  ]
                ),
              ),
              Expanded(
                flex: 3, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            buttonColor,
                          ),
                          textStyle: WidgetStateProperty.all<TextStyle>(
                            buttonTextStyleMedium,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                        ),
                        onPressed: () {
                          
                        },
                        child: Column(
                          children: [
                            const Expanded(flex: 1, child: Text(""),),
                            Icon(Icons.sunny, size: 60),
                            const Expanded(flex: 1, child: Text(""),),
                            Text("Dark mode", textAlign: TextAlign.center,),
                            const Expanded(flex: 1, child: Text(""),),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(left: 15)),
                    // Language switch
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            buttonColor,
                          ),
                          textStyle: WidgetStateProperty.all<TextStyle>(
                            buttonTextStyleMedium,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                        ),
                        onPressed: () {
                          
                        },
                        child: Column(
                          children: [
                            const Expanded(flex: 1, child: Text(""),),
                            Icon(Icons.language, size: 60),
                            const Expanded(flex: 1, child: Text(""),),
                            Text("Language", textAlign: TextAlign.center,),
                            const Expanded(flex: 1, child: Text(""),),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(left: 15)),
                    // Log out
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            logOutColor,
                          ),
                          textStyle: WidgetStateProperty.all<TextStyle>(
                            buttonTextStyleMedium,
                          ),
                          // foregroundColor: WidgetStateProperty.all<Color>(
                          //   ,
                          // ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                        ),
                        onPressed: () {
                          tripsProvider.clearMyPersonalInfo();
                          Navigator.pushNamed(context, '/');
                        },
                        child: Column(
                          children: [
                            const Expanded(flex: 1, child: Text(""),),
                            Icon(Icons.logout, size: 60),
                            const Expanded(flex: 1, child: Text(""),),
                            Text("LOG OUT", textAlign: TextAlign.center,),
                            const Expanded(flex: 1, child: Text(""),),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}