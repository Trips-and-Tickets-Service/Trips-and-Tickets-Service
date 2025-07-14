import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../providers/provider.dart';
import '../data/styles.dart';
import '../data/urls.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for input fields
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();

  // Variables for showing error messages in the UI
  String postText = '';
  String errNickname = '';
  String errEmail = '';
  String errPassword = '';
  String errRepeatedPassword = '';
  bool regSuccess = false;
  String accessToken = '';

  bool obscure = true;

  int ID = -1;

  bool logSuccess = false; // ⭐️ Вернуть false

  /// Sends a POST request to the server to register a new user.
  ///
  /// If the registration is successful, it sets `regSuccess` to `true` and
  /// updates the `ID` field with the user's ID from the response.
  ///
  /// If the registration fails due to an already used email, it sets `regSuccess`
  /// to `false` and updates `errEmail` with an error message.

  Future<void> signUp(String nickname, String email, String password, String language) async {
    final url = Uri.parse(signUpUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
      body: jsonEncode({
        'name': nickname,
        'email': email,
        'password': password,
      }),
    );
    final responseBody = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        regSuccess = true;
        accessToken = responseBody['access_token'];
      });
    } else {
      setState(() {
        regSuccess = false;
        errEmail = language == 'en' ? 'already in use' : 'уже используется';
      });
    }
  }

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
              // Red7 logo
              Image(
                image: AssetImage('lib/assets/logo.png'),
                width: 115,
                height: 115,
              ),
              const Expanded(flex: 2, child: Text("")),
              Text(tripsProvider.languageCode == "en" ? "Sign Up" : "Регистрация", style: titleStyle),
              const Expanded(flex: 1, child: Text("")),
              Container(
                width: 352,
                height: 415,
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
                        Text(tripsProvider.languageCode == "en" ? "Name" : "Имя", style: basicTextStyle,),
                        const Expanded(flex: 1, child: Text("")),
                        Text(errNickname, style: errorTextStyle, textAlign: TextAlign.right),
                        Padding(padding: const EdgeInsets.only(right: 47)),
                      ]
                    ),
                    Padding(padding: const EdgeInsets.only(top: 5)),
                    // Input field for nickname
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
                        Text(tripsProvider.languageCode == "en" ? "Email address" : "Почта", style: basicTextStyle),
                        const Expanded(flex: 1, child: Text("")),
                        Text(errEmail, style: errorTextStyle, textAlign: TextAlign.right),
                        Padding(padding: const EdgeInsets.only(right: 47)),
                      ]
                    ),
                    Padding(padding: const EdgeInsets.only(top: 5)),
                    // Input field for email
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
                        controller: controller2,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 17)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 47)),
                        Text(tripsProvider.languageCode == "en" ? "Password" : "Пароль", style: basicTextStyle),
                        const Expanded(flex: 1, child: Text("")),
                        Text(errPassword, style: errorTextStyle, textAlign: TextAlign.right),
                        Padding(padding: const EdgeInsets.only(right: 47)),
                      ]
                    ),
                    Padding(padding: const EdgeInsets.only(top: 5)),
                    // Input field for password
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
                        controller: controller3,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 17)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 47)),
                        Text(tripsProvider.languageCode == "en" ? "Repeat password" : "Повторите пароль", style: basicTextStyle),
                        const Expanded(flex: 1, child: Text("")),
                        Text(errRepeatedPassword, style: errorTextStyle, textAlign: TextAlign.right),
                        Padding(padding: const EdgeInsets.only(right: 47)),
                      ]
                    ),
                    Padding(padding: const EdgeInsets.only(top: 5)),
                    // Input field for repeated password
                    Container(
                      width: 260,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        obscureText: obscure,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        controller: controller4,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 30)),
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
                          onPressed: () async{
                            // Reset error messages
                            setState(() {
                              postText = '';
                              errNickname = '';
                              errEmail = '';
                              errPassword = '';
                              errRepeatedPassword = '';
                              regSuccess = false;
                            });
                            // Check if all fields are filled
                            if (controller.text.isEmpty || controller2.text.isEmpty || controller3.text.isEmpty || controller4.text.isEmpty) {
                              setState(() {
                                postText = tripsProvider.languageCode == "en" ? 'All fields are required' : 'Все поля обязательны';
                              });
                              return;
                            }
                            // Check if nickname is valid
                            else if (controller.text.length > 16) {
                              setState(() {
                                errNickname = tripsProvider.languageCode == "en" ? '1-16 symbols' : '1-16 символов';
                              });
                              return;
                            }
                            // Check if email is valid
                            else if (!EmailValidator.validate(controller2.text)) {
                              setState(() {
                                errEmail = tripsProvider.languageCode == "en" ? 'Invalid email' : 'Неверная почта';
                              });
                              return;
                            }
                            // Check if password is valid
                            else if (controller3.text.length > 16 || controller3.text.length < 6) {
                              setState(() {
                                errPassword = tripsProvider.languageCode == "en" ? '6-16 symbols' : '6-16 символов';
                              });
                              return;
                            }
                            // Check if repeated password is valid
                            else if (controller3.text != controller4.text) {
                              setState(() {
                                errRepeatedPassword = tripsProvider.languageCode == "en" ? 'Different' : 'Различаются';
                              });
                              return;
                            } 
                            else {
                              // If all fields are filled and valid, send http-request to sign up
                              await signUp(controller.text, controller2.text, controller3.text, tripsProvider.languageCode);
                              // If sign up was successful, navigate to main menu
                              if (regSuccess) {
                                // TODO: раздекодировать из accessToken (ID)
                                // tripsProvider.myID = ID;
                                tripsProvider.myName = controller.text;
                                tripsProvider.email = controller2.text;
                                tripsProvider.password = controller3.text;
                                tripsProvider.accessToken = accessToken;
                                tripsProvider.saveMyPersonalInfo();
                                Navigator.pushNamed(context, '/mainmenu');
                              }
                            }
                          },
                          child: Text(tripsProvider.languageCode == "en" ? 'SIGN  UP' : 'РЕГИСТРАЦИЯ'),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.only(top: 5)),
                      Text(postText, style: errorTextStyle,),
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