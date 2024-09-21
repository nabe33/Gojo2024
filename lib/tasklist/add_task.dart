import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../alarm_test.dart';
import '../main.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  _MyPageEditState createState() => _MyPageEditState();
}

class _MyPageEditState extends ConsumerState<AddTaskPage> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  TimeOfDay? selectedTime;
  // String selectedTask = 'どこかに行く';

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveDataToFirestore(
      String place, String memo, TimeOfDay? time, String task) async {
    final user = ref.read(userProvider);
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasklist')
          .doc()
          .set({
        'place': place,
        'memo': memo,
        'time': time != null
            ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
            : null,
        'task': task,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: MyAppBar(text: '今日の予定追加'),
      // AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   toolbarHeight: 100.0,
      //   title: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Image.asset('assets/images/GOJO.png', height: 50),
      //       Text(
      //         '今日の予定追加',
      //         style: TextStyle(
      //             fontSize: 20,
      //             color: Colors.orange,
      //             fontWeight: FontWeight.bold),
      //       ),
      //     ],
      //   ),
      // ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '今日の予定を追加しましょう',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                // ここから入力欄が並ぶ
                Text(
                  '時間',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text(selectedTime != null
                      ? '${selectedTime!.hour}:${selectedTime!.minute}'
                      : '時間を選択'),
                ),
                SizedBox(height: 24),
                //
                Text(
                  'やること',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    hintText: '例）どこかに行く，乗る・降りる，買い物',
                    border: OutlineInputBorder(),
                  ),
                ),
                /*DropdownButton<String>(
                  value: selectedTask,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTask = newValue!;
                    });
                  },
                  items: <String>['どこかに行く', '乗り物に乗る・降りる', '買い物をする', 'その他']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                */
                SizedBox(height: 24),
                Text(
                  '場所',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: placeController,
                  decoration: InputDecoration(
                    hintText: '例）自宅　〇〇駅　〇〇病院',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'メモ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: memoController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: '例）病院でいつもの薬をもらう．',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () async {
                    await saveDataToFirestore(
                      placeController.text,
                      memoController.text,
                      selectedTime,
                      taskController.text,
                    );
                    // アラーム設定
                    AlarmPage().cancelAllAlarms();
                    AlarmPage().fetchAndSetAlarm(context);
                    //
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('今日の予定を保存しました')),
                    );
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary),
                  child: Text('保存',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}