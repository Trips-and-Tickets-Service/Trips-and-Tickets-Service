import 'package:flutter/material.dart';
import 'package:frontend/data/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Нет данных'));
                      }
                      
                      final planets = snapshot.data!;
                      return ListView.builder(
                        itemCount: planets.length,
                        itemBuilder: (context, index) {
                          final planet = planets[index];
                          final data = planet.getData(languageCode);
                  
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListTile(
                                leading: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Image.asset(getIconOfPlanet(planet.id)),
                                  ]
                                ),
                                title: Text(data['name'], style: basicTextStyle,),
                                subtitle: Text(data['atmosphere'], style: basicTextStyleMin,),
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(data['name']),
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('🌡 ${data['avg_temperature_c']} °C'),
                                        Text('🌍 ${data['moons']} спутников'),
                                        ...List<Widget>.from(
                                          (data['facts'] as List).map((f) => Text('• $f')),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(padding: const EdgeInsets.only(bottom: 5)),
                              if (index != planets.length - 1)
                                Divider(),
                              Padding(padding: const EdgeInsets.only(bottom: 5)),
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