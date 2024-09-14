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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('今日の予定一覧'),
      ),
      body: Column(
        children: [
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
                                title: Row(
                                  children: [
                                    Text(
                                      taskList['time'] ?? '時間が保存されていません',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('：'),
                                    Text(
                                      taskList['task'] ?? 'やることが保存されていません',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more),
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
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '　場所：${taskList['place'] ?? '場所が保存されていません'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Expanded(
                                      //         child:
                                      //             Container()), // This ensures the IconButton is right-aligned
                                      //     IconButton(
                                      //       icon: Icon(Icons.expand_less),
                                      //       onPressed: () {
                                      //         setState(() {
                                      //           _expandedStates[
                                      //               taskList['id']] = false;
                                      //         });
                                      //       },
                                      //     ),
                                      //   ],
                                      // ),
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
        ],
      ),
    );
  }
}