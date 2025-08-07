import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entity/product.dart';
import '../Data/products.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({super.key});

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  final _formkey = GlobalKey<FormState>();
  var catagory = TextEditingController();
  var price = TextEditingController();
  var name = TextEditingController();
  var description = TextEditingController();
  String? _catagory ;
  String? _price ;
  String? _name ;
  String? _description ;


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
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  shadowColor: Colors.white,
                  borderOnForeground: false,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Icon(Icons.image_outlined, size: 60, grade: 3),
                      SizedBox(height: 10),
                      Text(
                        "upload image",
                        style: TextStyle(fontSize: 16, fontFamily: "Mono-sans"),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text("name", style: Theme.of(context).textTheme.labelLarge),
                SizedBox(height: 5),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  controller: name,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(20, 117, 115, 115),
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 15),
                Text("Cataogry", style: Theme.of(context).textTheme.labelLarge),
                SizedBox(height: 5),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                  controller: catagory,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(20, 117, 115, 115),
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 15),
                Text("price", style: Theme.of(context).textTheme.labelLarge),
                SizedBox(height: 5),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  controller: price,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.attach_money),
                    fillColor: const Color.fromARGB(20, 117, 115, 115),
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "description",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(height: 5),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  controller: description,
                  maxLines: 4,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(20, 117, 115, 115),
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 10),
                FilledButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      Product newprod = Product();
                      newprod.setName(name.text);
                      newprod.setDescription(description.text);
                      newprod.setPrice(double.parse(price.text));
                      newprod.setCatagory(catagory.text);
                      productcataloge.addproduct(newprod);
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("product successfully added",style: Theme.of(context).textTheme.labelLarge)
                      ,
                      duration: Duration(seconds: 2),
                      onVisible: () {
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushNamed(context, '/');
                        });
                      },
                      ));
                    }
                  },
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
                OutlinedButton(
                  onPressed: () {
                    
                  },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
