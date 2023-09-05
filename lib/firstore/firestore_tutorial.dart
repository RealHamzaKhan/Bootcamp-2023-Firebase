import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreTutorial extends StatefulWidget {
  const FireStoreTutorial({Key? key}) : super(key: key);

  @override
  State<FireStoreTutorial> createState() => _FireStoreTutorialState();
}

class _FireStoreTutorialState extends State<FireStoreTutorial> {
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final descController=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    descController.dispose();
    super.dispose();
  }
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Future<void> addData(String name,String email,String description)async{
    await _firestore.collection('users').doc().set({
      'name':name,
      'email':email,
      'description':description,
    });
  }
  updateData(String docId,String name,String email, String description)async{
    await _firestore.collection('users').doc(docId).update({
      'name':name,
      'email':email,
      'description':description,
    });

  }
  deleteData(String docId)async{
    await _firestore.collection('users').doc(docId).delete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _firestore.collection('users').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
            if(!snapshot.hasData || snapshot.connectionState==ConnectionState.waiting || snapshot.hasError){
              return const Center(child: CircularProgressIndicator());
            }
            else if(snapshot.data!.docs.isEmpty){
              return Center(child: Text("NO DATA FOUND"),);
            }
            else{
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data!.docs[index]['name']),
                        subtitle: Text(snapshot.data!.docs[index]['description']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(onPressed: (){
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    content: Container(
                                      height: 250,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                                hintText: "Enter you name"
                                            ),
                                          ),
                                          TextFormField(
                                            controller: emailController,
                                            decoration: const InputDecoration(
                                                hintText: "Enter you email"
                                            ),
                                          ),
                                          TextFormField(
                                            controller: descController,
                                            decoration: const InputDecoration(
                                                hintText: "Enter you description"
                                            ),
                                          ),

                                          SizedBox(height: 10,),
                                          ElevatedButton(onPressed: (){
                                            updateData(snapshot.data!.docs[index].id, nameController.text,
                                                emailController.text, descController.text);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Updated"),backgroundColor: Colors.green,));
                                          }, child: const Center(
                                            child: Text("Update"),
                                          ))
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              }, icon: Icon(Icons.edit)),
                              IconButton(onPressed: (){
                                deleteData(snapshot.data!.docs[index].id);
                              }, icon: Icon(Icons.delete,color: Colors.red,)),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
      }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(context: context, builder: (context){
          return AlertDialog(
            content: Container(
              height: 250,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter you name"
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: "Enter you email"
                    ),
                  ),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                        hintText: "Enter you description"
                    ),
                  ),

                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: (){
                    addData(nameController.text, emailController.text, descController.text);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Saved"),backgroundColor: Colors.green,));
                  }, child: const Center(
                    child: Text("Add"),
                  ))
                ],
              ),
            ),
          );
        });
      },
      child: Icon(Icons.add),),
    );
  }
}
