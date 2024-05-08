import 'package:bytenote/models/note.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';

class Database extends GetxController{
  //Initialize

  static late Isar isar;
  var allNotes = [].obs;

  var logger = Logger();

   static Future<void> initializeDatabase() async{
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
      [NoteSchema],
  directory: dir.path,
);
    }
  //Create

  void addNote(Note note) async{
      await isar.writeTxn(() async {
  await isar.notes.put(note);
    });
  }



  //Read

  Future <void> getNotes() async{
    final notes = await isar.notes.where().findAll();
    allNotes.clear();
    allNotes.addAll(notes);
  }

  //Update

  Future <void> updateNote(Note note) async{
    isar.notes.put(note);
    return;
    
  }


  //Delete

  Future <bool> deleteNote(id) async{
    bool success = false;
    await isar.writeTxn(() async {
      success = await isar.notes.delete(123);
      logger.i('Recipe deleted: $success');

});

return success;
  }


}