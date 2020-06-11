import 'package:quick_counter/util/provider.dart';

class User {
  Future<void> saveName({String name}) async {
    final db = await DBProvider.db.database;
    var res;

    // 新規のユーザーかどうか判断
    var isNew = await isNewUser(name: name);
    print(isNew);

    if (isNew) {  // 新規のユーザーならDBに追加する
      res = await db.rawInsert(
          "INSERT into users "
              "(name) "
              "VALUES "
              "('$name')"
      );

      // usersテーブルの中身を確認
      var users = await getUser();
      print(users);

      return res;
    }

    // usersテーブルの中身を確認
    var users = await getUser();
    print(users);
  }

  // ユーザー全件取得
  Future<List<Map<String, dynamic>>> getUser() async {
    final db = await DBProvider.db.database;
    var res = await db.query("users");
    return res;
  }

  // 新規のユーザーかどうか判断
  Future<bool> isNewUser({String name}) async {
    final db = await DBProvider.db.database;
    var res = await db.query(
        "users",
        where: "name = ?",
        whereArgs: [name]
    );

    if (res.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  // ユーザーidを取得する
  Future getNowUser({String name}) async {
    final db = await DBProvider.db.database;
    var res = await db.query(
        "users",
        where: "name = ?",
        whereArgs: [name]
    );

    return res[0];
  }

  // タイムを保存
  Future<void> saveTime({var menu, var time, int userId}) async {
    final db = await DBProvider.db.database;
    var res;
    Map<String, dynamic> user = Map();

    if (menu == "number") {
      user["number"] = time;
    }
    if (menu == "large") {
      user["large_az"] = time;
    }
    if (menu == "small") {
      user["small_az"] = time;
    }
    res = await db.update(
        "users",
        user,
        where: "id = ?",
        whereArgs: [userId]
    );

    return res;
  }
}