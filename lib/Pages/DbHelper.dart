import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  
  DbHelper._();
  
  static DbHelper getInstance = DbHelper._();
  
  Database? myDB;
  
 Future<Database> getDB() async{
   if(myDB != null){
     return myDB!;
   }
   else{
     myDB = await openDB();
     return myDB!;
   }
   
    
  }
  
  Future<Database> openDB() async{
   
   Directory appDir = await getApplicationDocumentsDirectory();
   String appPath = join(appDir.path,'file.db');
   
   return await openDatabase(appPath ,version:1,onCreate:(db,version){
     db.execute(  'CREATE TABLE ToDo(id INTEGER PRIMARY KEY, tasks TEXT, dec TEXT)');
   });
   
  }

  addNote({required String mTasks,required String mDec}) async{
   var db = await getDB();

   db.insert('ToDo',{
     'tasks': mTasks,
     'dec': mDec
   });

  }
 Future<List<Map<String,dynamic>>> getNote() async{
   var db = await getDB();
  List<Map<String,dynamic>> mData = await db.query('ToDo');
  return mData;

  }

   deletNote({required int Id}) async{
   var db = await getDB();
   db.delete('Todo',where:'id = $Id');

   }

  

}