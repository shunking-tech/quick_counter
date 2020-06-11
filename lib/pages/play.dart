import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:quick_counter/model/user.dart';

class Play extends StatefulWidget {
  // 選択された制限時間を受け取り
  var menu;
//  double time;
  var userId;
  Play({this.menu, this.userId});

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  var isStart = false;   // スタートしているか判断
  var canTap = true;     // タップを許可するか判断

  @override
  Widget build(BuildContext context) {
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
            ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // 画面上部
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        children: <Widget>[

                          // 時間
                          _blockTimer(),
//                        Expanded(
//                          child: Text(
//                            // タイマーの表示　ゼロ埋めがうまくいっていないけど、とりあえずよし
//                            ((widget.time * 100).ceil() / 100).toString().padRight(5, "0").padRight(5, "0"),
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                              fontSize: 50,
//                              color: Colors.white
//                            ),
//                          ),
//                        ),

                          // 終了ボタン
                          Expanded(
                            child: Container(
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
                                              // タップ回数の保存
//                                              SharePrefs().setRecord(menu: widget.menu, record: record);
//                                              User().saveRecord(menu: widget.menu, record: record, userId: widget.userId).then((value) {
//                                                print("SQLでタップ数の保存成功");
//                                              }).catchError((err) {
//                                                print("SQLでタップ数の保存失敗");
//                                                print(err);
//                                              });
                                              // 確認
//                                              SharePrefs().getRecord(menu: widget.menu);
                                              print(widget.menu);
                                              // ページ戻る
                                              Navigator.pop(context);
                                            },
                                            color: Colors.red.withOpacity(0.2),
                                            child: Text(
                                              "QUIT",
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        )
                                    )
                                  ],
                                )
                            ),
                          )
                        ],
                      ),
                    ),

                    // 最初は案内　タップし始めたら回数　を表示
                    guideOrRecord(),

                    // タップエリア
                    tapArea()

                  ],
                ),
              ],
            ),
          ],
        )
    );
  }

  // タップ箇所の１つ
  Widget tapAreaOne(String content) {
    return Expanded(
        child: Container(
          margin: EdgeInsets.all(5),
          height: 70,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              color: Colors.red.withOpacity(0.2)
          ),
          child: ListTile(
            title: Center(
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white
                ),
              ),
            ),
            enabled: canTap,
            onTap: () {
              //1回目のタップでのみタイマーをスタートさせる
              if (!isStart) {
//                _startTimer();
              }
              isStart = true;  // スタートしたことを知らせる
              setState(() {});
            },
          ),
        )
    );
  }

  // タップエリア
  Widget tapArea() {
    // タップする中身
//    List contentList = new List.generate(30, (i)=> (i+1));  // 1-30の配列作成
    // A-Zの配列
//    List contentList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "", "", "", ""];
    List contentList = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "", "", "", ""];

    List shuffled = shuffle(contentList);

    var count = 0;  // listTapの何番目を追加しているか数える
    List<Widget> listRows = new List<Widget>();  // Rowを6個入れるための配列

    for (var i=0; i<6; i++) {
      List<Widget> listRowChildren = new List<Widget>();
      for (var j=0; j<5; j++) {
        listRowChildren.add(tapAreaOne(shuffled[count].toString()));  // 1行分(5個)の子要素達を追加
        count++;
      }
      listRows.add(Row(children: listRowChildren,));  // Rowを1行ずつ6個追加
    }

    return Column(children: listRows,);
  }

  // 配列をランダムに並び替える
  List shuffle(List some_list){
    var shuffledList = [];
    var unshuffledList = some_list.toList();
    var random = new math.Random();
    while(unshuffledList.length != 0){
      var l = unshuffledList.length;
      var r = random.nextInt(l);
      shuffledList.add(unshuffledList[r]);
      unshuffledList.removeAt(r);
    }
    return shuffledList;
  }

  // 最初は案内　タップし始めたら回数　を表示する箇所
  Widget guideOrRecord() {

    if (isStart) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 80,
                  color: Colors.white
              ),
            ),
          )
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Press any\nbutton to start",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white
              ),
            ),
          )
        ],
      );
    }
  }

  Widget _blockTimer() {
//    var f = new NumberFormat("00.00");
//
//    if (widget.time >= 0) {   // ENDRESS以外の時にタイマーを表示
//      return Expanded(
//        child: Text(
//          f.format(widget.time),
//          textAlign: TextAlign.center,
//          style: TextStyle(
//              fontSize: 50,
//              color: Colors.white
//          ),
//        ),
//      );
//    } else if (widget.time == -1.00) {   // ENDRESSの時の表示
//      return Expanded(
//        child: Text(
//          "NO LIMIT",
//          textAlign: TextAlign.center,
//          style: TextStyle(
//              fontSize: 40,
//              color: Colors.white
//          ),
//        ),
//      );
//    } else {
//      return Expanded(
//        child: Text(
//          "00.00",
//          textAlign: TextAlign.center,
//          style: TextStyle(
//              fontSize: 50,
//              color: Colors.white
//          ),
//        ),
//      );
//    }
      return Expanded(
        child: Text(
          "00.00",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 50,
              color: Colors.white
          ),
        ),
      );
  }
//
////  いづれかのボタンを押した時にタイマー開始
//  _startTimer() {
//    if (widget.time >= 0) {   // ENDRESS以外の時にタイマーを動かす
//      Timer.periodic(
//          Duration(milliseconds: 1),
//              (Timer t) => setState(() {
//            widget.time -= 0.01;
//
//            // タイマーが０になったら
//            if (widget.time <= 0) {
//              t.cancel();       // タイマー止める
//              canTap = false;   // タップできなくする
//            }
//          })
//      );
//    }
//  }
}
