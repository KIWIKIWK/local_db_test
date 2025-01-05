import 'package:flutter/material.dart';

import 'model/item.dart';

class updateItemDialog extends StatefulWidget {
  const updateItemDialog({super.key});

  @override
  State<updateItemDialog> createState() => _updateItemDialogState();
}

class _updateItemDialogState extends State<updateItemDialog> {
  late final TextEditingController _titleEditingController;
  late final TextEditingController _valueEditingController;

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController();
    _valueEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _valueEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 300,
        child: Column(
          spacing: 10,
          children: [
            Text(
              "아이템 수정",
              style: TextStyle(fontSize: 20),
            ),
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
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("취소")),
                TextButton(
                    onPressed: () {
                      final title = _titleEditingController.text.trim();
                      final value = _valueEditingController.text.trim();
                      final item = Item(title,value);

                      Navigator.of(context).pop(item);
                    },
                    child: Text("저장"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
