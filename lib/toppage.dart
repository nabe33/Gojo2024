import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'tabs_top.dart';
import 'mypage.dart';

// トップページ：マイページ設定，アプリを始める，ログアウト，チュートリアル
class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<String> _dataList = [];

  @override
  void initState() {
    super.initState();
    // _fetchData();
  }

  // 以下の処理は無意味？
  /*
  void _fetchData() {
    final docRef = FirebaseFirestore.instance
        .collection("cities")
        .orderBy("name", descending: true)
        .limit(3);

    print("docRef: $docRef");

    docRef.get().then(
      (event) {
        print("成功!");
        List<String> dataList = [];
        for (var doc in event.docs) {
          dataList.add('${doc.id} => ${doc.data()}');
        }
        setState(() {
          _dataList = dataList;
        });

        print("dataList: $dataList");
      },
      onError: (error) => print("Error completing: $error"),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/GOJO.png', height: 50),
            Text(
              'やりたいことを叶える助け合いアプリ',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      // Body-----------------
      body: Center(
        child: Container(
          color: Theme.of(context).colorScheme.inversePrimary,
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            // ここを追加
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/image_m.jpg', height: 240), // イメージ画像
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'マイページを作成していない人は下記から作成してください．作成済みマイペーシの編集も可能です．',
                          style: TextStyle(
                            fontSize: 16,
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
                            child: Text('マイページ編集')),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
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
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 12),

                SizedBox(height: 12),
                ElevatedButton(onPressed: () {}, child: Text('ログアウト')),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}