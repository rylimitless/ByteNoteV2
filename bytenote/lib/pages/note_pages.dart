
import 'package:appwrite/models.dart';
import 'package:bytenote/acount_controller.dart';
import 'package:bytenote/components/drawer.dart';
import 'package:bytenote/login.dart';
import 'package:bytenote/pages/notescreen.dart';
import 'package:flutter/material.dart';
import 'package:bytenote/models/note.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:get/get.dart';
import 'package:bytenote/database/database.dart';
import 'package:toastification/toastification.dart';


class NotePage extends StatelessWidget {

  //Make database object
  final Database db = Get.find();
  final AccountController acc = Get.find();
  

  NotePage({Key? key}) : super(key: key);
  Widget build(BuildContext context){
    return Scaffold(
        drawer:MyDrawer(),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> NoteScreen(noteObj: note))
          );
        }, child: const Icon(Icons.add),
        ),
      
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notes',
                style: GoogleFonts.dmSerifText(
                  fontSize : 48
                )
                ),
                IconButton(onPressed: () async{
                  print('About to upload ');
                  if(acc.isLoggedin.value==false){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                  }else {
                      try{
                      bool success = await acc.uploadNotes(db.allNotes);
                      if(success){
                        print('yess');
                        toastification.show(
                      
                      context: context, // optional if you use ToastificationWrapper
                      title: const Text('Notes Uploaded'),
                      autoCloseDuration: const Duration(seconds: 2),
                    );
                      }else {
                         toastification.show(
                      
                      context: context, // optional if you use ToastificationWrapper
                      title: const Text('Notes Uploaded'),
                      autoCloseDuration: const Duration(seconds: 1),
                    );
                        print('no');
                      }
                      // acc.doesDocumentExist();
                  } on Execution {
                    print('Not authoried');
                  }
                  }
                  
                  //Check if user is logged and move to log in page if not
                }, icon: const Icon(Icons.sync))
              ],
            ),
          ),
          Expanded(
            child:Obx(()=> ListView.builder(
              itemCount: db.allNotes.length,
              itemBuilder: 
                (context,index) {
                  final note = db.allNotes[index];
                  //return listtile after getting notes
                  return Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    // transform: Matrix4.skewY(-0.1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade400,
      
                    ),
                    margin: const EdgeInsets.only(top:10,left:25,right:25,bottom:25),
                    child: ListTile(
                      title: Text(note.name == null ? "Untitled": note.name ),
                      subtitle: Text(note.dateCreated.toString().substring(0,10),
                      style: const TextStyle(
                          fontSize: 10
                      ),
                      ),
                    onTap: (){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> NoteScreen(noteObj: note))
                      );
                    },
                    onLongPress: (){
                      db.deleteNote(note.id);
                      // Logger().i('Delete note');
                    },
                    ),
                  );
                }
            ),
          ))
        ],),
      );
  }
}