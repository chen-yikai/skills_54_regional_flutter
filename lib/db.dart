import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_54_regional_flutter/screens/home.dart';
import 'package:sqflite/sqflite.dart';

class UserSchema {
  final int? id;
  final String email;
  final String name;
  final String password;
  final String? collections;
  final String? customOrder;

  UserSchema(
      {this.id,
      required this.email,
      required this.name,
      required this.password,
      this.collections,
      this.customOrder});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'collections': collections,
      'customOrder': customOrder
    };
  }
}

class PasswordSchema {
  final int? createdAt;
  final String name;
  final String user;
  final String password;
  final String website;
  final int favorite;

  PasswordSchema(
      {this.createdAt,
      required this.name,
      required this.user,
      required this.password,
      required this.website,
      required this.favorite});

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'name': name,
      'user': user,
      'password': password,
      'website': website,
      'favorite': favorite
    };
  }
}

Future<Database> init() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, 'app.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT,
          name TEXT,
          password TEXT,
          collections TEXT DEFAULT "",
          customOrder TEXT DEFAULT ""
          )
        ''');
      await db.execute('''
          CREATE TABLE passwords(
            createdAt INTEGER PRIMARY KEY,
            name TEXT,
            user TEXT,
            password TEXT,
            website TEXT,
            favorite INTEGER
            )
          ''');
    },
  );
}

Future<Database> connect() async {
  Database db = await init();
  return db;
}

class PasswordTable {
  static Future<List<PasswordSchema>> get(
      String search, SortBy sortBy, bool isAsc) async {
    final db = await connect();
    String email = "";
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('email')) {
      email = prefs.getString('email')!;
      final collections = await db
          .rawQuery('SELECT collections FROM users WHERE email = ?', [email]);
      final String collectionsList = collections[0]["collections"].toString();
      List<Map<String, dynamic>> maps = [];
      if (sortBy != SortBy.custom) {
        maps = await db.rawQuery('''
        SELECT * FROM passwords 
        WHERE createdAt IN ($collectionsList)
        AND (name LIKE "%$search%" OR user LIKE "%$search%") 
        ORDER BY ${sortBy == SortBy.createdAt ? "createdAt" : "name"} ${isAsc ? "ASC" : "DESC"}
        ''');
      } else {
        final customOrder = await UserTable.getCustomOrder();
        String customOrderString = "";
        for (var i = 0; i < customOrder.length; i++) {
          customOrderString +=
              customOrder[i] + (i == customOrder.length - 1 ? "" : ",");
        }
        maps = await db.rawQuery('''
        SELECT * FROM passwords 
        WHERE createdAt IN ($collectionsList)
        AND (name LIKE "%$search%" OR user LIKE "%$search%") 
        ORDER BY
          CASE createdAt
            ${customOrderString.split(",").asMap().entries.map((item) => "WHEN '${item.value}' THEN ${item.key}").join(" ")}
          END
        ''');
      }

      return List.generate(maps.length, (index) {
        return PasswordSchema(
          createdAt: maps[index]['createdAt'],
          name: maps[index]['name'],
          user: maps[index]['user'],
          password: maps[index]['password'],
          website: maps[index]['website'],
          favorite: maps[index]['favorite'],
        );
      });
    }
    return [];
  }

  static Future<void> delete(int id) async {
    final db = await connect();
    await db.execute('DELETE FROM passwords WHERE createdAt = $id');
    await db.execute(
        'UPDATE users SET collections = REPLACE(collections, "$id,", "")');
  }

  static Future<void> update(PasswordSchema password) async {
    final db = await connect();
    await db.update('passwords', password.toMap(),
        where: 'createdAt = ?', whereArgs: [password.createdAt]);
  }

  static Future<void> updateFavorite(int id, bool isfavorite) async {
    final db = await connect();
    await db.execute(
        'UPDATE passwords SET favorite = ${isfavorite ? 1 : 0} WHERE createdAt = $id');
  }

  static Future<PasswordSchema> getSingle(int id) async {
    final db = await connect();
    List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM passwords WHERE createdAt = $id');
    return PasswordSchema(
      createdAt: maps[0]['createdAt'],
      name: maps[0]['name'],
      user: maps[0]['user'],
      password: maps[0]['password'],
      website: maps[0]['website'],
      favorite: maps[0]['favorite'],
    );
  }

  static Future<bool> add(PasswordSchema password) async {
    final db = await connect();
    String email = '';
    var prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email')!;
    UserTable.updateCollections(email, password.createdAt!);
    try {
      await db.insert("passwords", password.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}

class UserTable {
  static Future<List<String>> getCustomOrder() async {
    var prefs = await SharedPreferences.getInstance();
    final db = await connect();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT customOrder FROM users WHERE email = ?',
        [prefs.getString('email')]);
    return maps[0]['customOrder'].toString().split(',');
  }

  static Future<void> setCustomOrder(List<String> list) async {
    var prefs = await SharedPreferences.getInstance();
    final db = await connect();
    String orderList = "";
    for (var i = 0; i < list.length; i++) {
      orderList += list[i] + (i == list.length - 1 ? "" : ",");
    }
    await db.execute('UPDATE users SET customOrder = ? WHERE email = ?',
        [orderList, prefs.getString('email')]);
  }

  static Future<bool> signUp(UserSchema user) async {
    final db = await connect();
    List<Map<String, dynamic>> sameUser =
        await db.rawQuery('SELECT * FROM users WHERE email = ?', [user.email]);
    if (sameUser.isNotEmpty) return false;
    await db.insert(
      'users',
      user.toMap(),
    );
    return true;
  }

  static Future<void> updateCollections(String email, int collection) async {
    final db = await connect();
    List<Map<String, dynamic>> collectionsOldMap = await db
        .rawQuery('SELECT collections FROM users WHERE email = ?', [email]);
    String oldCollections = collectionsOldMap[0]['collections'];
    await db.rawQuery('UPDATE users SET collections = ? WHERE email = ?', [
      oldCollections == "" ? "$collection" : "$oldCollections,$collection",
      email
    ]);
  }

  static Future<String> selectName(String email) async {
    final db = await connect();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT name FROM users WHERE email = ?', [email]);
    return maps[0]['name'];
  }

  static Future<bool> auth(String email, String password) async {
    final db = await connect();
    var accept = await db.rawQuery(
        'SELECT * FROM users WHERE email = ? AND password = ?',
        [email, password]);
    return accept.isNotEmpty;
  }

  static Future<void> delete(String email) async {
    final db = await connect();
    await db.execute('DELETE FROM users WHERE email = ?', [email]);
  }
}
