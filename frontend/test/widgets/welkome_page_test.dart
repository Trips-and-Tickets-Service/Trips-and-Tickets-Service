import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/pages/welkome_page.dart';
import 'package:frontend/providers/provider.dart';

void main() {
  testWidgets('WelkomePage should display all main widgets', (WidgetTester tester) async {
    // Создаем тестовый виджет
    await tester.pumpWidget(
      ChangeNotifierProvider<TripsProvider>(
        create: (context) => TripsProvider(),
        child: const MaterialApp(
          home: WelkomePage(),
        ),
      ),
    );

    // Проверяем основные элементы интерфейса
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    
    // Проверяем фоновое изображение
    final container = tester.widget<Container>(find.byType(Container).first);
    expect(container.decoration, isA<BoxDecoration>());
    expect((container.decoration as BoxDecoration).image, isNotNull);
    
    // Проверяем логотип
    expect(find.byType(Image), findsOneWidget);
    
    // Проверяем кнопку переключения языка
    expect(find.byIcon(Icons.language), findsOneWidget);
    
    // Проверяем кнопку перехода вперед
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    
    // Проверяем кнопки SIGN IN и SIGN UP
    expect(find.byType(ElevatedButton), findsNWidgets(2));
    expect(find.textContaining('SIGN'), findsNWidgets(2));
  });
}