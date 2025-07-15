import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:frontend/data/styles.dart';
import '../providers/provider.dart';
import '../data/planet.dart';

class PlanetariumPage extends StatefulWidget {
  @override
  State<PlanetariumPage> createState() => _PlanetariumPageState();
}

class _PlanetariumPageState extends State<PlanetariumPage> {

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
  
  @override
  Widget build(BuildContext context) {
    final tripsProvider = Provider.of<TripsProvider>(context);
    tripsProvider.loadLanguageAndLightMode();
    final languageCode = Provider.of<TripsProvider>(context).languageCode;

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
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.only(top: 20)),
              if (!kIsWeb)
                const Expanded(flex: 1, child: Text("")),
              Expanded(
                flex: 13,
                child: SizedBox(
                  width: kIsWeb ? 600 : 400,
                  child: FutureBuilder<List<Planet>>(
                    future: PlanetService.loadPlanets(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text(tripsProvider.languageCode == "en" ? 'Error loading data' : 'Ошибка загрузки: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text(tripsProvider.languageCode == "en" ? 'No data' : 'Нет данных'));
                      }
                      
                      final planets = snapshot.data!;
                      return ListView.builder(
                        itemCount: planets.length ~/ 2,
                        itemBuilder: (context, index) {
                          final planet = planets[index * 2];
                          final nextPlanet = planets[(index * 2) + 1];
                          final data = planet.getData(languageCode);
                          final nextdata = nextPlanet.getData(languageCode);
                  
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 170,
                                    height: 170,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all<Color>(
                                          fieldProfileColorInvis,
                                        ),
                                        shape:
                                            WidgetStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                        side: WidgetStateProperty.all<BorderSide>(
                                          BorderSide(color: invisColor, width: 3),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => planetInfoDialog(data: data),
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 93,
                                                height: 93,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: whiteColor,
                                                ),
                                              ),
                                              Image.asset(getIconOfPlanet(planet.id), width: 90, height: 90,),
                                            ]
                                          ),
                                          Padding(padding: const EdgeInsets.only(top: 10)),
                                          Text(data['name'], style: titleStyle,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.only(left: 30)),
                                  SizedBox(
                                    width: 170,
                                    height: 170,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all<Color>(
                                          fieldProfileColorInvis,
                                        ),
                                        shape:
                                            WidgetStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                        side: WidgetStateProperty.all<BorderSide>(
                                          BorderSide(color: invisColor, width: 3),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => planetInfoDialog(data: nextdata),
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 93,
                                                height: 93,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: whiteColor,
                                                ),
                                              ),
                                              Image.asset(getIconOfPlanet(nextPlanet.id), width: 90, height: 90,),
                                            ]
                                          ),
                                          Padding(padding: const EdgeInsets.only(top: 10)),
                                          Text(nextdata['name'], style: titleStyle,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: const EdgeInsets.only(bottom: 30)),                              
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        )
      )
    );
  }
}

class planetInfoDialog extends StatefulWidget {
  final Map<String, dynamic> data;

  const planetInfoDialog({super.key, required this.data});

  @override
  State<planetInfoDialog> createState() => _PlanetInfoDialogState(data);
}

class _PlanetInfoDialogState extends State<planetInfoDialog> {
  final Map<String, dynamic> data;

  _PlanetInfoDialogState(this.data);

