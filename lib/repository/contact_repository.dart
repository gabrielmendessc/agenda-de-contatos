import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:agenda_de_contatos/domain/contact.dart';

const String contactTable = "contact";

class ContactRepository {

  static final ContactRepository _instance = ContactRepository.internal();
  factory ContactRepository() => _instance;

  ContactRepository.internal();

  Database? _db;

  Future<Database?> get db async {

    if (_db != null) {
      return _db;
    }

    _db = await initDb();

    return _db;

  }

  Future<Database> initDb() async {

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      
      await db.execute(
        "CREATE TABLE $contactTable("
            "${Contact.idContactColumn} INTEGER PRIMARY KEY,"
            "${Contact.nameColumn} TEXT,"
            "${Contact.emailColumn} TEXT,"
            "${Contact.phoneColumn} TEXT,"
            "${Contact.imgUrlColumn} TEXT)"
      );
      
    });

  }

  Future<Contact> saveContact(Contact contact) async {

    Database? dbContact = await db;

    contact.idContact = await dbContact!.insert(contactTable, contact.toMap());

    return contact;

  }

  Future<Contact?> getContact(int id) async {

    Database? dbContact = await db;

    List<Map> mapList = await dbContact!.query(
        contactTable,
        columns: [Contact.idContactColumn, Contact.nameColumn, Contact.emailColumn, Contact.phoneColumn, Contact.imgUrlColumn],
        where: "${Contact.idContactColumn} = ?",
        whereArgs: [id]);

    if (mapList.length > 0) {

      return Contact.fromMap(mapList.first);

    }

    return null;

  }

  Future<int> deleteContact(int id) async {

    Database? dbContact = await db;

    return await dbContact!.delete(
        contactTable,
        where: "${Contact.idContactColumn} = ?",
        whereArgs: [id]);

  }

  Future<int> updateContact(Contact contact, int id) async {

    Database? dbContact = await db;

    return await dbContact!.update(
        contactTable,
        contact.toMap(),
        where: "${Contact.idContactColumn} = ?",
        whereArgs: [id]);

  }

  Future<List<Contact>> getAllContact() async {

    Database? dbContact = await db;
    List<Contact> contactList = [];
    List<Map<String, dynamic>> mapList = await dbContact!.rawQuery("SELECT * FROM $contactTable");

    mapList.forEach((map) {contactList.add(Contact.fromMap(map));});

    return contactList;

  }

  Future close() async {

    Database? dbContact = await db;

    dbContact!.close();

  }

}