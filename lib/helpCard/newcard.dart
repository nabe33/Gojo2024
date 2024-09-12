import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';

// ヘルプカード新規作成
class NewCardPage extends ConsumerStatefulWidget {
  const NewCardPage({super.key});

  @override
  _MyPageEditState createState() => _MyPageEditState();
}

class _MyPageEditState extends ConsumerState<NewCardPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveDataToFirestore(String title, String contents) async {
    final user = ref.read(userProvider);
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('helpcard')
          .doc()
          .set({
        'title': title,
        'contents': contents,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 100.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/GOJO.png', height: 50),
            Text(
              'ヘルプカード作成',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'どういった状況でこのカードを使いますか？',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: '例）道に迷ったとき',
                    label: null,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'どう手伝って欲しいですか？',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextField(
                  controller: contentsController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: '例）次の予定の場所に行きたいです．行き方を教えてください．',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () async {
                      await saveDataToFirestore(
                        titleController.text,
                        contentsController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ヘルプカードを保存しました')),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary),
                    child: Text('保存',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}