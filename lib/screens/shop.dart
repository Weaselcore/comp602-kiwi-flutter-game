import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/main.dart';

class ShopScreen extends StatelessWidget {
   const ShopScreen({Key? key}) : super(key: key);

   static const IconData attach_money = IconData(0xe0b2, fontFamily: 'MaterialIcons');

  get coins => 2000; //Local get and must be update when after each user game.
  get item => 100;

  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/images/');
    var image = new Image(image: assetsImage, width:48.0, height: 48.0);
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white70,
            //AppBar
            appBar: AppBar(
              backgroundColor: Colors.brown,
              leading: Icon(Icons.store_rounded),
              title: const Text(
                'Shop',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              //Add an icon for ads
              /*
              actions: [
                Container(
                  margin: EdgeInsets.only(right:0 ),
                  //padding: EdgeInsets.all(10),
                    child: Image.asset('assets/images/ads.png')

                )
              ],*/
            ),
            //End of AppBar

            //Body Content
            body: Center(
              child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(children: <Widget>[
                    Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.brown[300]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Kiwi Coins = $coins",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black)),
                            SizedBox(
                              height: 0,
                            ),
                            /*Container(
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
                            ),*/
                          ],
                        )),
                    SizedBox(
                      height: 0,
                    ),
                    Expanded(
                      child: GridView.count(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          padding: EdgeInsets.all(20.0),
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: [
                            //Get rid of Box Header
                            /*Container( //put this in the middle
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
                            ),*/
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
                              /*Container( //put this in the middle          [optional items]
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
                           Image.asset(//heart        [optional items]
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
                            )*/
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
 void main() {
  int coins = 2000;


 }
//TO DO: Add buttons to the Items and functions to buttons
//Shop itemS: Kiwifruit, bugs