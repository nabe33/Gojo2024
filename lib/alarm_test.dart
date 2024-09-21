import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlarmPage extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Singleton instance
  static final AlarmPage _instance = AlarmPage._internal();

  factory AlarmPage() {
    return _instance;
  }

  AlarmPage._internal();

  @override
  _AlarmPageState createState() => _AlarmPageState();

  final Map<String, Timer> _timers = {};

  Future<void> fetchAndSetAlarm(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final taskListSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasklist')
          .get();

      for (var doc in taskListSnapshot.docs) {
        final timeString = doc['time'] as String?;
        if (timeString != null) {
          final timeParts = timeString.split(':');
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final taskTime = TimeOfDay(hour: hour, minute: minute);
          _scheduleAlarm(doc.id, taskTime);
        }
      }
    }
  }

  void _scheduleAlarm(String taskId, TimeOfDay taskTime) {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      taskTime.hour,
      taskTime.minute,
    );

    final difference = selectedDateTime.difference(now).inSeconds;

    if (difference > 0) {
      print("Scheduling alarm for task: $taskId in $difference seconds.");
      _timers[taskId] = Timer(Duration(seconds: difference), () {
        _showAlarmDialog(taskId);
      });
    } else {
      final nextDayDateTime = selectedDateTime.add(Duration(days: 1));
      final differenceNextDay = nextDayDateTime.difference(now).inSeconds;
      print(
          "Scheduling alarm for task: $taskId tomorrow in $differenceNextDay seconds.");
      _timers[taskId] = Timer(Duration(seconds: differenceNextDay), () {
        _showAlarmDialog(taskId);
      });
    }
    print("Current timers after scheduling: $_timers");
  }

  void cancelAllAlarms() {
    print("cancelAllAlarms called");
    print("Current timers: $_timers");

    for (var timer in _timers.values) {
      if (timer.isActive) {
        print("Cancelling timer: $timer");
        timer.cancel();
      }
    }
    _timers.clear();
  }

  Future<void> _showAlarmDialog(String taskId) async {
    final player = AudioPlayer();
    try {
      await player.play(AssetSource('sounds/chime_01.mp3'));
      print('アラームが鳴りました');
    } catch (e) {
      print('audio player error: $e');
      // _showErrorDialog('Failed to play sound: $e');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final taskDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasklist')
          .doc(taskId)
          .get();

      if (taskDoc.exists) {
        final taskData = taskDoc.data();
        final taskTime = taskData?['time'] ?? '時間が保存されていません';
        final taskContent = taskData?['task'] ?? 'やることが保存されていません';

        final context = navigatorKey.currentState?.overlay?.context;
        if (context != null) {
          showGeneralDialog(
            context: context,
            barrierDismissible: false,
            barrierLabel: 'アラーム',
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AlertDialog(
                backgroundColor: Colors.orange,
                title: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.alarm_on, size: 60),
                      Text(
                        taskTime,
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'になりました',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                content: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 24, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '$taskContent\n',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text:
                                'は終わりましたか？\n\n終了したら，「今日の予定」のチェックボックスをチェックしてください．'),
                      ],
                    ),
                  ),
                ),
                // content: Center(
                //     child: Text('になりました\n$taskContent\nは終わりましたか？',
                //         style: TextStyle(fontSize: 24))),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text('はい',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  void _showErrorDialog(String errorMessage) {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class _AlarmPageState extends State<AlarmPage> {
  TimeOfDay selectedTime = TimeOfDay.now();
  Timer? _timer;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    widget.fetchAndSetAlarm(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アラーム設定'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("現在選択されている時刻: ${selectedTime.format(context)}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('アラーム時刻を選択'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      widget._scheduleAlarm('taskId',
          selectedTime); // 'taskId' should be replaced with actual task ID
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}