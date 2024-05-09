import 'package:bytenote/acount_controller.dart';
import 'package:bytenote/pages/note_pages.dart';
import 'package:bytenote/signup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();



class SignUpPage extends StatelessWidget {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final nameController = TextEditingController();

  var confirmColor = Colors.black;
  final SignUpController signup = Get.find();
  final AccountController acc = Get.find();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context){
    return  SafeArea(
      key: scaffoldKey,
      child:  Scaffold(
        appBar: AppBar(
          ),
        body: Center(
          child: Column(
            children: [ 
            //Some Icon
           const SizedBox(height: 10,),
            const Icon(Icons.lock,size: 100,),
            //Greetings
            const SizedBox(height: 15,),
            Text("Let's get you started",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
            ),
            ),
            const SizedBox(height: 15,),

            Padding(
              padding: const  EdgeInsets.only(left:20,right: 20),
              child: TextField(
                controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'User Name',
                    fillColor: Colors.grey.shade100,
                    filled: true,
                  )
              ),
            ),
            
            const SizedBox(height: 20,),
            Padding(
              padding: const  EdgeInsets.only(left:20,right: 20),
              child: TextField(
                controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Email',
                    fillColor: Colors.grey.shade100,
                    filled: true,
                  )
              ),
            ),

            const SizedBox(height: 20,),
             Padding(
              padding:  const EdgeInsets.only(left:20,right: 20),
              child: TextField(
                onChanged: (value){
                  if(confirmController.text!=value && value!=""){
                    signup.signUp.value = false;
                  }else {
                    signup.signUp.value = true;
                  }
                
                },
                controller: passwordController,
                obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Password',
                    fillColor: Colors.grey.shade100,
                    filled: true
                  )
              ),
            ),

            const SizedBox(height: 20,),
             Padding(
              padding:  const EdgeInsets.only(left:20,right: 20),
              child: TextField(
                onChanged: (value){
                  if(passwordController.text!=value && value!=''){
                    signup.signUp.value = false;
                  }else {
                    signup.signUp.value = true;
                  }
                
                },
                
                onEditingComplete: (){
                  if(passwordController.text==confirmController.text && passwordController.text.length>8){
                    signup.signUp.value = true;
                  }else {
                    signup.signUp.value = false;
                  }
                },
                controller: confirmController,
                obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Confirm password',
                    fillColor: Colors.grey.shade100,
                    filled: true
                  )
              ),
            ),

             
            const SizedBox(height: 30,),
            GestureDetector(
              child: Obx(()=>Container(
                decoration:BoxDecoration(
                  color:signup.signUp.value? Colors.black: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: const Center(child: Text('Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                )
                ),
                
                ),
              )),
              onTap: (){
          
                // emailController.clear();

                //Get the 

                acc.createAccount(email:emailController.text,name: nameController.text , password: passwordController.text);
                passwordController.clear();
                confirmController.clear();
                nameController.clear();
                emailController.clear();

                if(scaffoldKey.currentContext!.mounted){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>NotePage()));
                }

                 //clear the password
                  
                // passwordController.clear();
                Logger().i('Connected');
              },
            ),
                
            ],
                
          ),
        )
      
      ),
    );
  }
}