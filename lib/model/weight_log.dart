import 'package:scales/model/model.dart';
import 'package:sqflite/sqflite.dart';

class WeightL {
  final int id;
  final String createdDate;
  final double weight;
  final String source;

  WeightL({this.id, this.createdDate, this.weight, this.source});
  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "weight": this.weight,
      "createdDate": this.createdDate,
      "source": this.source,
    };
  }

  Future<void> create() async {
    final Database db = await DBModel().db();
    await db.insert(
      'wl_log',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(int id) async {
    // Get a reference to the database (获得数据库引用)
    final Database db =
        await DBModel().db(); // Remove the Dog from the database (将狗狗从数据库移除)
    await db.delete(
      'wl_log',
      // Use a `where` clause to delete a specific dog (使用 `where` 语句删除指定的狗狗)
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection (通过 `whereArg` 将狗狗的 id 传递给 `delete` 方法，以防止 SQL 注入)
      whereArgs: [id],
    );
  }

  Future<dynamic> count() async {
    final Database db = await DBModel().db();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("select count(1) from wl_log");
    return maps[0].values.first;
  }

  Future<List<WeightL>> list({int limit = 10, int page = 1}) async {
    var offset = (page - 1) * limit;
    // Get a reference to the database (获得数据库引用)
    final Database db =
        await DBModel().db(); // Remove the Dog from the database (将狗狗从数据库移除)
    final List<Map<String, dynamic>> maps = await db.query('wl_log',
        orderBy: "createdDate desc", limit: limit, offset: offset);
    return List.generate(maps.length, (i) {
      return WeightL(
        id: maps[i]['id'],
        weight: maps[i]['weight'],
        createdDate: maps[i]['createdDate'],
        source: maps[i]['source'],
      );
    });
  }

  Future<List<WeightL>> listAll() async {
    // Get a reference to the database (获得数据库引用)
    final Database db =
        await DBModel().db(); // Remove the Dog from the database (将狗狗从数据库移除)
    final List<Map<String, dynamic>> maps =
        await db.query('wl_log', orderBy: "createdDate");
    return List.generate(maps.length, (i) {
      return WeightL(
        id: maps[i]['id'],
        weight: maps[i]['weight'],
        createdDate: maps[i]['createdDate'],
        source: maps[i]['source'],
      );
    });
  }
}
