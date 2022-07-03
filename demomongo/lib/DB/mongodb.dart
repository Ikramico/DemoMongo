import 'dart:developer';
import '../model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'const.dart';

class MongoDB {
  static var db, user;
  static connect() async {
    db = await Db.create(dbUrl);
    await db.open();
    inspect(db);
    user = db.collection('user');
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    db = await Db.create(dbUrl);
    await db.open();
    inspect(db);
    user = db.collection('user');
    final newData = await user.find().toList();
    await db.close();
    inspect(newData);
    return newData;
  }

  static Future<void> update(Model data) async {
    db = await Db.create(dbUrl);
    await db.open();
    inspect(db);
    user = db.collection('user');
    var result = await user.findOne({'_id': data.id});
    result['name'] = data.name;
    result['email'] = data.email;
    result['about'] = data.about;
    var response = await user.save(result);
    inspect(response);
    await db.close();
  }

  static delete(Model user) async {
    db = await Db.create(dbUrl);
    await db.open();
    inspect(db);
    var _user = db.collection('user');
    await _user.remove(where.id(user.id));
   
  }

  static Future<String> insert(Model data) async {
    try {
      db = await Db.create(dbUrl);
      await db.open();
      inspect(db);
      user = db.collection('user');
      var result = await user.insertOne(data.toJson());
      if (result.isSuccess) {
        await db.close();
        return 'Data Inserted';
      } else {
        await db.close();
        return 'Something went wrong';
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
