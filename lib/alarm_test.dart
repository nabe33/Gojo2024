import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  TimeOfDay selectedTime = TimeOfDay.now();
  Timer? _timer;

  // Function to show error dialog
  void _showErrorDialog(BuildContext context, String errorMessage) {
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

  // audioplayerのインスタンスを作成
  final player = AudioPlayer();

  // アラーム時刻を選択する関数
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      _scheduleAlarm();
    }
  }

  // 指定した時刻にアラームを表示する関数
  void _scheduleAlarm() {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final difference = selectedDateTime.difference(now).inSeconds;

    if (difference > 0) {
      _timer?.cancel();
      _timer = Timer(Duration(seconds: difference), () {
        _showAlarmDialog();
      });
    } else {
      // もし過去の時間を選んだ場合には翌日に設定
      final nextDayDateTime = selectedDateTime.add(Duration(days: 1));
      final differenceNextDay = nextDayDateTime.difference(now).inSeconds;
      _timer?.cancel();
      _timer = Timer(Duration(seconds: differenceNextDay), () {
        _showAlarmDialog();
      });
    }
  }

  // アラームダイアログを表示する関数
  Future<void> _showAlarmDialog() async {
    // play sounds
    try {
      await player.play(AssetSource('sounds/chime_01.mp3'));
      print('アラームが鳴りました！');
    } catch (e) {
      print('audio player error: $e'); //
      _showErrorDialog(context, 'Failed to play sound: $e');
    }
    // vibrate

    //
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('アラーム'),
          content: Text('指定した時間になりました！'),
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
            Text(
              "現在選択されている時刻: ${selectedTime.format(context)}",
            ),
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}