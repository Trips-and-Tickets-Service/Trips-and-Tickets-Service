import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

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

  List<String> planets = [
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

  List<Map<String, dynamic>> tickets = [];

  @override
  void initState() {
    super.initState();
    _searchTickets();
  }

  String getIconOfPlanet(String planet) {
    if (planet.toLowerCase() == 'mercury') {
      return 'lib/assets/planets/mercury.png';
    } else if (planet.toLowerCase() == 'venus') {
      return 'lib/assets/planets/venus.png';
    } else if (planet.toLowerCase() == 'earth') {
      return 'lib/assets/planets/earth.png';
    } else if (planet.toLowerCase() == 'mars') {
      return 'lib/assets/planets/mars.png';
    } else if (planet.toLowerCase() == 'jupiter') {
      return 'lib/assets/planets/jupiter.png';
    } else if (planet.toLowerCase() == 'saturn') {
      return 'lib/assets/planets/saturn.png';
    } else if (planet.toLowerCase() == 'uranus') {
      return 'lib/assets/planets/uranus.png';
    } else if (planet.toLowerCase() == 'neptune') {
      return 'lib/assets/planets/neptune.png';
    } else if (planet.toLowerCase() == 'pluto') {
      return 'lib/assets/planets/pluto.png';
    } else if (planet.toLowerCase() == 'moon') {
      return 'lib/assets/planets/moon.png';
    } else {
      return 'lib/assets/logo.png';
    }
  }

  void _searchTickets() async {

    // 🔧 Заглушка вместо запроса к backend
    tickets = List.generate(
      10,
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
    final gameProvider = Provider.of<TripsProvider>(context);

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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              leading: Image(image: AssetImage(getIconOfPlanet(ticket['arrivalPlanet']))),
                              title: Text(
                                '${ticket['departurePlanet']} → ${ticket['arrivalPlanet']}',
                              ),
                              subtitle: Text(
                                'Departure: ${ticket['departureDate']}\nArrival: ${ticket['arrivalDate']}',
                              ),
                              trailing: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Text('${ticket['price']} ₽'),
                                  Text(
                                    '${ticket['sold']}/${ticket['total']} sold',
                                  ),
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