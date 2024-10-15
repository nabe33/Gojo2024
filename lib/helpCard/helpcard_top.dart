import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import 'newcard.dart';
import 'edit_helpcard.dart';
import 'enlarge_helpcard.dart';

class HelpCardListPage extends ConsumerStatefulWidget {
  const HelpCardListPage({super.key});

  @override
  _HelpCardListPageState createState() => _HelpCardListPageState();
}

class _HelpCardListPageState extends ConsumerState<HelpCardListPage> {
  late Future<List<Map<String, dynamic>>> _helpCardsFuture;

  @override
  void initState() {
    super.initState();
    _helpCardsFuture = fetchHelpCards();
  }

  Future<List<Map<String, dynamic>>> fetchHelpCards() async {
    final user = ref.read(userProvider);
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('helpcard')
          .orderBy('timestamp', descending: true)
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

  void _refreshHelpCards() {
    setState(() {
      _helpCardsFuture = fetchHelpCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 戻るアイコンを表示しない
        title: Center(
          child: Text(
            'ヘルプカード',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _helpCardsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('まだヘルプカードが作成されていません'));
                } else {
                  final helpCards = snapshot.data!;
                  return ListView.builder(
                    itemCount: helpCards.length,
                    itemBuilder: (context, index) {
                      final helpCard = helpCards[index];
                      return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadowColor: Colors.orange,
                          //
                          child: InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      EnlargeHelpCard(helpCard: helpCard),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                              // final result = await Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         EnlargeHelpCard(helpCard: helpCard),
                              //   ),
                              // );
                              if (result == true) {
                                _refreshHelpCards(); // Refresh the list if changes were made
                              }
                            },
                            //
                            child: ListTile(
                              title: Text(
                                helpCard['title'] ?? 'No Title',
                                style: TextStyle(color: Colors.black),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              EnlargeHelpCard(
                                                  helpCard: helpCard),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                      // final result = await Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => EnlargeHelpCard(
                                      //         helpCard: helpCard),
                                      //   ),
                                      // );
                                      if (result == true) {
                                        _refreshHelpCards(); // Refresh the list if changes were made
                                      }
                                    },
                                    child: Text(
                                      '拡大',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0a70c2),
                                          fontSize: 17),
                                    ),
                                  ),
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
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Color(0xff0a70c2)),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditHelpCard(helpCard: helpCard),
                                        ),
                                      );
                                      if (result == true) {
                                        _refreshHelpCards(); // Refresh the list if changes were made
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Color(0xffda1a0c)),
                                    onPressed: () async {
                                      final user = ref.read(userProvider);
                                      if (user != null) {
                                        final shouldDelete =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('確認'),
                                              content: Text(
                                                '本当に削除してよいですか？',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true); // Cancel
                                                  },
                                                  child: Text('はい'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false); // Confirm
                                                  },
                                                  child: Text('いいえ'),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (shouldDelete == true) {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user.uid)
                                              .collection('helpcard')
                                              .doc(
                                                  helpCard['id']) // ドキュメントIDを指定
                                              .delete();
                                          _refreshHelpCards(); // データを再読み込み
                                        }
                                      }
                                    },
                                  )
                                  // IconButton(
                                  //     icon: Icon(Icons.delete, color: Colors.red),
                                  //     onPressed: () async {
                                  //       final user = ref.read(userProvider);
                                  //       if (user != null) {
                                  //         await FirebaseFirestore.instance
                                  //             .collection('users')
                                  //             .doc(user.uid)
                                  //             .collection('helpcard')
                                  //             .doc(helpCard['id']) // ドキュメントIDを指定
                                  //             .delete();
                                  //         _refreshHelpCards(); // データを再読み込み
                                  //       }
                                  //     }),
                                ],
                              ),
                            ),
                          ));
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
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewCardPage()),
                );
                _refreshHelpCards();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff82d3e3), // 背景色を指定
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 24, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'カードを追加',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          SizedBox(height: 16),
        ],
      ),
    );
  }
}