import 'package:bytenote/acount_controller.dart';
import 'package:bytenote/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bytenote/database/database.dart';


class MyDrawer extends StatelessWidget{

  final AccountController acc  = Get.find();
  final Database db = Get.find();
  MyDrawer({super.key});
  
  void syncFunction(){
      //Open page with account info and ask to login or logout.
  }

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Column(
          children: [

            const DrawerHeader(child: Icon(Icons.note)),
            //Account
            DrawerTyle(title:'Notes',icon: const Icon(Icons.home),onTap: ()=>Navigator.pop(context),),

            
          Obx(()=> Visibility(
                        visible: acc.isLoggedin.value,
                        child: 
                        DrawerTyle(title: 'Download Notes',icon: const Icon(Icons.download),onTap: (){ 
                        // db.clean();
                        acc.downloadNotes(db);             
                      },),
                      )),

            DrawerTyle(title: 'Sync Settings',icon: const Icon(Icons.sync),onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
            },),
      
            DrawerTyle(title: 'Settings',icon: const Icon(Icons.settings),onTap: (){              
            },),

            

            Obx(()=>Visibility(
              visible: acc.isLoggedin.value,
              child: 
            DrawerTyle(icon: const Icon(Icons.logout_outlined),onTap: (){
              acc.logout();
              Navigator.pop(context);
            },title: 'Logout',)
            
            ))
            //Settings 
          ],
      ),
    );
  }
}

class DrawerTyle extends StatelessWidget {
  late Widget icon;
  late String title;
  void Function()? onTap;

   DrawerTyle({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:25,right:25,bottom: 10),
      child: ListTile(
        leading:  icon,
        title:  Text(title),
        onTap: onTap
      ),
    );
  }
}