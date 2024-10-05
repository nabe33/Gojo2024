import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'tabs_top.dart';
import 'mypage.dart';

// トップページ：マイページ設定，アプリを始める，ログアウト，チュートリアル
class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  // List<String> _dataList = [];
  String? _uid;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // _fetchData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    if (uid != null) {
      setState(() {
        _uid = uid;
      });
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100.0,
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/GOJO.png', height: 50),
              Text(
                'やりたいことを叶える助け合いアプリ',
                style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF7A4800),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      // Body-----------------
      body: Center(
        child: Container(
          color: Color(0xFF82D3E3),
          // color: Theme.of(context).colorScheme.inversePrimary,
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            // ここを追加
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/image_m.jpg', height: 200), // イメージ画像
                const SizedBox(height: 12),
                if (_userData != null) ...[
                  Text(
                    'ようこそ、${_userData!['name']}さん',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                ],
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'マイページを作成していない人は下記から作成してください．作成済みマイペーシの編集も可能です．',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPageEdit()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff82d3e3),
                          ),
                          child: Text('マイページ編集',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TabsTopPage()),
                    );
                  },
                  child: Text(
                    'アプリの利用開始',
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xffc14401),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),

                // SizedBox(height: 12),
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', false);
                      await prefs.remove('uid');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyLogin()),
                      );
                    },
                    child: Text('ログアウト')),
                SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}