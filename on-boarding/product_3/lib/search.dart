import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final List<Card> Function(int count) buildCardList;

  const Search({super.key, required this.buildCardList});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  RangeValues _currentRange = RangeValues(20, 80);

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
          margin: EdgeInsets.only(left: 72),
          child: Text("Search  Product ", style: TextStyle(fontSize: 23)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hint: Text(
                        "Leather",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.5),
                      ),

                      suffixIcon: Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF3F51F3),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 7),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),

                    backgroundColor: Color(0xFF3F51F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 7,
                childAspectRatio: 9 / 6.5,
                children: widget.buildCardList(10),
              ),
            ),
            Container(
              height: 300,
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category"),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),

                        borderSide: BorderSide(
                          color:
                              Colors.blue, // Change this to your desired color
                          width: 0.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("price"),
                  SizedBox(height: 10),
                  RangeSlider(
                  
                    
                    activeColor: Color(0xFF3F51F3),
                    inactiveColor: Colors.black12,
                    values: _currentRange,
                    min: 0,
                    max: 100,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRange = values;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(49, 12, 49, 12),
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
