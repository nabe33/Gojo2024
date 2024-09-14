import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import 'add_task.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  _HelpCardListPageState createState() => _HelpCardListPageState();
}

class _HelpCardListPageState extends ConsumerState<TaskListPage> {
  late Future<List<Map<String, dynamic>>> _taskListFuture;

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
      // return querySnapshot.docs.map((doc) => doc.data()).toList();
    }
    return [];
  }

  void _refreshTaskList() {
    setState(() {
      _taskListFuture = fetchTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('今日の予定一覧'),
      ),
      body: Column(
        children: [
          // 挿入
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text(
                      "やりたいことを追加",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadowColor: Colors.blue,
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(taskList['time'] ?? '時間が保存されていません'),
                              Text('：'),
                              Text(taskList['task'] ?? 'やることが保存されていません'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /*
                              TextButton(
                                onPressed: () async {
                                  // final result = await Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         EnlargeHelpCard(helpCard: helpCard),
                                  //   ),
                                  // );
                                  // if (result == true) {
                                  //   _refreshHelpCards(); // Refresh the list if changes were made
                                  // }
                                },
                                child: Text(
                                  '拡大',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),*/
                              // IconButton(
                              //   icon: Icon(Icons.lens, color: Colors.blue),
                              //   onPressed: () async {
                              //     final result = await Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) =>
                              //             EnlargeHelpCard(helpCard: helpCard),
                              //       ),
                              //     );
                              //     if (result == true) {
                              //       _refreshHelpCards(); // Refresh the list if changes were made
                              //     }
                              //   },
                              // ),
                              /*
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  // final result = await Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         EditHelpCard(helpCard: helpCard),
                                  //   ),
                                  // );
                                  // if (result == true) {
                                  //   _refreshHelpCards(); // Refresh the list if changes were made
                                  // }
                                },
                              ),*/
                              /*
                              IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final user = ref.read(userProvider);
                                    if (user != null) {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('helpcard')
                                          .doc(taskList['id']) // ドキュメントIDを指定
                                          .delete();
                                      _refreshTaskList(); // データを再読み込み
                                    }
                                  }),*/
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
          SizedBox(height: 16),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text(
                      "やりたいことを追加",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )),
          ),
          /*
          ElevatedButton(
            onPressed: () async {
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => NewCardPage()),
              // );
              // _refreshHelpCards();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 28, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'カードを追加',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),*/
          SizedBox(height: 16),
          // ElevatedButton(
          //   onPressed: () {},
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Icon(Icons.edit, size: 28, color: Colors.black),
          //       SizedBox(width: 8),
          //       Text(
          //         'カードを編集・削除',
          //         style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 24,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}