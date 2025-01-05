import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_db_test/home_page.dart';
import 'package:local_db_test/model/item.dart';
import 'package:local_db_test/test_page.dart';

import 'model/person.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(fwefws());
  Hive.registerAdapter(ItemAdapter());
  await Hive.openBox('dataBox');
  await Hive.openBox<Item>('itemBox');
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Database"),
        centerTitle: true,
      ),
      body: [HomePage(),TestPage()][navIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        onTap: (index){
          setState(() {
            navIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
        ],
      ),
    );
  }
}
