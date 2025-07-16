import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';


class Planet {
  final String id;
  final String imageUrl;
  final Map<String, dynamic> localized;

  Planet({
    required this.id,
    required this.imageUrl,
    required this.localized,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      id: json['id'],
      imageUrl: json['image'],
      localized: {
        'ru': json['ru'],
        'en': json['en'],
      },
    );
  }

  Map<String, dynamic> getData(String localeCode) {
    return localized[localeCode] ?? localized['en'];
  }
}

class PlanetService {
  static Future<List<Planet>> loadPlanets() async {
    try {
      final jsonString = await rootBundle.loadString('lib/assets/solar_system_full_localized.json');
      final List<dynamic> data = json.decode(jsonString);
      return data.map((e) => Planet.fromJson(e)).toList();
    } catch (e) {
      debugPrint('🚨 Ошибка загрузки планет: $e');
      return [];
    }
  }
}
