import 'package:flutter/material.dart';
import 'package:gojo202409/main.dart';
import 'show_support_hint.dart';
import '../tasklist/tasklist_top.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnlargeHelpCard extends StatefulWidget {
  final Map<String, dynamic> helpCard;

  const EnlargeHelpCard({super.key, required this.helpCard});

  @override
  _EnlargeHelpCardState createState() => _EnlargeHelpCardState();
}

class _EnlargeHelpCardState extends State<EnlargeHelpCard> {
  String condition = 'ーーー';

  @override
  void initState() {
    super.initState();
    _fetchCondition();
  }

  Future<void> _fetchCondition() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          condition = doc['condition'] ?? 'ーーー';
        });
      }
    } catch (e) {
      print('Error fetching condition: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(text: 'ご協力依頼'),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              shadowColor: Colors.orange,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        '私は${condition ?? 'ーーー'}です',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(4),
                        child: Text(
                          widget.helpCard['contents'] ?? 'データなし',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        'お手伝いしてください',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowSupportHintPage()));

                  // Navigator.pop(
                  //     context, true); // Return true to indicate completion
                },
                style: ElevatedButton.styleFrom(
                    elevation: 4, backgroundColor: Color(0xff82d3e3)),
                child: Text(
                  'サポート方法のヒント',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 4),
            Divider(
              color: Colors.blue, // 線の色
              thickness: 2.0, // 線の太さ
            ),
            Expanded(child: TaskListPage(displayButton: false))
          ],
        ),
      ),
    );
  }
}