  @override
  Widget build(BuildContext context) {
    final tripsProvider = Provider.of<TripsProvider>(context);
    tripsProvider.loadLanguageAndLightMode();

    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: tripsProvider.lightMode == 'dark' ? blackColor : whiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: whiteColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: 300,
            height: 440,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data['name'], style: tripsProvider.lightMode == 'dark' ? titleStyleBigWhite : titleStyleBigBlack,),
                  Expanded(flex: 2, child: Text("")),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("G:", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                Padding(padding: const EdgeInsets.only(left: 10)),
                                Container(
                                  decoration: BoxDecoration(
                                    color: buttonColorInvis,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: blackColor, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only( left: 5.0, right: 5.0),
                                    child: Text("${data['gravity_m_s2']} m/s2", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                  )
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top: 10)),
                            Row(
                              children: [
                                Text("T:", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                Padding(padding: const EdgeInsets.only(left: 10)),
                                Container(
                                  decoration: BoxDecoration(
                                    color: buttonColorInvis,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: blackColor, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only( left: 5.0, right: 5.0),
                                    child: Text("${data['avg_temperature_c']} °C", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top: 10)),
                            Row(
                              children: [
                                Text(tripsProvider.languageCode == "en" ? "Year:" : "Год:", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                Padding(padding: const EdgeInsets.only(left: 10)),
                                Container(
                                  decoration: BoxDecoration(
                                    color: buttonColorInvis,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: blackColor, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only( left: 5.0, right: 5.0),
                                    child: Text("${data['length_of_year_days']} d", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top: 10)),
                            Row(
                              children: [
                                Text(tripsProvider.languageCode == "en" ? "Moons:" : "Луны:", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                Padding(padding: const EdgeInsets.only(left: 10)),
                                Container(
                                  decoration: BoxDecoration(
                                    color: buttonColorInvis,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: blackColor, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only( left: 5.0, right: 5.0),
                                    child: Text("${data['moons']}", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text("R:", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                Padding(padding: const EdgeInsets.only(left: 10)),
                                Container(
                                  decoration: BoxDecoration(
                                    color: buttonColorInvis,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: blackColor, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only( left: 5.0, right: 5.0),
                                    child: Text("${data['mean_radius_km']} km", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack,),
                                  )
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top: 10)),
                            Row(
                              children: [
                                Text("M:", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                Padding(padding: const EdgeInsets.only(left: 10)),
                                Container(
                                  decoration: BoxDecoration(
                                    color: buttonColorInvis,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: blackColor, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only( left: 5.0, right: 5.0),
                                    child: Text("${data['mass_kg']} kg", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack,),
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top: 10)),
                            Row(
                              children: [
                                Text(tripsProvider.languageCode == "en" ? "Day:" : "День:", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack),
                                Padding(padding: const EdgeInsets.only(left: 10)),
                                Container(
                                  decoration: BoxDecoration(
                                    color: buttonColorInvis,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: blackColor, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only( left: 5.0, right: 5.0),
                                    child: Text("${data['length_of_day_hours']} h", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack,),
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top: 35)),
                          ],
                        ),
                      )
                    ],
                  ),
                  Expanded(flex: 1, child: Text("")),
                  Row(
                    children: [
                      Container(
                        width: 97,
                        height: 2,
                        decoration: BoxDecoration(
                          color: tripsProvider.lightMode == 'dark' ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Text(tripsProvider.languageCode == "en" ? " Atmosphere " : "  Атмосфера  ", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack,),
                      Container(
                        width: 97,
                        height: 2,
                        decoration: BoxDecoration(
                          color: tripsProvider.lightMode == 'dark' ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  Expanded(flex: 1, child: Text("")),
                  Text("${data['atmosphere']}", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack,),
                  Expanded(flex: 1, child: Text("")),
                  Row(
                    children: [
                      Container(
                        width: tripsProvider.languageCode == "en" ? 124 : 122,
                        height: 2,
                        decoration: BoxDecoration(
                          color: tripsProvider.lightMode == 'dark' ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Text(tripsProvider.languageCode == "en" ? " Facts " : " Факты ", style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack,),
                      Container(
                        width: tripsProvider.languageCode == "en" ? 124 : 121,
                        height: 2,
                        decoration: BoxDecoration(
                          color: tripsProvider.lightMode == 'dark' ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  Expanded(flex: 1, child: Text("")),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List<Widget>.from(
                        (data['facts'] as List).map((f) => Text('• $f', textAlign: TextAlign.start, style: tripsProvider.lightMode == 'dark' ? basicTextStyle : basicTextStyleBlack,)),
                      ),
                    ],
                  ),
                  Expanded(flex: 1, child: Text("")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}