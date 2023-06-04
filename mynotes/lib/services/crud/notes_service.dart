import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'crud_exceptions.dart';


class NotesService{
  Database? _db;

  Future<DatabaseNote> updateNote({required DatabaseNote note, required String text}) async{
   final db = _getDatabaseOrThrow();
   await getNote(id: note.id);
  final updatCount = await db.update(
    noteTable,{
      textColum: text,
      isSyncedWithCloudColum: 0,
    } );
  if(updatCount == 0){
    throw CouldNotUpdateNote();
  }
  else {
    return await getNote(id: note.id);
  }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async{
   final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
}

  Future<DatabaseNote> getNote({required int id}) async{
   final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable, 
    limit: 1, 
    where: 'id= ?', 
    whereArgs: [id],
    );
    if (notes.isEmpty){
      throw CouldNotFoundNote();
    }
    else {
      return DatabaseNote.fromRow(notes.first);
      }
  }

  Future<int> deleteAllNotes() async{
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner }) async{
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if(dbUser != owner){
      throw CouldNotFindUser();
    }
    const text= '';
    final noteId = await db.insert(noteTable, {
      userIdColum: owner.id,
      textColum:text,
      isSyncedWithCloudColum:1,
    });
    final note = DatabaseNote(id: noteId, userId: owner.id, text: text, isSyncedWithCloud: true);
    
    return note;

  }

  Future<void> deleteNote({required int id}) async{
    final db = _getDatabaseOrThrow();
    final deletedCount= await db.delete(noteTable, 
    where: 'emial = ?', 
    whereArgs: [id]
    );
    if (deletedCount == 0){
      throw CouldNotDeleteNote();
    }
  }


  Future<DatabaseUser> getUser({required String email}) async{
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable, 
     limit: 1, 
     where: 'emial = ?',
     whereArgs: [email.toLowerCase()], 
     );
     if (results.isEmpty){
      throw CouldNotFindUser();
     }else{
      return DatabaseUser.fromRow(results.first);
     }
  }

  Future<void> deleteUser({required String email}) async{
    final db = _getDatabaseOrThrow();
    final deletedCount= await db.delete(userTable, where: 'emial = ?', 
    whereArgs: [email.toLowerCase()]
    );
    if (deletedCount != 1){
      throw CouldNotDeleteUser();
    }
  }
  Future<DatabaseUser> createUser({required String email}) async{
     final db = _getDatabaseOrThrow();
     final results = await db.query(userTable, 
     limit: 1, 
     where: 'emial = ?',
     whereArgs: [email.toLowerCase()], 
     );
     if (results.isNotEmpty){
      throw DatabaseAlreadyExist();
     }

    final userId = await db.insert(userTable, {
      emailColum: email.toLowerCase(),
    });

    return DatabaseUser(id: userId, email: email);

   }
  Database _getDatabaseOrThrow(){
  final db= _db;
  if (db == null){
    throw DatabaseIsNotOpen();
  } else{
    return db;
  }
  }

  Future<void> close() async{
    final db= _db;
    if (db == null){
      throw DatabaseIsNotOpen();
    }
    else{
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async{
    if (_db != null){
      throw DatabaseAlreadyopenException();
    }
    try{
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);

    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({ 
  required this.id, 
  required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map) : id = map[idColum] as int,
   email = map[emailColum] as String;

   @override
   String toString() => 'Person, Id = $id, email = $email';

   @override bool operator == (covariant DatabaseUser other) => id == other.id;
   
     @override
     int get hashCode => id.hashCode;
   
}

class DatabaseNote{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id, 
  required this.userId, 
  required this.text, 
  required this.isSyncedWithCloud,
  });

   DatabaseNote.fromRow(Map<String, Object?> map) : id = map[idColum] as int,
   userId = map[userIdColum] as int,
   text = map[textColum] as String,
   isSyncedWithCloud = (map[isSyncedWithCloudColum] as int) == 1 ? true : false;

 @override
   String toString() => 'Note, ID= $id, userId=$userId';

  @override bool operator == (covariant DatabaseNote other) => id == other.id;
   
     @override
     int get hashCode => id.hashCode;

}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColum = "id";
const emailColum = "email";
const userIdColum = "user_id";
const textColum = "text";
const isSyncedWithCloudColum = "is_synced_with_cloud";


  const createUserTable= '''CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      ); ''';

   const createNoteTable= '''CREATE TABLE IF NOT EXISTS "note" (
        "id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "text" TEXT,
        "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      ); ''';