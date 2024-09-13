import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class ShowSupportHintPage extends ConsumerWidget {
  ShowSupportHintPage({super.key});

  // var memo;

  Future<String> fetchMemo(WidgetRef ref, String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final data = doc.data();
      if (data != null) {
        return data['memo'] ?? 'まだ作成されていません';
      } else {
        return 'まだ作成されていません';
      }
    } catch (e) {
      print('Error fetching memo: $e');
      throw Exception('Failed to fetch memo');
    }
  }

  Future<List<Map<String, dynamic>>> fetchUrgentContacts(
      WidgetRef ref, String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('urgent')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          toolbarHeight: 100.0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/GOJO.png', height: 50),
              Text(
                'サポート方法のヒント',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: Center(
          child: Text('エラー：ユーザーが見つかりません'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 100.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/GOJO.png', height: 50),
            Text(
              'サポート方法のヒント',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 36),
              FutureBuilder<String>(
                future: fetchMemo(ref, user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('エラーが発生しました');
                  } else {
                    final memo = snapshot.data ?? 'まだ作成されていません';
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'サポート方法のヒント',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            memo,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 36),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchUrgentContacts(ref, user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('エラーが発生しました');
                  } else {
                    final contacts = snapshot.data ?? [];
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '緊急連絡先',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            ...contacts.map((contact) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '・氏名: ${contact['name'] ?? 'ーー'}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '・続柄: ${contact['relation'] ?? 'ーー'}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '・電話番号: ${contact['phone'] ?? 'ーー'}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 8),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}