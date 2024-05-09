import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:uuid/uuid.dart';

class AccountController extends GetxController{

  Client client = Client();
  var isLoggedin = false.obs;
  late Account account;
  User? loggedInUser;
  var uuid = const Uuid();

  @override
  void onInit() {
    // TODO: implement onInit
    createClient();
    getAccount();
    super.onInit();
  }
  
  void createClient(){
    client
    .setEndpoint('http://localhost/v1')
    .setProject('663cfed4c75eb91f1eff')
    .setSelfSigned(status: true);
    account = Account(client);

  }

  void getAccount() async{
    var user = await account.get();
    loggedInUser =user;
  if(loggedInUser!=null){
  isLoggedin.value = true;
  print('Logged in as ${user.name}');
}
  }

  Future<bool> login(email,password) async {
    bool log = false;
    var session = await account.createEmailPasswordSession(
    email: email,
    password: password,
);


var user = await account.get();


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

  void createAccount({required String email, required String password, required String name}) async{
    User result = await account.create(
    userId: uuid.v1(),
    email: email,
    password: password,
    name: name, // optional
);
  
  login(email, password);

  }
}