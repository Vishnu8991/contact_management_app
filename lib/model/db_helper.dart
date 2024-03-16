import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  
  static Future<sql.Database> createDB() async{
    return sql.openDatabase('mycontacts.db', version: 1,
    onCreate: (sql.Database database, int version) async{
      await createTable(database);
    });
  }

  
  static Future<void> createTable(sql.Database database) async{
    await database.execute("""CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstname TEXT,
        lastname TEXT,
        number INTEGER,
        email TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
  }


 static Future<int> createContact(String firstname, String lastname, String phonenumber, String mail) async {
    final db = await SQLHelper.createDB(); 

    final existingContacts = await db.query('contacts',
       where: 'firstname = ? OR number = ? OR email = ?',
      whereArgs: [firstname, phonenumber, mail]);

    if (existingContacts.isNotEmpty) {
      return -1;
    }

    final data = {'firstname': firstname, 'lastname': lastname, 'number': phonenumber, 'email': mail};
    final id = await db.insert('contacts', data);
    return id;
  }


  static Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await SQLHelper.createDB();
    return db.query('contacts', orderBy: 'id');
  }


  static Future<int> updateContact(int id, String firstname, String lastname, String phonenumber, String mail) async {
    final db = await SQLHelper.createDB();

  final existingContacts = await db.query('contacts',
      where: 'id != ? AND (firstname = ? OR number = ? OR email = ?)',
      whereArgs: [id, firstname, phonenumber, mail]);

  if (existingContacts.isNotEmpty) {
    return -1;
  }

    final newdata = {
      'firstname': firstname,
      'lastname': lastname,
      'number': phonenumber,
      'email': mail,
      'createdAt': DateTime.now().toString()
    };
    final upid = await db.update('contacts', newdata, where: 'id = ?', whereArgs: [id]);
    return upid;
  }
  

  static Future<void> deleteContact(int id) async{
    final db = await SQLHelper.createDB();
    try{
      await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
    }catch(e){
      throw Exception();
    }
  }

}