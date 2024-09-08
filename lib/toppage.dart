import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    _fetchData();
  }

  void _fetchData() {
    final docRef = FirebaseFirestore.instance
        .collection("cities")
        .orderBy("name", descending: true)
        .limit(3);

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
      },
      onError: (error) => print("Error completing: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 100.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/GOJO.png', height: 50),
            Text(
              'やりたいことを叶える助け合いアプリ',
              style: TextStyle(
                  fontSize: 20,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/image_m.jpg'), // イメージ画像
              const SizedBox(height: 24),
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
                      ElevatedButton(onPressed: () {}, child: Text('マイページ編集')),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 36),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'アプリの利用開始',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold),
                  )),
              Spacer(),
              ElevatedButton(
                  onPressed: () {},
                  child: Text('ヘルプ', style: TextStyle(fontSize: 20))),
              SizedBox(height: 12),
              ElevatedButton(onPressed: () {}, child: Text('ログアウト')),
              SizedBox(height: 12),

/*
              Expanded(
                child: ListView.builder(
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_dataList[index]),
                    );
                  },
                ),
              ),
 */
              /*
              TextButton(
                onPressed: () => {
                  // Firestoreページに遷移
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const FirebaseStoragePage()),
                  // )
                },
                child: const Text(
                  'dummy text',
                  style: TextStyle(fontSize: 24),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}