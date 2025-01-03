import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('dataBox');
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final TextEditingController _titleEditingController;
  late final TextEditingController _valueEditingController;
  final myBox = Hive.box('dataBox');
  var myData = [];

  void addItem({key,required data}) async {
    if(key == null){
      await myBox.add(data);
    } else{
      await myBox.put(key,data);
    }
    getItem();
  }

  void getItem() {
    myData = myBox.keys.map((item) {
      final res = myBox.get(item);
      return {"key": item, "title": res["title"], "value": res["value"]};
    }).toList();
    setState(() {});
    debugPrint(myData.toString());
  }

  void deleteItem(key) async {
    await myBox.delete(key);
    getItem();
  }

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController();
    _valueEditingController = TextEditingController();
    getItem();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _valueEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Database"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          spacing: 10,
          children: [
            TextField(
              controller: _titleEditingController,
              decoration: InputDecoration(
                hintText: "title",
              ),
            ),
            TextField(
              controller: _valueEditingController,
              decoration: InputDecoration(
                hintText: "value",
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final Map<String, String> data = {
                  "title": _titleEditingController.text.trim(),
                  "value": _valueEditingController.text.trim(),
                };
                addItem(data: data);
                _titleEditingController.clear();
                _valueEditingController.clear();
              },
              icon: Icon(Icons.save),
              label: Text("Save"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: myData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("데이터 수정"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _titleEditingController,
                                        decoration:
                                            InputDecoration(hintText: "title"),
                                      ),
                                      TextField(
                                        controller: _valueEditingController,
                                        decoration:
                                            InputDecoration(hintText: "value"),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _titleEditingController.clear();
                                          _valueEditingController.clear();
                                        },
                                        child: Text("취소")),
                                    TextButton(
                                        onPressed: () {
                                          final Map<String,String> data = {
                                            "title" : _titleEditingController.text.trim(),
                                            "value" : _valueEditingController.text.trim(),
                                          };
                                          addItem(key: myData[index]["key"],data: data);
                                          Navigator.of(context).pop();
                                          _titleEditingController.clear();
                                          _valueEditingController.clear();
                                        },
                                        child: Text("저장"))
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.save)),
                      title: Text("${myData[index]["title"]}"),
                      subtitle: Text("${myData[index]["value"]}"),
                      trailing: IconButton(
                          onPressed: () {
                            deleteItem(myData[index]["key"]);
                          },
                          icon: Icon(Icons.delete)),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
