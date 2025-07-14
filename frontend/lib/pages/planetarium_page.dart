import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider.dart';
import '../data/planet.dart';

class PlanetariumPage extends StatefulWidget {
  @override
  State<PlanetariumPage> createState() => _PlanetariumPageState();
}

class _PlanetariumPageState extends State<PlanetariumPage> {
  @override
  Widget build(BuildContext context) {
    final languageCode = Provider.of<TripsProvider>(context).languageCode;

    return FutureBuilder<List<Planet>>(
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

            return ListTile(
              // leading: Image.network(planet.imageUrl),
              title: Text(data['name']),
              subtitle: Text(data['atmosphere']),
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(data['name']),
                  content: Column(
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
            );
          },
        );
      },
    );
  }
}