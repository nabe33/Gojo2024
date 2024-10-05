import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';

class EditHelpCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> helpCard;

  const EditHelpCard({super.key, required this.helpCard});

  @override
  _EditHelpCardState createState() => _EditHelpCardState();
}

class _EditHelpCardState extends ConsumerState<EditHelpCard> {
  late TextEditingController _titleController;
  late TextEditingController _contentsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.helpCard['title']);
    _contentsController =
        TextEditingController(text: widget.helpCard['contents']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentsController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final user = ref.read(userProvider);
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('helpcard')
          .doc(widget.helpCard['id'])
          .update({
        'title': _titleController.text,
        'contents': _contentsController.text,
      });
    }
    Navigator.pop(context, true); // Return true to indicate changes were made
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(text: 'ヘルプカード編集'),
      // AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   toolbarHeight: 100.0,
      //   title: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Image.asset('assets/images/GOJO.png', height: 50),
      //       Text(
      //         'ヘルプカード編集',
      //         style: TextStyle(
      //             fontSize: 20,
      //             color: Colors.orange,
      //             fontWeight: FontWeight.bold),
      //       ),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'どういった状況でこのカードを使いますか？',
                  labelStyle: TextStyle(fontSize: 17),
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: _contentsController,
                decoration: InputDecoration(
                  labelText: 'どう手伝って欲しいですか？',
                  labelStyle: TextStyle(fontSize: 17),
                ),
                maxLines: 8,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  _saveChanges();
                  // await saveDataToFirestore(
                  //   titleController.text,
                  //   contentsController.text,
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ヘルプカードを保存しました')),
                  );
                  // Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: Color(0xFF82d3e3),
                ),
                child: Text(
                  '保存',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // ElevatedButton(
              //   onPressed: _saveChanges,
              //   child: Text('保存'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}