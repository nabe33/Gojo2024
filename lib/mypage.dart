import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

// マイページ編集
class MyPageEdit extends ConsumerStatefulWidget {
  const MyPageEdit({super.key});

  @override
  _MyPageEditState createState() => _MyPageEditState();
}

class _MyPageEditState extends ConsumerState<MyPageEdit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  final TextEditingController urgentNameController = TextEditingController();
  final TextEditingController urgentRelationController =
      TextEditingController();
  final TextEditingController urgentPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = ref.read(userProvider);
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          nameController.text = data['name'] ?? '';
          conditionController.text = data['condition'] ?? '';
          memoController.text = data['memo'] ?? '';
        }
      }

      final urgentDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('urgent')
          .doc('contact')
          .get();
      if (urgentDoc.exists) {
        final urgentData = urgentDoc.data();
        if (urgentData != null) {
          urgentNameController.text = urgentData['name'] ?? '';
          urgentRelationController.text = urgentData['relation'] ?? '';
          urgentPhoneController.text = urgentData['phone'] ?? '';
        }
      }
    }
  }

  Future<void> saveDataToFirestore(String name, String condition, String memo,
      String urgentName, String urgentRelation, String urgentPhone) async {
    final user = ref.read(userProvider);
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'condition': condition,
        'memo': memo,
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('urgent')
          .doc('contact')
          .set({
        'name': urgentName,
        'relation': urgentRelation,
        'phone': urgentPhone,
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
              'マイページ編集',
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
                  'メールアドレス：${user?.email}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: null,
                    label: RichText(
                      text: TextSpan(
                        text: '氏名',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        children: [
                          TextSpan(
                            text: '（必須）',
                            style: TextStyle(color: Colors.red, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: conditionController,
                  decoration: InputDecoration(
                    labelText: 'ご自身の状態',
                    hintText: '例）認知症',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: memoController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'サポートしてもらう際に気をつけてほしいこと',
                    hintText: '例）急な予定変更が苦手です\n「今日の予定」欄などを見て教えていただけると助かります．',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                Card(
                  color: Colors.green[100],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '緊急連絡先（必須）',
                          style: TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: urgentNameController,
                          decoration: InputDecoration(
                            labelText: '氏名',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: urgentRelationController,
                          decoration: InputDecoration(
                            labelText: '続柄',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: urgentPhoneController,
                          decoration: InputDecoration(
                            labelText: '電話番号',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () async {
                      await saveDataToFirestore(
                        nameController.text,
                        conditionController.text,
                        memoController.text,
                        urgentNameController.text,
                        urgentRelationController.text,
                        urgentPhoneController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('データを保存しました')),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary),
                    child: Text('決定',
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