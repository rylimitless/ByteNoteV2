import 'package:appwrite/appwrite.dart';
import 'package:bytenote/acount_controller.dart';
import 'package:bytenote/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/web.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

final GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey<ScaffoldState>();

class LoginMiddleWare extends StatelessWidget {

  const LoginMiddleWare({super.key});

  @override
  Widget build(BuildContext context){
      return const Scaffold(
          body: Center(
            child: Text('New features coming soon',
            style: TextStyle(
              fontSize: 20
            ),
            ),
          ),
      );
  }
}

class LoginPage extends StatelessWidget {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AccountController controller = Get.find(); 

  LoginPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key:scaffoldKey2,
        appBar: AppBar(

        ),
        body: controller.isLoggedin.value? const LoginMiddleWare() : Login(emailController: emailController, passwordController: passwordController, controller: controller)
      
      );
  }
}

class Login extends StatelessWidget {
  const Login({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.controller,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AccountController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
              
          children: [ 
              
          //Some Icon
         const SizedBox(height: 40,),
          const Icon(Icons.lock,size: 100,),
              
          //Greetings
          const SizedBox(height: 20,),
          Text('Welcome Back, sign in to sync your notes ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade800,
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
                  fillColor: Colors.white,
                  filled: true,
                )
            ),
          ),
      
          const SizedBox(height: 20,),
           Padding(
            padding:  const EdgeInsets.only(left:20,right: 20),
            child: TextField(
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
      
           Padding(
             padding: const EdgeInsets.only(right:20,top:10),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              GestureDetector(child: const Text('Forgot Password?',
              style: TextStyle(
                color: Color.fromARGB(255, 8, 111, 196),
              ),
              ))
                         ],),
           ),
          const SizedBox(height: 25,),
          GestureDetector(
            child: Container(
              decoration:BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: const Center(child: Text('Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
              )
              ),
              
              ),
            ),
            onTap: () async{
        
              // emailController.clear();
            
              // passwordController.clear();
              Logger().i('Now connect it to appwrite');
              
              try {
                  bool success = await controller.login(emailController.text,passwordController.text);
                  if(success){
                    Logger().i('Logged in as ');
                    if(scaffoldKey.currentContext?.mounted??true){
                      Navigator.pop(context);
                }
                  }
      
              } on AppwriteException catch(e){
                print(e);
                 //Say invald username / password
                 toastification.show(
                context: context, // optional if you use ToastificationWrapper
                title: const Text('Invalid Credentials , please try again'),
                autoCloseDuration: const Duration(seconds: 3),
              );
                 
              }
            },
          ),
      
        Padding(
            padding: const EdgeInsets.only(left:0,right:0,top:20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const Text('Not a member? '),
                GestureDetector(
                  child: const Text('Sign up now',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  onTap: (){
                    //Go to Sgn up page
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>SignUpPage())
                    );
                  },
                ),
              ],),
            ),
          )
              
          ],
              
        ),
      ),
    );
  }
}