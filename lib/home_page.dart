import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:to_do/components/todo_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();

  late Box box;

  List todos = [];
  void initializer() async {
    await Hive.initFlutter();
    box = await Hive.openBox('todoBox');

    var data = box.get('todosInsidePh');
    if (data == null) {
      box.put('todosInsidePh', []); //sonelaa switchoff thanaa
    } else {
      //
      setState(() {
        todos = data;
      });
    }
  }

  @override
  void initState() {
    initializer();

    super.initState();
  }

  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilding...");
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 203, 225, 224),
        appBar: AppBar(
          
          title: const Text(
            "TO DO LIST",
            style: TextStyle(color:Colors.white),
          ),
          backgroundColor: Colors.teal[500],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('What would you like to do?'),
                content: TextField(
                  onSubmitted: (value) {
                     // List newTodo = [myController.text, false];                   
                  },
                  controller: myController,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      List newTodo = [myController.text, false];

                      setState(() {
                        //todo = [];
                        todos.add(newTodo);
                        //todo = [["m",false]];
                        box.put('todosInsidePh', todos);
                      });
                      myController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
        body: Column(
          children: [SizedBox(
            height: 25,
          ),
            Text("Pending",style: TextStyle(fontSize: 18,color: Colors.amber),),
            ListView.builder(
                shrinkWrap: true,
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return (!todos[index][1])
                      ? GestureDetector(
                        child: TodoItem(
                            text: todos[index][0],
                            isSelected: todos[index][1],
                            onChanged: (value) {
                              setState(() {
                                todos[index][1] = value!;
                              });
                              box.put('todosInsidePh', todos);
                            },
                          ),
                          onLongPress: () {
                              setState(() {
                                todos.remove(todos[index]);
                              });
                              box.put('todosInsidePh', todos);
                            },
                      )
                      : SizedBox();
                }),
            SizedBox(
              height: 50,
            ),
            Text("Completed",style: TextStyle(fontSize: 18,color: Colors.green),),
            ListView.builder(
                shrinkWrap: true,
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return (todos[index][1])
                      ? GestureDetector(
                          child: TodoItem(
                            text: todos[index][0],
                            isSelected: todos[index][1],
                            onChanged: (value) {
                              setState(() {
                                todos[index][1] = value!;
                              });
                            },
                          ),
                          onLongPress: () {
                            setState(() {
                              todos.remove(todos[index]);
                            });
                            box.put('todosInsidePh', todos);
                          },
                        )
                      : SizedBox();
                }),
          ],
        ));
  }
}
