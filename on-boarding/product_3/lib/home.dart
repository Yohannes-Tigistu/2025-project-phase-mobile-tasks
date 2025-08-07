import 'package:flutter/material.dart';
import 'package:product_3/addproduct.dart';
import 'package:product_3/details.dart';
import 'package:product_3/search.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  List<Card> _buildcardlis(BuildContext context, int count) {
    List<Card> cards = List.generate(count, (int index) {
      return Card(
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.black45,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetialsPage()),
            );
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        fontFamily: "Poppins",
                      ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '⭐ (4.0)',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 15),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Hello,",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 18,
                      ),
                    ),
                    Text("Yohannes", style: TextStyle(fontSize: 18)),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(
                          buildCardList: (int count) =>
                              _buildcardlis(context, count),
                        ),
                      ),
                    );
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
                    children: _buildcardlis(context, 20),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Addproduct()),
                      );
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
    );
  }
}
