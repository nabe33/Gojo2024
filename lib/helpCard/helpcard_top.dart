import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import 'newcard.dart';

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

      return querySnapshot.docs.map((doc) => doc.data()).toList();
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
        title: Text('ヘルプカード'),
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
                        child: ListTile(
                          title: Text(helpCard['title'] ?? 'No Title'),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewCardPage()),
              );
              _refreshHelpCards();
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
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, size: 28, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'カードを編集・削除',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}