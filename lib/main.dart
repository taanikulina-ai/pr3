import 'package:flutter/material.dart';

void main() {
  runApp(StaticListViewApp());
}

class StaticListViewApp extends StatelessWidget {
 const StaticListViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Важные заметки')),
        body: StaticListViewWidget(),
      ),
    );
  }
}

class StaticListViewWidget extends StatefulWidget {
  const StaticListViewWidget({super.key});

  @override
  State<StaticListViewWidget> createState() => _StaticListViewWidgetState();
}

class _StaticListViewWidgetState extends State<StaticListViewWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _notes = [];
  List<Widget> _staticListItems = [];
  int _editingIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
      print('Текущий текст: ${_controller.text}');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateStaticListItems() {
    _staticListItems = _notes.map((note) {
      final int index = _notes.indexOf(note);
      return ListTile(
        title: Text(note),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _editingIndex = index;
                  _controller.text = _notes[index];
                });
              },
              child: Text('Изменить'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _notes.removeAt(index);
                  if (_editingIndex == index) {
                    _editingIndex = -1;
                    _controller.clear();
                  }
                  updateStaticListItems();
                });
              },
              child: Text('Удалить'),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'введите текст',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              String inputValue = _controller.text;
              if (inputValue.trim().isEmpty) return;
              setState(() {
                if (_editingIndex == -1) {
                  _notes.add(inputValue);
                } else {
                  _notes[_editingIndex] = inputValue;
                  _editingIndex = -1;
                }
                _controller.clear();
                updateStaticListItems();
              });
            },
            child: Text(_editingIndex == -1 ? 'Сохранить' : 'Обновить'),
          ),

          SizedBox(height: 10),

          Text('текущий текст: ${_controller.text}'),

          SizedBox(height: 10),

          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: _staticListItems,
            ),
          ),
        ],
      ),
    );
  }
}