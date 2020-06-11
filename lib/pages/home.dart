import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_counter/main.dart';
import 'package:quick_counter/model/user.dart';
import 'package:quick_counter/pages/play.dart';
//import 'package:renda_machine/pages/play.dart';
//import 'package:renda_machine/util/shere_pref.dart';
//import 'package:renda_machine/util/spl.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with RouteAware {
  TextEditingController _ctrName = TextEditingController();    // 名前の入力フォームのコントローラー

  // どのメニューが選択されているか
  var selectedMenuNum = true;  // デフォルトで10秒が選ばれてる状態にする
  var selectedMenuLarge = false;
  var selectedMenuSmall = false;

  // メニューを選択できるかどうか
  var canTapMenu10 = true;
  var canTapMenu60 = true;
  var canTapMenuEndless = true;

  // 選択中のメニュー
  var selectedMenuName = "number";  // デフォルトで10秒が選ばれてる状態にする

  // 記録表示用の変数
  var record10 = "--";
  var record60 = "--";
  var recordEndless = "--";

  // 名前を入力した時のみPLAYできるように制御する変数
  var canPlay = false;

  // ユーザーid
  var userId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
//    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  // 上の画面がpopされて、この画面に戻ったときに呼ばれます
  void didPopNext() {
    print("aaa");
//    setState(() {});
    // ユーザー情報を取得
//    SQL().getNowUser(name: _ctrName.text).then((value) {
//      print("ユーザーidを取得成功");
//      print(value);
//      userId = value["id"];   // ユーザーidを変数に保持
//      if (value["tenSec"] != null) {
//        record10 = value["tenSec"].toString();
//      }
//      if (value["sixtySec"] != null) {
//        record60 = value["sixtySec"].toString();
//      }
//      if (value["endless"] != null) {
//        recordEndless = value["endless"].toString();
//      }
//      setState(() {});
//    }).catchError((err) {
//      print("ユーザーidを取得失敗");
//      print(err);
//    });
  }

  @override
  Widget build(BuildContext context) {
// ユーザー名の入力欄を下から出すようにしたかったが、キーボードで隠れてしまう問題を解決できず保留
//    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        body: Stack(
          children: <Widget>[
            // 背景画像
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/planets.jpg"),
                      fit: BoxFit.cover,
                    )
                )
            ),

            // 表示内容
            SingleChildScrollView(
//              reverse: true,
                child: Container(
// ユーザー名の入力欄を下から出すようにしたかったが、キーボードで隠れてしまう問題を解決できず保留
//            margin: EdgeInsets.only(bottom: bottomSpace),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          // 画面上部の記録表示
                          FutureBuilder(
                            future: _blockShowRecord(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: LinearProgressIndicator(),
                                );
                              }

                              return snapshot.data;
                            },
                          ),

                          // タイトル
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Quick\nCountre",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white
                                  ),
                                ),
                              )
                            ],
                          ),

                          // ユーザー名
                          Container(
                              margin: EdgeInsets.only(left: 70, right: 70),
                              height: 100,
                              child: TextFormField(
                                controller: _ctrName,
                                textAlign: TextAlign.center,

                                // 入力が完了した時の処理
                                onFieldSubmitted: (String n) async {
                                  // 入力内容を取得
//                                  await SharePrefs().setName(name: _ctrName.text);
//                                  var _name = await SharePrefs().getName();

                                  setState(() {
                                    if (_ctrName.text.length == 0) {  // 入力内容がない時
                                      canPlay = false;
//                                      record10 = "--";
//                                      record60 = "--";
//                                      recordEndless = "--";
                                    } else {                  // 入力内容がある時
                                      print("名前の入力あり");
                                      canPlay = true;

                                      // ユーザー登録
                                      User().saveName(name: _ctrName.text).then((value) {
                                        print("ユーザー登録成功");

                                        // ユーザー情報を取得
                                        User().getNowUser(name: _ctrName.text).then((value) {
                                          print("ユーザーidを取得成功");
                                          print(value);
                                          userId = value["id"];   // ユーザーidを変数に保持
//                                          if (value["tenSec"] != null) {
//                                            record10 = value["tenSec"].toString();
//                                          } else {
//                                            record10 = "--";
//                                          }
//                                          if (value["sixtySec"] != null) {
//                                            record60 = value["sixtySec"].toString();
//                                          } else {
//                                            record60 = "--";
//                                          }
//                                          if (value["endless"] != null) {
//                                            recordEndless = value["endless"].toString();
//                                          } else {
//                                            recordEndless = "--";
//                                          }
                                          setState(() {});
                                        }).catchError((err) {
                                          print("ユーザー情報を取得失敗");
                                          print(err);
                                        });
                                      }).catchError((err){
                                        print("ユーザー登録失敗");
                                        print(err);
                                      });
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Enter Nickname..."
                                ),
                              )
                          ),

// ユーザー名の入力欄を下から出すようにしたかったが、キーボードで隠れてしまう問題を解決できず保留
//              Container(
//                padding: EdgeInsets.only(left: 100,right: 100),
//                child: TextField(
//                  decoration: InputDecoration(
//                    enabledBorder: new OutlineInputBorder(
//                      borderSide: BorderSide(
//                        color: Colors.grey,
//                      ),
//                    ),
//                    focusedBorder: OutlineInputBorder(
//                      borderSide: BorderSide(
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//                    ListTile(
//                      onTap: () {
//                        _showModalPicker(context);
//                      },
//                    ),

                          _blockPlay(),

                          // 画面下部
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(top: 30),
                            child: Row(
                              children: <Widget>[
                                // 作成者情報
                                Expanded(
                                  child: Text(
                                    "FONT:\n"
                                        "Isurus Labs\n\n"
                                        "ICON:\n"
                                        "Yukichi\n\n"
                                        "SPECIAK THANKS:\n"
                                        "Yukichi, @real_onesc\n\n"
                                        "(c) 2018 sinProject inc.",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // ランキング
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      height: 200,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Leaderboard",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "1.",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                )
            ),
          ],
        )

    );
  }

  // 画面上部の記録の１つ
  Widget recordText({var menu, var record}) {
    return Expanded(
      child: Column(
        children: <Widget>[
          SizedBox(height: 30,),
          Text(
            menu,
            style: TextStyle(
                color: Colors.yellow,
                fontSize: 20
            ),
          ),
          Text(
            record,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> _blockShowRecord() async {
    // メニュー毎の記録を取得
//    var r10 = await SharePrefs().getRecord(menu: "10s");
//    var r60 = await SharePrefs().getRecord(menu: "60s");
//    var rEndress = await SharePrefs().getRecord(menu: "ENDRESS");

    // 記録を数値から文字列に変換して代入　nullなら”0”を代入
//    record10 = r10.toString();
//    if (r10 == null) {
//      record10 = "0";
//    }
//    record60 = r60.toString() ?? "0";
//    if (r60 == null) {
//      record60 = "0";
//    }
//    recordEndless = rEndress.toString() ?? "0";
//    if (rEndress == null) {
//      recordEndless = "0";
//    }

    // 記録を表示するウィジェットを返す
    return Container(
      child: Row(
        children: <Widget>[
          recordText(menu: "1-30", record: record10),
          recordText(menu: "A-Z", record: record60),
          recordText(menu: "a-z", record: recordEndless),
        ],
      ),
    );
  }

  // 画面中部のメニューの１つ
  Widget menuItem({var menu, var selected, var canTap}) {
    // メニュー名表示用の変数
    var displayMenuName = "";

    // メニュー名表示用の変数
    if (menu == "number") {
      displayMenuName = "1-30";
    } else if (menu == "large") {
      displayMenuName = "A-Z";
    } else if (menu == "small") {
      displayMenuName = "a-z";
    }

    return Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          foregroundDecoration: BoxDecoration(
              color: selected ? Colors.red.withOpacity(0.3) : null
          ),
          child: ListTile(
            enabled: canTap,
            title: Text(
              displayMenuName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white
              ),
            ),
            onTap: () {
              setState(() {
                selectedMenuName = menu;
                if (menu == "number") {
                  selectedMenuNum = true;
                  selectedMenuLarge = false;
                  selectedMenuSmall = false;
                  canTapMenu10 = false;
                  canTapMenu60 = true;
                  canTapMenuEndless = true;
                } else if (menu == "large") {
                  selectedMenuNum = false;
                  selectedMenuLarge = true;
                  selectedMenuSmall = false;
                  canTapMenu10 = true;
                  canTapMenu60 = false;
                  canTapMenuEndless = true;
                } else if (menu == "small") {
                  selectedMenuNum = false;
                  selectedMenuLarge = false;
                  selectedMenuSmall = true;
                  canTapMenu10 = true;
                  canTapMenu60 = true;
                  canTapMenuEndless = false;
                }
              });
            },
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        )
    );
  }

  // 名前入力欄を下から出したかったが、キーボードで隠れてしまうため断念
  void _showModalPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField()
              ),
              FlatButton(
                child: Text("ok"),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _blockPlay() {
    if (canPlay) {    // 名前入力されているときはメニューとPLAYボタンを表示する
      return Column(
        children: <Widget>[
          // メニュー
          Container(
            padding: EdgeInsets.only(top: 10,bottom: 10, left: 30, right: 30),
            child: Row(
              children: <Widget>[
                menuItem(menu: "number", selected: selectedMenuNum, canTap: canTapMenu10),
                menuItem(menu: "large", selected: selectedMenuLarge, canTap: canTapMenu60),
                menuItem(menu: "small", selected: selectedMenuSmall, canTap: canTapMenuEndless),
              ],
            ),
          ),

          // PLAYボタン
          Container(
              padding: EdgeInsets.only(bottom: 10, left: 30, right: 30),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                        ),
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Play(menu: selectedMenuName, userId: userId,),
                              ),
                            );
                          },
                          color: Colors.red.withOpacity(0.3),
                          child: Text(
                            "PLAY!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50
                            ),
                          ),
                        ),
                      )
                  )
                ],
              )
          ),
        ],
      );
    } else {    // 名前入力されていない時は何も表示しない
      return Container(
        height: 150,
      );
    }
  }
}