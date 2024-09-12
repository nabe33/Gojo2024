import 'package:flutter/material.dart';

class EnlargeHelpCard extends StatelessWidget {
  final Map<String, dynamic> helpCard;

  const EnlargeHelpCard({super.key, required this.helpCard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 100.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/GOJO.png', height: 50),
            Text(
              'ご協力願い',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'お願いしたいこと',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                helpCard['title'] ?? 'No Title',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'お願いしたいことの詳細',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                helpCard['contents'] ?? 'No Contents',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context, true); // Return true to indicate completion
                },
                style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary),
                child: Text(
                  '完了',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}