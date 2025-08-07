import 'package:flutter/material.dart';
import 'package:ecommerce_ui/pages/addproduct.dart';
import 'package:ecommerce_ui/pages/details.dart';
import 'package:ecommerce_ui/pages/search.dart';
import '../components/cards.dart';
import '../components/text.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: normalfont,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.only(right: 15),
                // color: const Color.fromARGB(221, 35, 34, 34),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 183, 187, 188),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "july 21, 2025",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        "Yohannes",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_outlined),
                style: IconButton.styleFrom(
                  side: BorderSide(width: 1, color: Colors.black38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Availiable Products",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/search");
                    },
                    icon: Icon(Icons.search),
                    style: IconButton.styleFrom(
                      side: BorderSide(color: Colors.grey, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Expanded(
                child: Stack(
                  alignment: Alignment(0.98, 0.95),
                  children: [
                    GridView.count(
                      crossAxisCount: 1,
                      mainAxisSpacing: 7,
                      childAspectRatio: 9 / 7,
                      children: buildcardlis(context, 20),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/addproduct");
                      },
                      icon: Icon(Icons.add, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF3F51F3),
                        iconSize: 45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
