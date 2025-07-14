import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../providers/provider.dart';
import '../data/styles.dart';
import '../data/urls.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers for email and password
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  // Fields for showing info and errors in the UI
  String postText = '';
  String errEmail = '';
  bool logSuccess = true;
  
  String nickname = 'None';
  int ID = -1;

  bool obscure = true; // ⭐️ Вернуть false

  /// Sends a POST request to the server to sign in the user.
  ///
  /// If the request is successful, it sets `logSuccess` to `true` and
  /// updates the `nickname` and `ID` fields with the values from the response.
  ///
  /// If the request fails, it sets `logSuccess` to `false` and sets `postText`
  /// to an error message.
  Future<void> signIn(String email, String password) async {
    // Use url from urls.dart file
    final url = Uri.parse('TODO');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        logSuccess = true;
      });
    } else {
      setState(() {
        logSuccess = false;
        postText = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripsProvider = Provider.of<TripsProvider>(context);

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
              Padding(padding: const EdgeInsets.only(top: 15)),
              if (!kIsWeb)
                const Expanded(flex: 2, child: Text("")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.only(left: 15)),
                  // Button to return to WelkomePage
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_rounded, size: 44, color: buttonColor),
                    ),
                  ),
                  const Expanded(flex: 1, child: Text("")),
                ],
              ),
              // Show Logo
              Image(
                image: AssetImage('lib/assets/logo.png'),
                width: 115,
                height: 115,
              ),
              const Expanded(flex: 2, child: Text("")),
              Text("Sign In", style: titleStyle),
              const Expanded(flex: 1, child: Text("")),
              Container(
                width: 352,
                height: 260,
                decoration: BoxDecoration(
                  color: buttonColorInvis,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: buttonColor, width: 1),
                ),
                child: Column(
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 47)),
                        Text("Email address", style: basicTextStyle,),
                        const Expanded(flex: 1, child: Text("")),
                        Text(errEmail, style: errorTextStyle, textAlign: TextAlign.right),
                        Padding(padding: const EdgeInsets.only(right: 47)),
                      ]
                    ),
                    Padding(padding: const EdgeInsets.only(top: 5)),
                    // Text field for email
                    Container(
                      width: 260,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        controller: controller,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 17)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 47)),
                        Text("Password", style: basicTextStyle),
                        const Expanded(flex: 1, child: Text("")),
                      ]
                    ),
                    Padding(padding: const EdgeInsets.only(top: 5)),
                    // Text field for password
                    Container(
                      width: 260,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        obscureText: obscure,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                          ),
                        ),
                        controller: controller2,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 30)),
                    // Sign in button
                    SizedBox(
                        width: 260,
                        height: 35,
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
                          onPressed: () async {
                            // Reset error messages
                            setState(() {
                              postText = '';
                              errEmail = '';
                            });
                            // Check if all fields are filled
                            if (controller.text.isEmpty || controller2.text.isEmpty) {
                              setState(() {
                                postText = 'All fields are required';
                              });
                              return;
                            } else if (!EmailValidator.validate(controller.text)) { // Check if email is valid
                              setState(() {
                                errEmail = 'Invalid email';
                              });
                              return;
                            } else {
                              // If all fields are filled and email is valid, send http-request to sign in
                              // await signIn(controller.text, controller2.text);
                              // If sign in was successful, navigate to main menu
                              if (logSuccess) {
                                // gameProvider.myID = ID;
                                // gameProvider.myName = nickname;
                                // gameProvider.email = controller.text;
                                // gameProvider.password = controller2.text;
                                // gameProvider.saveMyPersonalInfo();
                                Navigator.pushNamed(context, '/mainmenu');
                              }
                            }
                          },
                          child: const Text('SIGN  IN'),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 5)),
                      // For error messages
                      Text(postText, style: errorTextStyle,),
                      Padding(padding: const EdgeInsets.only(top: 5)),
                  ],
                ),
              ),
              const Expanded(flex: 14, child: Text("")),
            ],
          ),
        ),
      ),
    );
  }
}
