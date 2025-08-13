import 'package:flutter/material.dart';
import '../pages/details.dart';
import '../pages/search.dart';
import '../pages/addproduct.dart';
import '../widgets/cards.dart';


Route detailsRoute(context) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryanimation) => DetialsPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        ),
        child: child,
      );
    },
  );
}

Route searchRoute(context) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryanimation) =>
        Search(buildCardList: (int count) => buildcardlis(context, count)),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0, 1);
      const end = Offset.zero;
      const curve = Curves.easeIn;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

Route addproductRoute(context) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryanimation) => Addproduct(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.easeIn;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
