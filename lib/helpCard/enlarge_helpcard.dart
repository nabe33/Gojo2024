import 'package:flutter/material.dart';
import 'package:gojo202409/main.dart';
import 'show_support_hint.dart';
import '../tasklist/tasklist_top.dart';

class EnlargeHelpCard extends StatelessWidget {
  final Map<String, dynamic> helpCard;

  const EnlargeHelpCard({super.key, required this.helpCard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(text: 'ご協力依頼'),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child: Text(
            //     'ご協力お願い',
            //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // SizedBox(height: 20),
            Center(
              child: Text(
                '私は認知症です',
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
                  helpCard['contents'] ?? 'No Contents',
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
                    elevation: 4, backgroundColor: Colors.orange),
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