import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ShopScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShopScreenState();
  }
}

class _ShopScreenState extends State<ShopScreen> {
  late Box _box;
  late int _coin;
  late String _skin;
  int itemCost = 1;

  @override
  void initState() {
    super.initState();
    _box = Hive.box("config");
    print(_box.length);
    _coin = _box.get("coin");
    _skin = _box.get("skin");
  }

  Future<void> update(String skinString) async {
    print('Tapped: $skinString');
    if ((_coin - itemCost) > 0) {
      await _box.put("coin", _coin - itemCost);
      await _box.put("skin", skinString);
      setState(() {
        _coin = _box.get("coin");
      });
    }
  }

  // TODO clean up button class to be more concise.
  @override
  Widget build(BuildContext context) {
    // var assetsImage = new AssetImage('assets/images/');
    // var image = new Image(image: assetsImage, width: 48.0, height: 48.0);
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
            child: Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.brown[300]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Kiwi Coins = $_coin",
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
                  height: 20,
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
                        ])),
                Expanded(
                  child: GridView.count(
                      //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      padding: EdgeInsets.all(20.0),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        InkWell(
                          onTap: () async {
                            await update('kiwi_sprite_grey.png');
                          },
                          child: Image.asset(
                            //grey
                            'assets/images/kiwi_sprite_grey.png',
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await update('kiwi_sprite_purple.png');
                          },
                          child: Image.asset(
                            //grey
                            'assets/images/kiwi_sprite_purple.png',
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await update('kiwi_sprite_red.png');
                          },
                          child: Image.asset(
                            //grey
                            'assets/images/kiwi_sprite_red.png',
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await update('kiwi_sprite_yellow.png');
                          },
                          child: Image.asset(
                            //grey
                            'assets/images/kiwi_sprite_yellow.png',
                          ),
                        ),
                      ]),
                ),
                //Back Button
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                      onPressed: () => {Navigator.of(context).pop()},
                      child: Text("Go back")),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
