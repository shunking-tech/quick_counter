import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:quick_counter/model/user.dart';
import 'package:quick_counter/util/sound.dart';

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
  var canTap = true;     // タップを許可するか判断

  List contentList = [];  // タップする中身を代入する用
  List shuffled = [];     // タップする中身をシャッフルしたものを代入する用

  var count = 0;  // タップされた回数を数える
  var maxTap = 0;   // メニューによってタップできる回数を変える

  var gameover = false;   // 間違えたらこれをtrueにしてGameOverにする
  var clear = false;

  var time = 00.00;   // タイム保持する

  @override

  initState() {
    super.initState();

    // タイマーをスタート
    _startTimer();

    if (widget.menu == "number") {
      // 1-30の配列
      contentList = new List.generate(30, (i)=> (i+1));
      //  数字の時は30回までタップできる
      maxTap = 30;
    } else if (widget.menu == "large") {
      // A-Zの配列
      contentList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "", "", "", ""];
      //  アルファベットの時は26回までタップできる
      maxTap = 26;
    } else if (widget.menu == "small") {
      // a-zの配列
      contentList = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "", "", "", ""];
      //  アルファベットの時は26回までタップできる
      maxTap = 26;
    }

    // 配列をシャッフル
    shuffled = shuffle(contentList);

  }

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
                      padding: EdgeInsets.only(top: 10, left: 10,right: 10),
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
                                              print("QUIT");

                                              Sound().playSelectMenu();

                                              if (clear) {  // クリアしてたらタイムを保存する
                                                User().saveTime(menu: widget.menu, time: time, userId: widget.userId).then((value) {
                                                  print("タイム保存成功");
                                                }).catchError((err) {
                                                  print("タイム保存失敗");
                                                  print(err);
                                                });
                                              } else {  // クリアしてない時に終了したら、ゲームオーバーとする
                                                gameover = true;
                                              }

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

                  ],
                ),
              ],
            ),

            // タップエリア
            Align(
              alignment: Alignment(0.0, 1.0),
              child: tapArea(),
            )
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
              color: (gameover || clear) ? null : Colors.red.withOpacity(0.2)
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
              // 次にタップする中身を取得
              var nextContent = "";
              if (count < maxTap) {
                nextContent = contentList[count].toString();
              }

              // 正しくタップしている、かつ、最大タップ数に達していなければ、次に進む
              if ((content == nextContent) && (count < maxTap)) {
                Sound().playTapErea();
                count++;  // タップ回数を一回増やす

                // 最大タップ数に到達すればクリア
                if (count == maxTap) {
                  Sound().playClear();
                  clear = true;
                }

              // 間違ってタップ、かつ、最大タップ数に達していなければ、GameOver
              } else if ((content != nextContent) && (count+1 < maxTap)) {
                Sound().playGameOver();
                gameover = true;
              }
              setState(() {});
            },
          ),
        )
    );
  }

  // タップエリア
  Widget tapArea() {
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

    return Container(
      height: 500,
//      color: Colors.orange,
      child: Column(children: listRows,),
    );
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

  // 次にタップするものを表示する
  Widget guideOrRecord() {
    if (gameover) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Game Over!",
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 70,
                  height: 1.35,
                  color: Colors.white
              ),
            ),
          )
        ],
      );
    } else if (count < maxTap) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              contentList[count].toString(),
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
              "Congratulation!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 60,
                  height: 1.55,
                  color: Colors.white
              ),
            ),
          )
        ],
      );
    }
  }

  Widget _blockTimer() {
    var f = new NumberFormat("00.00");
    return Expanded(
      child: Text(
        f.format(time),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 50,
            color: Colors.white
        ),
      ),
    );
  }

  //  いづれかのボタンを押した時にタイマー開始
  _startTimer() {
    Timer.periodic(
      Duration(milliseconds: 1),
        (Timer t) => setState(() {
          time += 0.01;

          // ゲームオーバー、または、クリアでタイマーを止める
          if (gameover || clear) {
            t.cancel();
          }
        })
    );
  }
}
