
import 'package:money_exchange_app/model/MoneyExchangeModel.dart';
import 'package:money_exchange_app/pages/homePage.dart';

import 'DatabaseCreator.dart';

class Repository {
 /* static Future<List<MoneyExchangeModel>> getAllFavouriteQuotes() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.quotesTable}''';
    final data = await db.rawQuery(sql);
    var list = <Quote>[];
    list.addAll(data.map((c) => Quote.fromJsonDatabase(c)).toList());
    return list;
  }

  static Future<bool> isFavourite(String id) async {
    final sql =
        '''SELECT * FROM ${DatabaseCreator.quotesTable} WHERE ${DatabaseCreator.id} = $id''';
    final data = await db.rawQuery(sql);
    if (data.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<Quote> getQuotes(String id) async {
    final sql =
        '''SELECT * FROM ${DatabaseCreator.quotesTable} WHERE ${DatabaseCreator.id} = $id''';
    final data = await db.rawQuery(sql);
    if (data.isNotEmpty) {
      return Quote.fromJsonDatabase(data[0]);
    }
    return null;
  }*/

  Future<bool?> addList(
      LocalDbList dbData) async {
    try {
      Map<String, dynamic> row = {
        DatabaseCreator.id : dbData.id,
        DatabaseCreator.data  : dbData.data
      };

      // do the insert and get the id of the inserted row
      int id = await db!.insert(DatabaseCreator.moneyexchangeTable, row);
     /* final sql = '''INSERT INTO ${DatabaseCreator.moneyexchangeTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.data}
    )
    VALUES (?,?)''';
      List<dynamic> params = [dbData.id ?? "", dbData.data ?? ""];
      final result = await db!.rawInsert(sql, params);
      DatabaseCreator.databaseLog('Add Data', sql, null, result, params);*/
    } catch (e) {
      print(e);
    }
  }
  static Future<LocalDbList?> getAllData() async {
    final sql =
    '''SELECT * FROM ${DatabaseCreator.moneyexchangeTable}''';
    final data = await db!.rawQuery(sql);
    if (data.isNotEmpty) {

      return LocalDbList.fromJsonDatabase(data.first);
    }

    return null;

  }
  /*static Future<bool> removeFavourite(String id) async {
    final sql = '''DELETE FROM ${DatabaseCreator.quotesTable}
    WHERE ${DatabaseCreator.id} == ${id}''';
    final result = await db.rawUpdate(sql);
    DatabaseCreator.databaseLog("Remove from favourite", sql, null, result);
    return true;
  }*/
}
