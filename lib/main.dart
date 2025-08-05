import 'package:entretien/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp ({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      locale: const Locale('fr'), // Pour forcer le français
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
        // Ajoute d'autres locales si nécessaire
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
          colorSchemeSeed: Colors.indigoAccent,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.amberAccent,
            labelStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,           // Couleur de fond
              foregroundColor: Colors.black,          // Couleur du texte
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',                    // solon'ny home miantso ny page d'acceuil taloha
      routes: {                             //c'est de MAP où on lister les fenetres navigable dans notre application
        '/' : (context) => const MyHomePage(),
      },

    );
  }
}

