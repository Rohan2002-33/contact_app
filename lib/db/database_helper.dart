import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        address TEXT,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // CREATE
  Future<int> insertContact(Contact contact) async {
    final db = await instance.database;
    return await db.insert('contacts', contact.toMap());
  }

  // READ all
  Future<List<Contact>> getAllContacts() async {
    final db = await instance.database;
    final result = await db.query('contacts', orderBy: 'name ASC');
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  // READ favorites
  Future<List<Contact>> getFavoriteContacts() async {
    final db = await instance.database;
    final result = await db.query(
      'contacts',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  // SEARCH by name
  Future<List<Contact>> searchContacts(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'contacts',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  // UPDATE
  Future<int> updateContact(Contact contact) async {
    final db = await instance.database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // DELETE
  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}