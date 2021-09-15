import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/main.dart';

class ShopScreen extends StatelessWidget {
   const ShopScreen({Key? key}) : super(key: key);

  get coins => 1000; //Local get and must be update when after each user game.
  get item => 100;




  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/images/');
    var image = new Image(image: assetsImage, width:48.0, height: 48.0);
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.brown[500],
            appBar: AppBar(
              backgroundColor: Colors.brown,
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
                            color: Colors.brown[200]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Kiwi Coins = $coins",
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
                                    color: Colors.brown[500]),
                                child: GestureDetector(child: Center(
                                    child: Text(
                                      "Watch ADS for Free Coins",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),onTap:(){print('button clicked Ads to play  in queue');} //Should open a page for coins
                                    )
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: GestureDetector(child: GridView.count(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          padding: EdgeInsets.all(20.0),
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: [
                            Container( //put this in the middle
                                width: double.infinity,
                                height: 50,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.brown[200]),
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Kiwi Skins"),
                                ],
                              )
                            ),
                            Image.asset(//grey
                              'assets/images/kiwi_sprite_grey.png',
                            ),
                            Image.asset(//purple
                              'assets/images/kiwi_sprite_purple.png',
                            ),
                            Image.asset(//red
                              'assets/images/kiwi_sprite_red.png',
                            ),
                            Image.asset(//yellow
                              'assets/images/kiwi_sprite_yellow.png',
                            ),
                            Container( //put this in the middle
                                width: double.infinity,
                                height: 50,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.brown[200]),
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Power Ups"),
                                  ],
                                )
                            ),
                            Image.asset(//heart
                              'assets/images/heart.png',
                            ),
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
                    onTap:(){
                        const snackBar = SnackBar(content: Text('Item bought'));

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        "$coins - $item";
                        print('I clicked it, Coin value update');
                        return coins;
                        },)
                    )]
                  )
              ),
                )
            )
        );
  }
}
 void main() {
  int coins = 1000;


 }
//TO DO: Add buttons to the Items and functions to buttons
//Shop itemS: Kiwifruit, bugs