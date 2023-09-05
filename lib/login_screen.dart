import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  void loginUser({required String email,required String password})async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User login Successfully"),backgroundColor: Colors.green,));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomeScreen()), (route) => false);
      });
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.toString()),backgroundColor: Colors.red,));
    }
  }
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    // TODO: implement dispose
    super.dispose();
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
            SizedBox(height: 20,),
            TextFormField(
              controller: password,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),
            const SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              loginUser(email: email.text, password: password.text);
            }, child: const Center(
              child: Text("Login"),
            )),
            const SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Center(
              child: Text("Go To SignUp"),
            )),
          ],
        ),
      ),
    );
  }
}
