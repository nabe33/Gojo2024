import 'package:flutter/material.dart';
import 'support_hint.dart';
// サポートを求める場合

class Support1Page extends StatelessWidget {
  const Support1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Placeholder extends StatelessWidget {
  const Placeholder({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/GOJO.png', height: 50),
              ],
            ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: '今日の予定',
                ),
                Tab(
                  text: 'ご協力依頼',
                ),
              ],
            ),
          ),
          // Body-----------------------------
          body: TabBarView(
            children: <Widget>[
              // 今日の予定Tab
              Center(
                child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text(
                          "やりたいことを追加",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
              ),
              // ご協力依頼Tab ********************************
              ListView(
                children: [
                  SizedBox(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Text('このスマホを見せている方（氏名を入れる）を助けてあげていただけませんか',
                          style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card.filled(
                        color: Colors.orange[100],
                        shadowColor: Colors.orange,
                        elevation: 8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:
                              MainAxisAlignment.center, // 縦方向にセンタリング
                          children: <Widget>[
                            const Text(
                              'ご協力お願い',
                              textAlign: TextAlign.center, // タイトルを中央揃え
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20), // タイトルとサブタイトルの間にスペースを追加
                            const Text(
                              '私は「認知症」です．お手伝いしてくださいませんか．',
                              textAlign: TextAlign.center, // サブタイトルを中央揃え
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SupportHintPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // アイコンとテキストを中央揃え
                        children: [
                          Text(
                            'サポート方法のヒント',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8), // アイコンとテキストの間の余白
                          Icon(Icons.more_vert,
                              size: 28, color: Colors.black), // 挿入するアイコン
                        ],
                      )),
                ],
              ),
            ],
          ),
        ));
  }
}