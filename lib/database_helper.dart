import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "RoadSigns.db";
  static const _databaseVersion = 1;

  static const table = 'road_signs';

  static const columnId = '_id';
  static const columnLatitude = 'latitude';
  static const columnLongitude = 'longitude';
  static const columnImagePath = 'imagePath';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnLatitude REAL NOT NULL,
        $columnLongitude REAL NOT NULL,
        $columnImagePath TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }
}
