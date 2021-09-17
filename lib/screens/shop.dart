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
              //Possibly input an ads button that can rewards user 100 coins
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
                          ],
                        )),
                    SizedBox(
                      height:20,
                    ),
                    Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.brown[300]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Skins",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black))
                        ]
                      )
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
                            ]
                          ),
                        onTap:(){
                          print('tapped');
                        }
                        )
                      ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () => {Navigator.of(context).pop()},
                        child: Text("Go back")),
                    ]

                  )
              ]),

            )
            )
        ));
  }
}
 void main() {
  int coins = 2000;


 }
//TO DO: Add buttons to the Items and functions to buttons
//Shop itemS: Kiwifruit, bugs