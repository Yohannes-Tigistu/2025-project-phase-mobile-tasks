import 'package:flutter/material.dart';
import '../components/cards.dart';

class DetialsPage extends StatelessWidget {
  const DetialsPage({super.key});

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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 15),
                Row(
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
                SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Derby Leather Shoes",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "\$120",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                SizedBox(height: 15),

                Row(
                  children: [
                    Text(
                      "Size: ",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 60, // Set a fixed height for the horizontal list
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: buildsizelist(10),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                SizedBox(height: 25),
                Row(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
