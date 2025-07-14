import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../providers/provider.dart';
import '../data/styles.dart';
import '../data/urls.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

  List<Map<String, dynamic>> boughtTickets = [];

  
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

  Future<void> _pickDate(BuildContext context, bool isDeparture) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture)
          departureDate = picked;
        else
          arrivalDate = picked;
      });
    }
  }

  void _searchTickets() async {
    if (departurePlanet == null ||
        arrivalPlanet == null ||
        departureDate == null ||
        arrivalDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please, fill all fields')));
      return;
    }

    // 🔧 Заглушка вместо запроса к backend
    tickets = List.generate(
      10,
      (index) => {
        'id': index,
        'departurePlanet': departurePlanet,
        'departureDate': DateFormat('yyyy-MM-dd').format(departureDate!),
        'arrivalPlanet': arrivalPlanet,
        'arrivalDate': DateFormat('yyyy-MM-dd').format(arrivalDate!),
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
                flex: kIsWeb ? 2 : 3,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 352,
                        height: kIsWeb ? 194 : 235,
                        decoration: BoxDecoration(
                          color: buttonColorInvis,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: buttonColor, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: departurePlanet,
                                      dropdownColor: dropdownColor,
                                      borderRadius: BorderRadius.circular(20),
                                      items: planets
                                          .map(
                                            (planet) => DropdownMenuItem(
                                              alignment: Alignment.center,
                                              value: planet,
                                              child: Text(planet, style: basicTextStyle, textAlign: TextAlign.center,)
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) =>
                                          setState(() => departurePlanet = value),
                                      decoration: InputDecoration(
                                        labelText: 'From',
                                        labelStyle: basicTextStyle,
                                        border: OutlineInputBorder( // Стандартная рамка
                                          borderSide: BorderSide(color: Colors.white, width: 2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      )
                                    ),
                                  ),
                                  SizedBox(width: 10, height: 10),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: arrivalPlanet,
                                      dropdownColor: dropdownColor,
                                      borderRadius: BorderRadius.circular(20),
                                      items: planets
                                          .map(
                                            (planet) => DropdownMenuItem(
                                              alignment: Alignment.center,
                                              value: planet,
                                              child: Text(planet, style: basicTextStyle, textAlign: TextAlign.center,)
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) =>
                                          setState(() => arrivalPlanet = value),
                                      decoration: InputDecoration(
                                        labelText: 'To',
                                        labelStyle: basicTextStyle,
                                        border: OutlineInputBorder( // Стандартная рамка
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      )
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
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
                                      onPressed: () => _pickDate(context, true),
                                      child: Text(
                                        departureDate == null
                                            ? 'Departure date'
                                            : DateFormat(
                                                'dd.MM.yyyy',
                                              ).format(departureDate!),
                                        textAlign: TextAlign.center,
                                        style: basicTextStyle,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10, height: 10),
                                  Expanded(
                                    child: TextButton(
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
                                      onPressed: () => _pickDate(context, false),
                                      child: Text(
                                        arrivalDate == null
                                            ? 'Arrival date'
                                            : DateFormat(
                                                'dd.MM.yyyy',
                                              ).format(arrivalDate!),
                                        textAlign: TextAlign.center,
                                        style: basicTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
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
                                onPressed: _searchTickets,
                                child: Text('SEARCH'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (kIsWeb)
                Padding(padding: const EdgeInsets.only(top: 20)),
              Expanded(
                flex: 5,
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
                                // leading: Icon(Icons.public),
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
                                    Padding(padding: const EdgeInsets.only(top: 4)),
                                    if (ticket['sold'] < ticket['total'])
                                      if (!boughtTickets.contains(ticket))
                                        Container(
                                          width: 80,
                                          height: 20,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all<Color>(
                                                buttonColor,
                                              ),
                                              textStyle: WidgetStateProperty.all<TextStyle>(
                                                buttonTextStyleMin,
                                              ),
                                              shape:
                                                  WidgetStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                              side: WidgetStateProperty.all<BorderSide>(
                                                BorderSide(color: Colors.black, width: 1),
                                                  ),
                                            ),
                                            onPressed: () {
                                              boughtTickets.add(ticket);
                                              setState(() {});
                                            },
                                            child: Text('BUY', style: buttonTextStyleMin,),
                                          ),
                                        )
                                  ],
                                ),
                              ),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 10)),
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
