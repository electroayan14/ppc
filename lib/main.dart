import 'package:flutter/material.dart';
import 'package:ppc/color_scheme/light.dart';
import 'package:ppc/pages/home_page.dart';
import 'package:ppc/pages/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final token = prefs.getString('token');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: universalTheme,
      home: (token == null) ? const HomePage() : const Services(),
    );
  }
}
