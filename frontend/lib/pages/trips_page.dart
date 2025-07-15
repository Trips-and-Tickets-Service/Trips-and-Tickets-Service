import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../providers/provider.dart';
import '../data/styles.dart';
import '../data/urls.dart';

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

  List<Map<String, dynamic>> tickets = [];

  @override
  void initState() {
    super.initState();
    getLanguage();
    _searchTickets();
  }

  void getLanguage() {
    final tripsProvider = Provider.of<TripsProvider>(context, listen: false);
    tripsProvider.loadLanguageAndLightMode();

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

  void _searchTickets() async {

    // 🔧 Заглушка вместо запроса к backend
    tickets = List.generate(
      5,
      (index) => {
        'id': planets[index],
        'departurePlanet': planets[index],
        'departureDate': '2025-07-14',
        'arrivalPlanet': planets[(index + 1) % planets.length],
        'arrivalDate': '2025-07-14',
        'sold': 50 + index * 10 < 100 ? 50 + index * 10 : 100,
        'total': 100,
        'duration': '2д 4ч',
        'price': 4200 + index * 500,
      },
    );

    setState(() {});
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
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
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
                                  Image(image: AssetImage(getIconOfPlanet(ticket['arrivalPlanet'])))
                                ]
                              ),
                              title: Text(
                                '${ticket['departurePlanet']} → ${ticket['arrivalPlanet']}',
                                style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text( tripsProvider.languageCode == "en" ?
                                'Departure: ${ticket['departureDate']}\nArrival: ${ticket['arrivalDate']}'
                                : 'Вылет: ${ticket['departureDate']}\nПрилет: ${ticket['arrivalDate']}',
                                style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor),
                              ),
                              trailing: Column(
                                children: [
                                  Text('${ticket['price']} ₽', style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor,)),
                                  Padding(padding: const EdgeInsets.only(top: 5)),
                                  Text('${ticket['sold']}/${ticket['total']}', style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor,),),
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