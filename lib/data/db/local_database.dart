import 'package:bek_shop/data/models/cart/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static String tableName = "Cart";
  static LocalDatabase getInstance = LocalDatabase._init();
  Database? _database;

  LocalDatabase._init();

  Future<Database> getDb() async {
    if (_database == null) {
      _database = await _initDB("navvat_restaurant.db");
      return _database!;
    }
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, fileName);

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
        String textType = "TEXT";
        String intType = "INTEGER";

        await db.execute('''
        CREATE TABLE $tableName (
    ${CartFields.id} $idType,
    ${CartFields.productId} $intType,
    ${CartFields.categoryId} $intType,
    ${CartFields.productName} $textType,
    ${CartFields.productDescription} $textType,
    ${CartFields.createdAt} $textType,
    ${CartFields.productPrice} $intType,
    ${CartFields.productImage} $textType,
    ${CartFields.mfgDate} $textType,
    ${CartFields.expDate} $textType,
    ${CartFields.productQuantity} $intType,
    ${CartFields.isCountable} $intType,
    ${CartFields.count} $intType
)
            ''');
      },
    );
    return database;
  }

  /// ---------------------------Cart-------------------------------------------
  static Future<CartModel> insertToCartProduct({required CartModel cartModel}) async {
    var database = await getInstance.getDb();
    int id = await database.insert(tableName, cartModel.toJson());
    debugPrint("HAMMASI YAXSHI PRODUCT CARTGA QO'SHILDI");
    return cartModel.copyWith(id: id);
  }

  static Future<CartModel> updateCartProductById({required CartModel cartModel}) async {
    var database = await getInstance.getDb();
    int id = await database.update(
      tableName,
      cartModel.toJson(),
      where: 'id = ?',
      whereArgs: [cartModel.id],
    );
    debugPrint("HAMMASI YAXSHI CARTDAGI PRODUCT YANGILANDI");
    return cartModel.copyWith(id: id);
  }

  static Stream<List<CartModel>> getAllCartProductsStream() async* {
    var database = await getInstance.getDb();
    var listOfTodos = await database.query(
      tableName,
      columns: [
        CartFields.id,
        CartFields.productName,
        CartFields.productId,
        CartFields.productPrice,
        CartFields.productDescription,
        CartFields.count,
        CartFields.productQuantity,
        CartFields.categoryId,
        CartFields.productImage,
        CartFields.createdAt,
        CartFields.isCountable,
        CartFields.mfgDate,
        CartFields.expDate,
      ],
    );

    var list = listOfTodos.map((e) => CartModel.fromJson(e)).toList();

    yield list;
  }

  static Future<int> deleteCartProductById({required int id}) async {
    var database = await getInstance.getDb();
    return await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteAllCartProducts() async {
    var database = await getInstance.getDb();
    return await database.delete(tableName);
  }
}
