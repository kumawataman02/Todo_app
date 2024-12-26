import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_2/Pages/DbHelper.dart';

class homepage extends StatefulWidget{
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  TextEditingController _tasks = TextEditingController();
  TextEditingController _dec = TextEditingController();

  List<Map<String,dynamic>> item = [];

  DbHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DbHelper.getInstance;
    getNotes();
  }

  addNotes({required String tasks,required String dec}){
    setState(() {
      dbRef!.addNote(mTasks:tasks, mDec:dec);

    });
  }
  getNotes() async{
    List<Map<String,dynamic>> data = await dbRef!.getNote();
    setState(() {
      item = data;
    });

  }

  deleteNote({required int value}){
    setState(() {
      dbRef!.deletNote(Id:value);
    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title:Text("ToDo",style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold),),
        centerTitle:true,
        backgroundColor:Colors.black,

      ),

      body:ListView.builder(
          itemCount:item.length,
          itemBuilder:(context,index){
        return ListTile(
          title:Text(item[index]['tasks']),
          subtitle: Text(item[index]['dec']),
          trailing:IconButton(onPressed:(){
            deleteNote(value:item[index]['id']);
            getNotes();
          }, icon:Icon(Icons.delete)),
        );
      }),

      floatingActionButton:FloatingActionButton(onPressed:(){

        showBottomSheet(context: context, builder:(context){
          return Container(
            height:500,
            color:Colors.black,
            child:Column(
              children: [
                Container(
                  margin:EdgeInsets.only(top:15),
                    child: Text("Add Tasks",style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:30),)),
                Container(
                  margin:EdgeInsets.all(20),
                  child:TextField(
                    controller: _tasks,
                    cursorColor:Colors.white,
                    style:TextStyle(color:Colors.white),
                    decoration:InputDecoration(
                      hintText:"Add Tasks",
                      hintStyle:TextStyle(color:Colors.white),
                      
                      border:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(20),

                      )
                    ),
                  ),
                ),
                Container(
                  margin:EdgeInsets.all(20),
                  child:TextField(
                    controller:_dec,
                    cursorColor:Colors.white,
                    style:TextStyle(color:Colors.white),
                    maxLines:5,
                    decoration:InputDecoration(
                      hintText:"Add Description",
                      hintStyle:TextStyle(color:Colors.white),
                      border:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(20)
                      )
                    )
                    ,
                  ),
                ),
                SizedBox(
                height:60,
                ),
                Container(
                  width:340,
                  height: 50,
                  child:ElevatedButton(onPressed:(){
                    addNotes(tasks:_tasks.text, dec:_dec.text);
                    getNotes();
                  }, child:Text("Create",style:TextStyle(color:Colors.black,fontSize: 20),)),
                )
              ],
            ),

          );
        });
      },
      child:Icon(Icons.add),),

    );

  }
}