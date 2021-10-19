import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_game/screens/dailyQuest/quest_status.dart';
import 'package:hive/hive.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dailyQuest/quest_manager.dart';

class QuestBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuestBoardState();
  }
}

class _QuestBoardState extends State<QuestBoard> {

  late List<dynamic> _dailyQuests = [];
  late Box _configBox;
  late bool _isAdsShown;
  late RewardedAd? _rewardedAd;
  bool _isAdsLoaded = false;
  int _adRewardCoin = 5;

  @override
  void initState() {
    super.initState();
    _configBox = Hive.box("config");
    _isAdsShown = _configBox.get("isAdsShown");
    _dailyQuests = [];
    resetQuestBoard();

    //prepare ad if add is not shown yet
    if (!_isAdsShown) {
      setUpAd();
    }
  }

  //if the date changes, generate daily quests and make ad be watchable.
  void resetQuestBoard() async {
    // if the date has changed since last login. generate new daily quests
    if (QuestManager.oneDayPassed(DateTime.now())) {
      //generate daily quests and register then in user config
      await QuestManager.generateRandomDailyQuests();

      //update last login
      _configBox.put("lastLogin", DateTime.now());

      //make an ad be watchable.
      _renewAd();
    }

    //notify that _dailyQuests is initialized.
    setState(() {
      //get daily quests from user config
      _dailyQuests = _configBox.get("dailyQuests");
    });
  }

  //load a reward Ad.
  void setUpAd() async {
    await RewardedAd.load(
      adUnitId: _getTestAdRewardedUnitId(),
      request: AdRequest(),
      rewardedAdLoadCallback:RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          //load succeed.
          _rewardedAd = ad;
          setCallBack();
        },
        onAdFailedToLoad: (error) {
          //load failed
        },
      ),
    );
  }

  //set up callback methods of reward Ad.
  //this runs when the ad is loaded successfully.
  void setCallBack() {
    //setting callback behavior of Ad
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        //a player disposed Ads in the middle of Ad, give a chance to watch it again.
        _resetAdStatus();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd  ad, AdError error) {
        //an Ad failed to play, give a chance to watch it again.
        _resetAdStatus();
      },
    );
    // after setting is finished. show play Ad button.
    setState(() {
      _isAdsLoaded = true;
    });
  }

  //Give a player chance to watch Ad again
  void _resetAdStatus() {
    setState(() {
      _isAdsShown = false;
      _isAdsLoaded = false;
      setUpAd();
    });
  }

  //make an Ad playable. This runs when the date changes.
  void _renewAd() {
    _configBox.put("isAdsShown", false);
    _resetAdStatus();
  }

  //give rewards for completing daily quests
  void _giveRewards(QuestStatus questStatus) {
    int amount = _configBox.get(questStatus.quest.rewardType);
    setState(() {
      _configBox.put(questStatus.quest.rewardType, amount + questStatus.quest.rewardAmount);
      questStatus.isRewardCollected = true;
    });
  }

  //give coins for watching an Ad
  void giveAdReward() {
    setState(() {
      int coin = _configBox.get("coin");
      _configBox.put("isAdsShown", true);
      _configBox.put("coin", coin + _adRewardCoin);
      _isAdsShown = true;
      //show a message that a player get reward coins
      showRewardDialog();
    });
  }

  //play an Ad
  void showAd() {
    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      //callback: when an Ad finished successfully, give reward coins and dispose the Ad.
      giveAdReward();
      ad.dispose();
    },);
  }

  //show dialog that shows a player gets reward coin for watching an Ad
  void showRewardDialog() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("You received " + _adRewardCoin.toString() + " coins"),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Quests"),
        leading: Icon(Icons.calendar_today),
        backgroundColor: Colors.brown,
      ),
      body: (_dailyQuests.isEmpty) ?
      //if _dailyQuests has not been initialized yet, show loading message
      Center(
        child: Text("Loading"),
      ) :
      //if _dailyQuests is initialized, show list view
      Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount:  _dailyQuests.length,
              itemBuilder: (BuildContext context, int index) {
                var entry = _dailyQuests[index];
                return ListTile(
                  title: Text(entry.quest.desc),
                  trailing: (entry.isRewardCollected) ?
                  //if reward is collected, show "collected" disable button
                  ElevatedButton(
                    child: Text("Collected"),
                    onPressed: null,
                  ) :
                  (entry.isSatisfied) ?
                  //if quest is completed and reward is not collected, show "collect" button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: Text("Collect " + entry.quest.rewardAmount.toString() + " " +entry.quest.rewardType.toString()),
                    onPressed: () => _giveRewards(entry),
                  ) :
                  //if quest is not colpmeted, show disable button
                  ElevatedButton(
                    child: Text("Not completed"),
                    onPressed: null,
                  ),
                );
              }
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [
              if (!_isAdsShown && _isAdsLoaded)
                //if Ad is not played yet and being loaded. show play Ad button.
                ElevatedButton(
                  onPressed: showAd,
                  child: Text("Watch an Ad to get "+ _adRewardCoin.toString() +" coins"),
                ),
              _SpaceBox.width(20),
              ElevatedButton(
                  onPressed: () => {Navigator.of(context).pop()},
                  child: Text("Go back"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown,
                    onPrimary: Colors.orangeAccent,
                    side: BorderSide(color: Colors.black, width: 2),
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * Get app unit id for test Ads.
   * unit id is different depending on the platform.
   */
  String _getTestAdRewardedUnitId(){
    String testBannerUnitId = "";
    if(Platform.isAndroid) {
      // for android
      testBannerUnitId = "ca-app-pub-3940256099942544/5224354917";
    } else if(Platform.isIOS) {
      // for iOS
      testBannerUnitId = "ca-app-pub-3940256099942544/1712485313";
    }
    return testBannerUnitId;
  }

}

//a widget for making space between components.
class _SpaceBox extends SizedBox {
  _SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  _SpaceBox.width([double value = 8]) : super(width: value);
  _SpaceBox.height([double value = 8]) : super(height: value);
}