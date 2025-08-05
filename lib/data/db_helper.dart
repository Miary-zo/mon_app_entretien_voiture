import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _database;

  // Initialisation de la base de données
  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'entretien1.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''CREATE TABLE voiture (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            numVoiture TEXT
          )
        ''');

        await db.execute('''CREATE TABLE piece (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            numVoiture TEXT,
            dateAchat TEXT,
            nomPiece TEXT,
            prixUnitaire REAL,
            qt INTEGER,
            lieuAchat TEXT,
            efaNapetaka INTEGER,
            dateMontage TEXT,
            autreExplication TEXT
          )
        ''');
      },
    );
  }

  // Getter de la base de données
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  // INSÉRER_PIECE
  static Future<void> insertPiece({
    required String numVoiture,
    required String dateAchat,
    required String nomPiece,
    required double prixUnitaire,
    required int qt,
    required String lieuAchat,
    required int efaNapetaka,
    required String dateMontage,
    String? autreExplication,
  }) async {
    final db = await database;

    await db.insert(
      'piece',
      {
        'numVoiture': numVoiture,
        'dateAchat': dateAchat,
        'nomPiece': nomPiece,
        'prixUnitaire': prixUnitaire,
        'qt': qt,
        'lieuAchat': lieuAchat,
        'efaNapetaka': efaNapetaka,
        'dateMontage': dateMontage,
        'autreExplication': autreExplication ?? '',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // UPDATE_PIECE
  static Future<int> updatePiece({
    required int id,
    required Map<String, dynamic> values,
  }) async {
    final db = await database;

    return await db.update(
      'piece',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // SUPPRIMER_PIECE
  static Future<int> deletePiece(int id) async {
    final db = await database;
    return await db.delete(
      'piece',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // LISTER_PIECE
  static Future<List<Map<String, dynamic>>> getAllPieces() async {
    final db = await database;
    return await db.query('piece');
  }

  //INSERT_VOITURE
  static Future<void> insertVoiture({
    required String numVoiture,

  }) async {
    final db = await database;

    await db.insert(
      'voiture',
      {
        'numVoiture': numVoiture,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//UPDATE_VOITURE
  static Future<int> updateVoiture({
    required int id,
    required Map<String, dynamic> values,
  }) async {
    final db = await database;

    return await db.update(
      'voiture',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }


// DELETE_VOITURE
  static Future<int> deleteVoiture(int id) async {
    final db = await database;
    return await db.delete(
      'voiture',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


//LISTER_VOITURE
  static Future<List<Map<String, dynamic>>> getAllVoitures() async {
    final db = await database;
    return await db.query('voiture');
  }

}
