import 'package:flutter/material.dart';

class Addproduct extends StatelessWidget {
  const Addproduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_sharp, color: Color(0xFF3F51F3)),

          style: IconButton.styleFrom(backgroundColor: Colors.white),
        ),

        title: Container(
          margin: EdgeInsets.only(left: 87),
          child: Text("Add Product ", style: TextStyle(fontSize: 23)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shadowColor: Colors.white,
              borderOnForeground: false,
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Icon(Icons.image_outlined, size: 60, grade: 3),
                  SizedBox(height: 10),
                  Text(
                    "upload image",
                    style: TextStyle(fontSize: 16, fontFamily: "Mono-sans"),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("name"),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                fillColor: const Color.fromARGB(20, 117, 115, 115),
                filled: true,
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 15),
            Text("Cataogry"),
            SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                fillColor: const Color.fromARGB(20, 117, 115, 115),
                filled: true,
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 15),
            Text("price"),
            SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.attach_money),
                fillColor: const Color.fromARGB(20, 117, 115, 115),
                filled: true,
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 15),
            Text("description"),
            SizedBox(height: 5),
            TextField(
              maxLines: 6,

              decoration: InputDecoration(
                fillColor: const Color.fromARGB(20, 117, 115, 115),
                filled: true,

                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 20),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                padding: EdgeInsets.fromLTRB(49, 17, 49, 17),
                backgroundColor: Color(0xFF3F51F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "ADD",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(49, 17, 49, 17),

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
          ],
        ),
      ),
    );
  }
}
