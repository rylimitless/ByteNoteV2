
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bytenote/models/note.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bytenote/database/database.dart';

class AccountController extends GetxController{

  Client client = Client();
  late Databases database;
  var isLoggedin = false.obs;
  late Account account;
  User? loggedInUser;
  late String docID;


  @override
  void onInit() {
    // TODO: implement onInit
    createClient();
    getAccount();
    getPrefs();
    super.onInit();
  }

  //Get prefs i.e the user key so I can always send stuff back and know which document is for what user
  void setPrefs(id) async{
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('docID', id);
  }
  
  void getPrefs() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? doc = prefs.getString('docID');
    if(doc!=null){
      docID = doc;
    }else {
      docID = ID.unique();
      setPrefs(docID);
    }

    print(docID);
    
  }

  void createClient(){
    client
    .setEndpoint('<Your endpoint here>')
    .setProject('<project id>') //
    .setSelfSigned(status: true);
    account = Account(client);
    database = Databases(client);

  }

  void getAccount() async{
    try{
      var user = await account.get();

    loggedInUser =user;
    if(loggedInUser!=null){
    isLoggedin.value = true;
    // updatePrefs();
    print('Logged in ass ${user.name}');
    if(user.prefs.data.isEmpty){
    getPrefs();
    setPrefs(docID);
  }else {
    setPrefs(user.prefs.data['id']);
    
  }
  } 
    } on AppwriteException catch(e){
      //
    }
   
  }

  Future<bool> login(email,password) async {
    bool log = false;
    var session = await account.createEmailPasswordSession(
    email: email,
    password: password,
  );


  var user = await account.get();
  print(user.prefs);
  if(user.prefs.data.isEmpty){
    getPrefs();
    setPrefs(docID);
  }else {
    setPrefs(user.prefs.data['id']);
    
  }

  loggedInUser =user;
  if(loggedInUser!=null){
    isLoggedin.value = true;
    log  = true;
    print('Logged in as ${user.name}');
  }

// print("Hello ${3+3}");

  return log;
  }
  void logout() async{
    await account.deleteSession(
    sessionId: 'current',
  );
  loggedInUser = null;
      isLoggedin.value = false;
    }
  Future<bool> createAccount({required String email, required String password, required String name}) async{
   bool log = false;
   
       User result = await account.create(
    userId: ID.unique(),
    email: email,
    password: password,
    name: name, // optional
);
  bool success = await login(email, password);

  if(success){
    print('Hello World');
    updatePrefs();
      log = true;
  }

  //  } on AppwriteException {
  //   return false;
    
  //  }
   return log;
  }

  void updatePrefs(){
    Future result = account.updatePrefs(
    prefs: {
      'id': docID
    },
  );
  }

  Future<bool> doesDocumentExist() async{
    late DocumentList document;
    bool doc = false;
    try {
      if(loggedInUser!=null){
          document = await database.listDocuments(databaseId: '1', collectionId: '1',
      queries: [
        Query.equal('email', loggedInUser?.email)
        ]
      );
      }
       doc = document.total !=0;
      print(doc);
      if(!doc){
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      getPrefs();
      setPrefs(docID);
      }
    } on AppwriteException {
      //
    }

    return doc;
  
  }

  void downloadNotes(Database db) async{

      bool doesDoc = await doesDocumentExist();
      late DocumentList documentList;
      if(doesDoc){
        documentList = await database.listDocuments(databaseId: '1', collectionId: '1',
        queries: [
          Query.equal('email', loggedInUser?.email)
        ]
        
        );

        if(documentList.total>0){

          var ids = List.generate(db.allNotes.length, (index) => db.allNotes[index].id);
          for(var note in documentList.documents){
            for(var doc in note.data['notes']){
            Map<String, dynamic> data = {};
          doc = doc.replaceAll('{', '');
          doc = doc.replaceAll('}', '');
          var tmp = doc.split(',');
          for (var lst in tmp) {
            var map = lst.split(':');
            String key = map[0].trim();
            String value = map.sublist(1).join(':').trim();
            if (value.startsWith(' ') || value.endsWith(' ')) {
              value = '"' + value + '"';
            }
            data[key] = value;
          }
                 if(!ids.contains(data['id'])){
                  
                  var date = data['date_created'];
                  var title = data['name'];
                  var body = data['text'];
                  // print('${date} ,${title},${body}');
                Note newNote = Note()..dateCreated = DateTime.parse(data['date_created'])
                                    ..text = data['text']
                                    ..name = data['name']
                                    ..id = int.parse(data['id']);
                print(newNote.toString());
                db.addNote(newNote);
              }
            }
             
          }
        }
      }
  }

  Future<bool> uploadNotes(notes) async{
    bool uploaded = false;
    try {
    
      if(loggedInUser!=null){
          bool doesDoc = await doesDocumentExist();
          print(docID);
          var data = {
              'email' : loggedInUser?.email,
              'notes' : List.generate(notes.length, (index) => notes[index].toString()),
            };
          if(!doesDoc){
              final document = database.createDocument(
            databaseId: '1',
            collectionId: '1',
            documentId: docID,
            data: data,
        );
          uploaded = true;
          }else {
            final document = database.updateDocument(databaseId: '1', collectionId: '1', 
            documentId: docID,
            data : data
            );
          uploaded = true;

          }         
      }
        
    } on AppwriteException catch(e) {
        print('Unautorized');
    }

    return uploaded;

  }
}