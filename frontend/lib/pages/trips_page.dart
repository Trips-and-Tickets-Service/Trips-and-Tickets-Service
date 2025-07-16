import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/provider.dart';
import '../data/styles.dart';
import '../data/urls.dart';
import '../data/ticket.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  String? departurePlanet;
  String? arrivalPlanet;
  DateTime? departureDate;
  DateTime? arrivalDate;

  List<String> planets = [];

  List<Trip>? tickets = [];

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  void getLanguage() {
    final tripsProvider = Provider.of<TripsProvider>(context, listen: false);
    tripsProvider.loadLanguageAndLightMode();
    _searchTickets(tripsProvider.accessToken);

    setState(() {
      if (tripsProvider.languageCode == 'en') {
      planets = [
        'Mercury',
        'Venus',
        'Earth',
        'Mars',
        'Jupiter',
        'Saturn',
        'Uranus',
        'Neptune',
        'Pluto',
        'Moon',
      ];
    } else if (tripsProvider.languageCode == 'ru') {
      planets = [
        'Меркурий',
        'Венера',
        'Земля',
        'Марс',
        'Юпитер',
        'Сатурн',
        'Уран',
        'Нептун',
        'Плутон',
        'Луна',
      ];
    }
    });
  }

  String getIconOfPlanet(String planet) {
    if (planet.toLowerCase() == 'mercury' || planet.toLowerCase() == 'меркурий') {
      return 'lib/assets/planets/mercury.png';
    } else if (planet.toLowerCase() == 'venus' || planet.toLowerCase() == 'венера') {
      return 'lib/assets/planets/venus.png';
    } else if (planet.toLowerCase() == 'earth' || planet.toLowerCase() == 'земля') {
      return 'lib/assets/planets/earth.png';
    } else if (planet.toLowerCase() == 'mars' || planet.toLowerCase() == 'марс') {
      return 'lib/assets/planets/mars.png';
    } else if (planet.toLowerCase() == 'jupiter' || planet.toLowerCase() == 'юпитер') {
      return 'lib/assets/planets/jupiter.png';
    } else if (planet.toLowerCase() == 'saturn' || planet.toLowerCase() == 'сатурн') {
      return 'lib/assets/planets/saturn.png';
    } else if (planet.toLowerCase() == 'uranus' || planet.toLowerCase() == 'уран') {
      return 'lib/assets/planets/uranus.png';
    } else if (planet.toLowerCase() == 'neptune' || planet.toLowerCase() == 'нептун') {
      return 'lib/assets/planets/neptune.png';
    } else if (planet.toLowerCase() == 'pluto' || planet.toLowerCase() == 'плутон') {
      return 'lib/assets/planets/pluto.png';
    } else if (planet.toLowerCase() == 'moon' || planet.toLowerCase() == 'луна') {
      return 'lib/assets/planets/moon.png';
    } else {
      return 'lib/assets/logo.png';
    }
  }

  void _searchTickets(String accessToken) async {

    tickets = await getMyTrips(accessToken);
  }

  Future<List<Trip>?> getMyTrips(String accessToken) async {
    // Use url from urls.dart file
    final url = Uri.parse(myTripsUrl);
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': accessToken});

    if (response.statusCode == 200 || response.statusCode == 201) {

      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => TicketDetail.fromJson(json).trip).toList();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('You are not logged in.')));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushNamed(context, '/');
      return [];
    }
  }

   @override
  Widget build(BuildContext context) {
    final tripsProvider = Provider.of<TripsProvider>(context);
    tripsProvider.loadLanguageAndLightMode();

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
              Expanded(
                flex: 9,
                child: SizedBox(
                  width: kIsWeb ? 600 : 400,
                  child: ListView.builder(
                    itemCount: tickets!.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets![index];
                      return Column(
                        children: [
                          Card(
                            color: tripsProvider.lightMode == 'dark' ? blackColor : whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: whiteColor,
                                width: 0.6,
                              ),
                            ),
                            child: ListTile(
                              leading: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 103,
                                    height: 103,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: whiteColor,
                                    ),
                                  ),
                                  Image(image: AssetImage(getIconOfPlanet(ticket.to)))
                                ]
                              ),
                              title: Text(
                                '${ticket.from} → ${ticket.to}',
                                style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text( tripsProvider.languageCode == "en" ?
                                'Departure: ${ticket.departureTime.toString().substring(0, 10)}\nArrival: ${ticket.arrivalTime.toString().substring(0, 10)}'
                                : 'Вылет: ${ticket.departureTime.toString().substring(0, 10)}\nПрилет: ${ticket.arrivalTime.toString().substring(0, 10)}',
                                style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor),
                              ),
                              trailing: Column(
                                children: [
                                  Text('${ticket.price} ₽', style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor,)),
                                  Padding(padding: const EdgeInsets.only(top: 5)),
                                  Text('${ticket.availableSeats}/${ticket.maxSeats}', style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor,),),
                                ],
                              ),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.only(bottom: 10)),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}