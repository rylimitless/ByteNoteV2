import 'package:isar/isar.dart';

part 'note.g.dart';


@collection
class Note {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? name="";

  late DateTime dateCreated;

  String text="";


  @override
  String toString(){
    return {'name': name, 'date_created': dateCreated.toString(),'text':text , 'id':id}.toString();

  }
}