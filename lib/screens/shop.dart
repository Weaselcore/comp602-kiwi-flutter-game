import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ShopScreen extends StatelessWidget {
   const ShopScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

   return MaterialApp(
     home: Scaffold(

       backgroundColor: Colors.grey[400],

       appBar: AppBar(
         leading: Icon(Icons.store_rounded),
         title: const Text('Shop', style: TextStyle(fontWeight: FontWeight.bold),),
       ),

       //Put the user credits before grid

       body: SafeArea(
         child: Container(
           padding: EdgeInsets.all(20.0),
           child: Column(
             children: <Widget>[
               Container(
                 width: double.infinity,
                 height: 150,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20.0),
                   color: Colors.teal[100]
                 ),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Text("Kiwi Coins = 1000", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black)),
                     SizedBox(height: 5,),
                     Container(
                       height: 50,
                       margin: EdgeInsets.symmetric(horizontal: 80.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10.0),
                         color: Colors.teal[500]
                       ),
                       child: Center(child: Text("Buy More Coins", style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                       ),))
                     ),
                     SizedBox(height: 30,),
                   ],
                 )
               ),
               Expanded(
                 child: GridView.count(
                   crossAxisCount: 2,
                   padding: EdgeInsets.all(20.0),
                   crossAxisSpacing: 20,
                   mainAxisSpacing: 20,
                   children: <Widget>[
                     Container(
                       padding: const EdgeInsets.all(8.0),
                       child: DefaultTextStyle(
                         style: TextStyle(
                           fontSize: 20,
                           color: Colors.black,
                         ), child: Text ("Shop Item 1"),
                       ),
                       color: Colors.teal,
                     ),
                     Container(
                       padding: const EdgeInsets.all(8.0),
                       child: DefaultTextStyle(
                         style: TextStyle(
                           fontSize: 20,
                           color: Colors.black,
                         ), child: Text ("Shop Item 2"),
                       ),
                       color: Colors.teal,
                     ),
                     Container(
                       padding: const EdgeInsets.all(8.0),
                       child: DefaultTextStyle(
                         style: TextStyle(
                           fontSize: 20,
                           color: Colors.black,
                         ), child: Text ("Shop Item 3"),
                       ),
                       color: Colors.teal,
                     ),
                     Container(
                       padding: const EdgeInsets.all(8.0),
                       child: DefaultTextStyle(
                         style: TextStyle(
                           fontSize: 20,
                           color: Colors.black,
                         ), child: Text ("Shop Item 4"),
                       ),
                       color: Colors.teal,
                     ),
                     Container(
                       padding: const EdgeInsets.all(8.0),
                       child: DefaultTextStyle(
                         style: TextStyle(
                           fontSize: 20,
                           color: Colors.black,
                         ), child: Text ("Shop Item 5"),
                       ),
                       color: Colors.teal,
                     ),
                     Container(
                       padding: const EdgeInsets.all(8.0),
                       child: DefaultTextStyle(
                         style: TextStyle(
                           fontSize: 20,
                           color: Colors.black,
                         ), child: Text ("Shop Item 6"),
                       ),
                       color: Colors.teal,
                     )
                   ],
                 ),
               )
               ]
         )
         ) ,
       )
     )
   );
  }
}
//TO DO: Add buttons to the Items and functions to buttons