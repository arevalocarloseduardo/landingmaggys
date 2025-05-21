import 'package:flutter/material.dart';
import 'sections/hero_section.dart';
import 'sections/product_section.dart';
import 'sections/info_section.dart';
import 'sections/contact_section.dart';
import 'semicircle_clipper.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maggy\'s fuente de soda',
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC84C4C),
          primary: const Color(0xFFC84C4C),
          secondary: const Color(0xFFC84C4C),
        ),
      ),
      home: const HomePage(),
    );
  }
}
