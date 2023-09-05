import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/login_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth=FirebaseAuth.instance;
  void signUpUser({required String email,required String password})async{
  await  _auth.createUserWithEmailAndPassword(email: email, password: password).then((value){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Created Successfully"),backgroundColor: Colors.green,));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));

  }).onError((error, stackTrace){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error Occurred"),backgroundColor: Colors.red,));

  } );
  }
  final email=TextEditingController();
  final password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: email,
              decoration: const InputDecoration(
                hintText: "email",
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: password,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),
            const SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              signUpUser(email: email.text, password: password.text);
            }, child: const Center(
              child: Text("Sign Up"),
            )),
            const SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
            }, child: const Center(
              child: Text("Go To Login"),
            )),
          ],
        ),
      ),
    );
  }
}
