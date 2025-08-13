
import 'package:flutter/material.dart';

import '../pages/details.dart';

List<Card> buildcardlis(BuildContext context, int count) {
  List<Card> cards = List.generate(count, (int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.black45,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/details");
        },
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 25 / 12,
              child: Image.asset(
                "assets/leatherboots.jpg",
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Derby Leather Shoes",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text("\$120", style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Men`s shoe',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    '⭐ (4.0)',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
  return cards;
}

List<Container> buildsizelist(int count) {
  List<Container> containers = List.generate(count, (int index) {
    return Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.symmetric(vertical: 19, horizontal: 19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 235, 232, 232),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Text(
        "${39 + index}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  });
  return containers;
}

Route _createDetailsRoute() {
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

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
