import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../alarm_test.dart';
import '../main.dart';
import 'add_task.dart';
import 'edit_tasklist.dart';

class TaskListPage extends ConsumerStatefulWidget {
  final bool displayButton;

  const TaskListPage({super.key, this.displayButton = false});

  @override
  _HelpCardListPageState createState() => _HelpCardListPageState();
}

class _HelpCardListPageState extends ConsumerState<TaskListPage> {
  late Future<List<Map<String, dynamic>>> _taskListFuture;
  Map<String, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    _taskListFuture = fetchTaskList();
  }

  Future<List<Map<String, dynamic>>> fetchTaskList() async {
    final user = ref.read(userProvider);
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasklist')
          .orderBy('time', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // ドキュメントIDを追加
        return data;
      }).toList();
    }
    return [];
  }

  void _refreshTaskList() {
    setState(() {
      _taskListFuture = fetchTaskList();
    });
  }

  void _toggleCheck(String taskId, bool currentCheck) async {
    final user = ref.read(userProvider);
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasklist')
          .doc(taskId)
          .update({'check': !currentCheck});
      _refreshTaskList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 戻るアイコンを表示しない
        title: Center(
          child: Text('今日の予定一覧',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Column(
        children: [
          if (widget.displayButton)
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTaskPage(),
                      ),
                    );
                    if (result == true) {
                      _refreshTaskList(); // Refresh the list if changes were made
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff82d3e3), // 背景色を指定
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text(
                        "予定を追加",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black),
                      )
                    ],
                  )),
            ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _taskListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('まだ今日の予定が作成されていません'));
                } else {
                  final taskLists = snapshot.data!;
                  return ListView.builder(
                    itemCount: taskLists.length,
                    itemBuilder: (context, index) {
                      final taskList = taskLists[index];
                      final isExpanded =
                          _expandedStates[taskList['id']] ?? false;
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadowColor: Colors.blue,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedStates[taskList['id']] = !isExpanded;
                            });
                          },
                          child: Column(
                            children: [
                              ListTile(
                                leading: Checkbox(
                                  value: taskList['check'] ?? false,
                                  onChanged: (bool? value) {
                                    _toggleCheck(taskList['id'],
                                        taskList['check'] ?? false);
                                  },
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      taskList['time'] ?? '時間が保存されていません',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text('：'),
                                    Expanded(
                                      child: Text(
                                        taskList['task'] ?? 'やることが保存されていません',
                                        maxLines: 3,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more),
                                  iconSize: 32,
                                  onPressed: () {
                                    setState(() {
                                      _expandedStates[taskList['id']] =
                                          !isExpanded;
                                    });
                                  },
                                ),
                              ),
                              if (isExpanded) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '　メモ：${taskList['memo'] ?? 'メモが保存されていません'}',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '　場所：${taskList['place'] ?? '場所が保存されていません'}',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      SizedBox(height: 8),
                                      // 下部の編集・削除ボタン
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: Color(0xff0a70c2)),
                                            iconSize: 32,
                                            onPressed: () async {
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditTaskList(
                                                          task: taskList),
                                                ),
                                              );
                                              if (result == true) {
                                                _refreshTaskList(); // Refresh the list if changes were made
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Color(0xffda1a0c)),
                                            iconSize: 32,
                                            onPressed: () async {
                                              final user =
                                                  ref.read(userProvider);
                                              if (user != null) {
                                                final shouldDelete =
                                                    await showDialog<bool>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('確認'),
                                                      content: Text(
                                                          '本当に削除してよいですか？',
                                                          style: TextStyle(
                                                              fontSize: 20)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(
                                                                    true); // Cancel
                                                          },
                                                          child: Text('はい'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(
                                                                    false); // Confirm
                                                          },
                                                          child: Text('いいえ'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                                if (shouldDelete == true) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(user.uid)
                                                      .collection('tasklist')
                                                      .doc(taskList[
                                                          'id']) // ドキュメントIDを指定
                                                      .delete();
                                                  _refreshTaskList(); // データを再読み込み
                                                  // アラーム設定
                                                  AlarmPage().cancelAllAlarms();
                                                  AlarmPage().fetchAndSetAlarm(
                                                      context);
                                                }
                                              }
                                            },
                                          )
                                          // IconButton(
                                          //     icon: Icon(Icons.delete,
                                          //         color: Colors.red),
                                          //     onPressed: () async {
                                          //       final user =
                                          //           ref.read(userProvider);
                                          //       if (user != null) {
                                          //         await FirebaseFirestore
                                          //             .instance
                                          //             .collection('users')
                                          //             .doc(user.uid)
                                          //             .collection('tasklist')
                                          //             .doc(taskList[
                                          //                 'id']) // ドキュメントIDを指定
                                          //             .delete();
                                          //         _refreshTaskList(); // データを再読み込み
                                          //         // アラーム設定
                                          //         AlarmPage().cancelAllAlarms();
                                          //         AlarmPage().fetchAndSetAlarm(
                                          //             context);
                                          //       }
                                          //     }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          if (widget.displayButton) SizedBox(height: 16),
          if (widget.displayButton)
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTaskPage(),
                      ),
                    );
                    if (result == true) {
                      _refreshTaskList(); // Refresh the list if changes were made
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff82d3e3), // 背景色を指定
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text(
                        "予定を追加",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black),
                      )
                    ],
                  )),
            ),
        ],
      ),
    );
  }
}