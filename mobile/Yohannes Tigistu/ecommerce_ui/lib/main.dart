import 'package:ecommerce_ui/pages/addproduct.dart';
import 'package:ecommerce_ui/pages/details.dart';
import 'package:ecommerce_ui/pages/search.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'components/cards.dart';
import 'components/text.dart';
import '../router/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: titleLarge,
          bodyLarge: titlemedium,
          bodyMedium: titlefont,
          bodySmall: smallfont,
          labelSmall: smallfontlight,
          labelMedium: smallfontbold,
          labelLarge: normalfont,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => MyHomePage());
          case '/details':
            return detailsRoute(context);
          case "/search":
            return searchRoute(context);
          case "/addproduct":
            return addproductRoute(context);
        }
      },
    );
  }
}
