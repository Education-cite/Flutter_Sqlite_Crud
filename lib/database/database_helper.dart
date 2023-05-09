import 'dart:ffi';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'package:path/path.dart';
import 'package:sqlite/Model/todo_model.dart';
import 'package:sqlite/database/database_helper.dart';

class DataBaseHelper{

 static Future<void> createTables(sql.Database database)async{
  await database.execute("""CREATE TABLE data(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    desc TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP

  )""");

  }


   static Future<sql.Database> db()async{

    return sql.openDatabase("database_name.db",version: 1,
    onCreate: (sql.Database database,int version)async{
      await createTables(database);
    }
    
    );
   }


    static Future<int> createData(String title,String ? desc)async{
      final db = await DataBaseHelper.db();
      final data = {'title':title,'desc':desc};
      final id = await db.insert('data',data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;

    }



    static Future<List<Map<String,dynamic>>> getAllData()async{

      final db = await DataBaseHelper.db();
      return db.query('data',orderBy: 'id');
    }


    
    static Future<List<Map<String,dynamic>>> getSingleData(int id)async{

      final db = await DataBaseHelper.db();
      return db.query('data', where: "id = ? ", whereArgs: [id], limit: 1);
    }


  
    static Future<int> updateData(int id,String title,String ? desc)async{

      final db = await DataBaseHelper.db();
      final data={
        'title':title,
        'desc':desc,
       // 'createAt':DateTime.now().toString()
      };

      final result = await db.update('data',data, where: "id = ? ", whereArgs: [id]);
      return result;
    }


     static Future<void> deleteData(int id)async{

      final db = await DataBaseHelper.db();
      await db.delete('data', where: "id = ? ", whereArgs: [id]);
    }




//   DataBaseHelper._privateConstructor();
//   static final DataBaseHelper instance = DataBaseHelper._privateConstructor();
//   static Database? _database;

//   //Future<Database> get database async => _database ?? = await _initDatabase();


//   Future<Database> get database async {
//   _database ??= await _initDatabase();
//   return _database!;
// }


//   Future<Database> _initDatabase() async{
//     Directory documentDirectory = await getApplicationSupportDirectory();
//     String path = join(documentDirectory.path,'todos.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );


//   }



//   Future _onCreate(Database db, int version)async{
//     await db.execute(
//       '''
//       CREATE TABLE todos(
//         id INTEGER PRIMARY KEY,
//         title TEXT,
//         description TEXT
//       )

//       '''
//     );
//   }


//     Future<int> addTodos(Todo todo)async{

//     Database db = await instance.database;
//     return await db.insert('todos', todo.toJson());
//   }


//   Future<List<Todo>> getTodos(Todo todo)async{

//     Database db = await instance.database;
//     var todos = await db.query(
//       'todos',orderBy: "id"
//     );
//     List<Todo> _todos = todos.isNotEmpty ? todos.map((todo) => Todo.fromJson(todo)).toList() : [];
//     return _todos;
//   }


//   Future deleteTodos(int? id)async{

//     Database db = await instance.database;
//     return await db.delete("todos",where: 'id=?',whereArgs: [id]);

//   }


//   Future updateTodos(Todo todo)async{

//     Database db = await instance.database;
//     return await db.update("todos",
//     todo.toJson(),
//     where: 'id=?',
//     whereArgs: [todo.id]
    
//     );

//   }








}