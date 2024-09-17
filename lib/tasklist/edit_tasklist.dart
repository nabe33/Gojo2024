import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../alarm_test.dart';
import '../main.dart';

class EditTaskList extends ConsumerStatefulWidget {
  final Map<String, dynamic> task;

  const EditTaskList({super.key, required this.task});

  @override
  _EditTaskListState createState() => _EditTaskListState();
}

class _EditTaskListState extends ConsumerState<EditTaskList> {
  late TextEditingController _memoController;
  late TextEditingController _taskController;
  late TextEditingController _placeController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.task['memo']);
    _taskController = TextEditingController(text: widget.task['task']);
    _placeController = TextEditingController(text: widget.task['place']);
    _timeController = TextEditingController(text: widget.task['time']);
  }

  @override
  void dispose() {
    _memoController.dispose();
    _taskController.dispose();
    _placeController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final user = ref.read(userProvider);
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasklist')
          .doc(widget.task['id'])
          .update({
        'memo': _memoController.text,
        'task': _taskController.text,
        'place': _placeController.text,
        'time': _timeController.text,
      });
    }
    Navigator.pop(context, true); // Return true to indicate changes were made
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 100.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/GOJO.png', height: 50),
            Text(
              '今日の予定編集',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('時間:', style: TextStyle(fontSize: 16)),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _timeController.text = MaterialLocalizations.of(context)
                            .formatTimeOfDay(picked,
                                alwaysUse24HourFormat: true);
                      });
                    }
                  },
                  child: Text(_timeController.text.isEmpty
                      ? '時間を選択'
                      : _timeController.text),
                ),
              ],
            ),
            SizedBox(height: 24),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'やること',
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _placeController,
              decoration: InputDecoration(
                labelText: '場所',
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _memoController,
              decoration: InputDecoration(
                labelText: 'メモ',
                labelStyle: TextStyle(fontSize: 16),
              ),
              maxLines: 8,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                _saveChanges();
                // await saveDataToFirestore(
                //   titleController.text,
                //   contentsController.text,
                // );
                // アラーム設定
                AlarmPage().cancelAllAlarms();
                AlarmPage().fetchAndSetAlarm(context);
                //
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('今日の予定を保存しました')),
                );
                // Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor:
                      Theme.of(context).colorScheme.inversePrimary),
              child: Text(
                '保存',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // ElevatedButton(
            //   onPressed: _saveChanges,
            //   child: Text('保存'),
            // ),
          ],
        ),
      ),
    );
  }
}