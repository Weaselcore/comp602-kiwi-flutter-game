import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/main.dart';

class ShopScreen extends StatelessWidget {
   const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/images/');
    var image = new Image(image: assetsImage, width:48.0, height: 48.0);
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.grey[400],
            appBar: AppBar(
              leading: Icon(Icons.store_rounded),
              title: const Text(
                'Shop',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: Center(
              child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(children: <Widget>[
                    Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.teal[100]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Kiwi Coins = 1000",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black)),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 40.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.teal[500]),
                                child: Center(
                                    child: Text(
                                      "Buy More Coins",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        )),
                    Expanded(
                      child: GridView.count(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          padding: EdgeInsets.all(20.0),
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: [//Add on click functions
                            Image.asset(//Caterpillar
                                'assets/images/Caterpillar.png',
                            ),
                            Image.asset(//Cockroach
                                'assets/images/Cockroach.png'
                            ),
                            Image.asset(//Weta
                              'assets/images/Weta.png'
                            ),
                            Image.asset(//Worm
                              'assets/images/Worm.png'
                            )
                            ]
                      ),
                    )
                  ]
                  )
              ),

                )
            )
        );
  }
}

//TO DO: Add buttons to the Items and functions to buttons
//Shop itemS: Kiwifruit, bugs