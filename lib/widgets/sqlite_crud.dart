

import 'package:flutter/material.dart';
import 'package:sqlite/database/database_helper.dart';

class SqliteTodo extends StatefulWidget {
  const SqliteTodo({super.key});

  @override
  State<SqliteTodo> createState() => _SqliteTodoState();
}

class _SqliteTodoState extends State<SqliteTodo> {

  List<Map<String,dynamic>> _allData = [];
  bool _isLoading = true;

  void refreshData()async{
    final data = await DataBaseHelper.getAllData();
    setState(() {
      _allData=data;
      _isLoading=false;
    });
  }


  @override
  void initState() {
    super.initState();
   _titleController = TextEditingController(); 
  _descriptionController=TextEditingController();
    refreshData();
  }

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  void showBottomSheet(int? id)async{

    if(id!=null){

      final exitingData = _allData.firstWhere((element) => element['id']==id);
      _titleController.text=exitingData['title'];
      _descriptionController.text=exitingData['desc'];
    }
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context, 
      builder: (_)=>Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom+50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Title"
              ),
            ),
            SizedBox(height: 10,),

             TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Description"
              ),
            ),

            SizedBox(height: 15,),
            Center(
              child: ElevatedButton(
                onPressed: ()async{
                  if(id==null){
                    await _addData();
                  }
                   if(id!=null){
                    await _updateData(id);
                  }
                  _titleController.text="";
                  _descriptionController.text="";
                  Navigator.of(context).pop();
                  print("Data Added");
              },child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(id==null ? "Add Data":"Update Data",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                ),

              
              ),),
            )
          ],
        ),
      ),
      
      );

  }


  Future<void> _addData()async{
    await DataBaseHelper.createData(_titleController.text, _descriptionController.text);
    refreshData();
  }


  
  Future<void> _updateData(int id)async{
    await DataBaseHelper.updateData(id,_titleController.text, _descriptionController.text);
    refreshData();
  }


  
  Future<void> _deleteData(int id)async{
    await DataBaseHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.red,
      content: Text("Data deleted")));

    refreshData();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("SQLITE_CRUD"),
        ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ):ListView.builder(
        itemCount: _allData.length,
        itemBuilder: (context,index)=>Card(
          margin: EdgeInsets.all(15),
          child: ListTile(
            title: Padding(padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              _allData[index]['title'],
              style: TextStyle(
                fontSize: 20,

              ),
            ),
            
            ),

            subtitle: Text(_allData[index]['desc']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                  IconButton(
                    onPressed: (){
                      showBottomSheet(_allData[index]['id']);
                    }, 
                    icon: Icon(Icons.edit,color: Colors.green,)
                    ),

                     IconButton(
                    onPressed: (){
                      _deleteData(_allData[index]['id']);
                    }, 
                    icon: Icon(Icons.delete,color: Colors.red,)
                    ),

              ],
            ),
            
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>showBottomSheet(null),

    child:Icon(Icons.add)
      
      ),
    );
  }
}