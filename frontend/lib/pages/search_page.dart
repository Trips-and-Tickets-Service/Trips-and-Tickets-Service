import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/provider.dart';
import '../data/styles.dart';
import '../data/urls.dart';
import '../data/ticket.dart';

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

  DateTime? pickedFrom;
  DateTime? pickedTo;

  List<String> planets = [];

  List<Ticket>? tickets = [];

  List<Ticket> boughtTickets = [];

  @override
  void initState() {
    super.initState();
    getLanguage();
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

  Future<void> _pickDateFrom(BuildContext context, bool isDeparture) async {
    pickedFrom = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: pickedTo ?? DateTime(2030),
      // lastDate: DateTime(2030),
    );
    if (pickedFrom != null) {
      setState(() {
        if (isDeparture)
          departureDate = pickedFrom;
        else
          arrivalDate = pickedFrom;
      });
    }
  }
  

  Future<void> _pickDateTo(BuildContext context, bool isDeparture) async {
    pickedTo = await showDatePicker(
      context: context,
      initialDate: pickedFrom ?? DateTime.now(),
      firstDate: pickedFrom ?? DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedTo != null) {
      setState(() {
        if (isDeparture)
          departureDate = pickedTo;
        else
          arrivalDate = pickedTo;
      });
    }
  }

  void _searchTickets(String accessToken) async {
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
    // tickets = List.generate(
    //   10,
    //   (index) => {
    //     'id': index,
    //     'departurePlanet': departurePlanet,
    //     'departureDate': DateFormat('yyyy-MM-dd').format(departureDate!),
    //     'arrivalPlanet': arrivalPlanet,
    //     'arrivalDate': DateFormat('yyyy-MM-dd').format(arrivalDate!),
    //     'sold': 50 + index * 10 < 100 ? 50 + index * 10 : 100,
    //     'total': 100,
    //     'price': 4200 + index * 500,
    //   },
    // );

    tickets = await fetchTickets(
      departurePlanet: departurePlanet!,
      arrivalPlanet: arrivalPlanet!,
      departureDate: departureDate!,
      arrivalDate: arrivalDate!,
      accessToken: accessToken
    );

    setState(() {});
  }

  Future<List<Ticket>?> fetchTickets({
  required String departurePlanet,
  required String arrivalPlanet,
  required DateTime departureDate,
  required DateTime arrivalDate,
  required String accessToken
}) async {
  final uri = Uri.parse('http://localhost:8080/api/trips/schedule').replace(
    queryParameters: {
      'from': departurePlanet.toLowerCase(),
      'to': arrivalPlanet.toLowerCase(),
      'departure_time': (departureDate.millisecondsSinceEpoch ~/ 1000).toString(), // UNIX time (seconds)
      'arrival_time': (arrivalDate.millisecondsSinceEpoch ~/ 1000).toString(),
    },
  );

  final response = await http.get(
    uri,
    headers: {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': accessToken},
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Ticket.fromJson(json)).toList();
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
    // tripsProvider.loadAccessToken();

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
                          border: Border.all(color: buttonColorW, width: 1),
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
                                        labelText: tripsProvider.languageCode == "en" ? 'From' : 'Откуда',
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
                                        labelText: tripsProvider.languageCode == "en" ? 'To' : 'Куда',
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
                                      onPressed: () => _pickDateFrom(context, true),
                                      child: Text(
                                        departureDate == null
                                            ? (tripsProvider.languageCode == "en" ? 'Departure date' : 'Дата вылета')
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
                                      onPressed: () => _pickDateTo(context, false),
                                      child: Text(
                                        arrivalDate == null
                                            ? (tripsProvider.languageCode == "en" ? 'Arrival date' : 'Дата прилета')
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
                                    tripsProvider.lightMode == 'dark' ? blackColor : buttonColorW,
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
                                  _searchTickets(tripsProvider.accessToken);
                                },
                                child: Text(tripsProvider.languageCode == "en" ? 'SEARCH' : 'ПОИСК',
                                    style: tripsProvider.lightMode == 'dark' ?  buttonTextStyleInvis : null
                                ),
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
                                // leading: Icon(Icons.public),
                                leading: Image(image: AssetImage(getIconOfPlanet(ticket.to))),
                                title: Text(
                                  '${ticket.from} → ${ticket.to}',
                                  style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text( tripsProvider.languageCode == "en" ?
                                  'Departure: ${ticket.departureTime}\nArrival: ${ticket.arrivalTime}'
                                  : 'Вылет: ${ticket.departureTime}\nПрилет: ${ticket.arrivalTime}',
                                  style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    if ((ticket.availableSeats < 1) || boughtTickets.contains(ticket))
                                      Column(
                                        children: [
                                          Text('${ticket.price} ₽', style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor,)),
                                          Padding(padding: const EdgeInsets.only(top: 5)),
                                          Text('${ticket.availableSeats}/${ticket.maxSeats}', style: TextStyle(color: tripsProvider.lightMode == 'dark' ? whiteColor : blackColor,),),
                                        ],
                                      ),
                                    if ((ticket.availableSeats > 0) && !boughtTickets.contains(ticket))
                                      SizedBox(
                                        width: 100,
                                        height: 48,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all<Color>(
                                              buttonColorW,
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
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text('${ticket.price} ₽', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                              Padding(padding: const EdgeInsets.only(top: 5)),
                                              Text('${ticket.availableSeats}/${ticket.maxSeats}'),
                                            ],
                                          ),
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
                IconButton(onPressed: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Access tocken: ${tripsProvider.accessToken}'))), 
                icon: Icon(Icons.info, color: invisColor,)),
            ],
          ),
        ),
      ),
    );
  }
}
