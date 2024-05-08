
import 'package:flutter/material.dart';


class NotePage extends StatelessWidget {
  const NotePage({Key? key}) : super(key: key);
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('ByteNote'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {

        //Move to noteScreen
        
      }, child: const Icon(Icons.add),
      ),
    );
  }
}