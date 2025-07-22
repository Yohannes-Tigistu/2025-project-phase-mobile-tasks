import 'package:flutter/material.dart';

class DetialsPage extends StatelessWidget {
  const DetialsPage({super.key});
  List<Container> _buildsizelist(int count) {
    List<Container> containers = List.generate(count, (int index) {
      return Container(
        height: 60,
        width: 60,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        padding: EdgeInsets.all(19),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment(-0.93, -0.67),
            children: [
              Image.asset("assets/leatherboots.jpg"),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: Color(0xFF3F51F3),
                ),

                style: IconButton.styleFrom(backgroundColor: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Men`s shoe',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                ),
                Text(
                  '⭐ (4.0)',
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Derby Leather Shoes",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    fontFamily: "Poppins",
                  ),
                ),
                Text("\$120", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text(
                  "Size: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 60, // Set a fixed height for the horizontal list
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _buildsizelist(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(49, 12, 49, 12),

                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "DELETE",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(49, 12, 49, 12),
                    backgroundColor: Color(0xFF3F51F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "UPDATE",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
