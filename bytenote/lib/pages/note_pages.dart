
import 'package:bytenote/pages/notescreen.dart';
import 'package:bytenote/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:bytenote/models/note.dart';
import 'package:logger/web.dart';
import 'package:get/get.dart';
import 'package:bytenote/database/database.dart';


class NotePage extends StatelessWidget {

  //Make database object
  final Database db = Get.find();
  final l = [1,2,3,4,];
  

  NotePage({Key? key}) : super(key: key);
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
          var logger = Logger();
          logger.i('About To move to notes');
        //Move to noteScreen
        var note = Note()
        ..dateCreated = DateTime.now();
        // note.name = 'Hello';
        // db.addNote(note);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> NoteScreen(noteObj: note))
        );

        
        
      }, child: const Icon(Icons.add),
      ),

      body: Column(children: [
        Expanded(
          child:Obx(()=> ListView.builder(
            itemCount: db.allNotes.length,
            itemBuilder: 
              (context,index) {
                final note = db.allNotes[index];
                //return listtile after getting notes
                return ListTile(
                  title: Text(note.name),
                onTap: (){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> NoteScreen(noteObj: note))
                  );
                },
                onLongPress: (){
                  db.deleteNote(note.id);
                  // Logger().i('Delete note');
                },
                );
              }
          ),
        ))
      ],),
    );
  }
}