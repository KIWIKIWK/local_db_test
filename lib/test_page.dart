import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_db_test/update_item_dialog.dart';

import 'model/item.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late final TextEditingController _titleEditingController;
  late final TextEditingController _valueEditingController;

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController();
    _valueEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              final title = _titleEditingController.text.trim();
              final value = _valueEditingController.text.trim();
              final items = Hive.box<Item>("itemBox");

              items.add(Item(title, value));
              _titleEditingController.clear();
              _valueEditingController.clear();
            },
            icon: Icon(Icons.save),
            label: Text("Save"),
          ),
          ValueListenableBuilder<Box<Item>>(
            valueListenable: Hive.box<Item>('itemBox').listenable(),
            builder: (context, box, child) {
              final keys = box.keys.toList();
              if (keys.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      final List<Item> items =
                          keys.map((key) => box.get(key)!).toList();
                      return ListTile(
                        leading: IconButton(
                          onPressed: () async {
                            final Item? item = await showDialog<Item>(
                              context: context,
                              builder: (context) => updateItemDialog(),
                            );
                            if(item != null){
                              box.put(keys[index], item);
                            }
                          },
                          icon: Icon(Icons.save),
                        ),
                        title: Text(
                          "${items[index].title} // key - ${keys[index]}",
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          items[index].value,
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            box.delete(keys[index]);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
                );
              }
              return Center(
                child: Text(
                  "Item Box가 비어있습니다",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
