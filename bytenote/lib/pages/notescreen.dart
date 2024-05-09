import 'package:bytenote/database/database.dart';
import 'package:flutter/material.dart';
import 'package:bytenote/models/note.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';

class NoteScreen extends StatelessWidget{

  late Note noteObj;
  String noteText = "";
  final Database db = Get.find();
  var titleController = TextEditingController();
  final bodyController = TextEditingController();

  NoteScreen({required this.noteObj,  super.key}) {
      titleController.text = noteObj.name!;
      bodyController.text = noteObj.text;
  }
  //It'll need a note object so it can add it's text to a screen.

  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(icon: const Icon(Icons.arrow_left),
          onPressed: (){
              //Undo 
          },
          ),
          IconButton(icon: const Icon(Icons.arrow_right),
          onPressed: (){
              //Redo
          },
          ),

          IconButton(icon: const Icon(Icons.check_outlined),
          onPressed: (){
              //Save and remain on page
              noteObj.text = bodyController.text;
              noteObj.name = titleController.text;
              db.addNote(noteObj);
              // Logger().i('Note Saved');
              // Logger().i(noteObj.text);  
          },
          ),
          
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(children: [
            //Title part
            Column(children: [
                TextField(controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title'
                ),
                ),
                const SizedBox(height: 2,),
                Text(noteObj.dateCreated.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12
                ),
                ),
            ],),
            const SizedBox(height: 20,),
        
            TextField(
          controller: bodyController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'Start writing',
            border: InputBorder.none
            
          ),
          style: const TextStyle(
            fontSize: 14
          ),
        ),
          ],),
        ),
      )
    );
  }
}