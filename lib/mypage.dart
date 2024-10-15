import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'toppage.dart';

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
      appBar: MyAppBar(text: 'マイページ編集'),
      // AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   toolbarHeight: 100.0,
      //   title: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Image.asset('assets/images/GOJO.png', height: 50),
      //       Text(
      //         'マイページ編集',
      //         style: TextStyle(
      //             fontSize: 20,
      //             color: Colors.orange,
      //             fontWeight: FontWeight.bold),
      //       ),
      //     ],
      //   ),
      // ),
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
                        text: 'アプリ利用者の氏名',
                        style: TextStyle(color: Colors.black, fontSize: 17.0),
                        children: [
                          TextSpan(
                            text: '（必須）',
                            style: TextStyle(color: Colors.red, fontSize: 17.0),
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
                    labelText: 'アプリ利用者の状態',
                    hintText: '例）認知症',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '下記⇓はヘルプカードを見せるときに表示される文章です',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: memoController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'サポートしてもらう際に気をつけてほしいこと',
                    labelStyle: TextStyle(fontSize: 17.0),
                    hintText: '例）急な予定変更が苦手です\n「今日の予定」欄などを見て教えていただけると助かります．',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                // 緊急連絡先
                Card(
                  color: Color(0xfffdf7dd),
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
                              color: Color(0xffc1170b)),
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
                        SnackBar(
                          content: Text('データを保存しました',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          duration: Duration(seconds: 2),
                          backgroundColor: Color(0xffc8e6c9),
                        ),
                      );
                      // Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TopPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: Color(0xff82d3e3),
                    ),
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