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
          seedColor: const Color.fromARGB(255, 234, 24, 24),
          primary: const Color.fromARGB(255, 234, 24, 24),
          secondary: const Color.fromARGB(255, 234, 24, 24),
        ),
      ),
      home: const HomePage(),
    );
  }
}
