import 'package:flutter/material.dart';
// サポートを求める場合

class SupportHintPage extends StatelessWidget {
  const SupportHintPage({super.key});

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
                  // SizedBox(
                  //   child: Container(
                  //     padding: EdgeInsets.all(16),
                  //     child: Text('このスマホを見せている方を助けてあげていただけませんか',
                  //         style: TextStyle(fontSize: 24)),
                  //   ),
                  // ),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card.filled(
                        color: Colors.orange[50],
                        shadowColor: Colors.orange,
                        elevation: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:
                              MainAxisAlignment.center, // 縦方向にセンタリング
                          children: <Widget>[
                            const Text(
                              'サポート方法のヒント',
                              textAlign: TextAlign.center, // タイトルを中央揃え
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20), // タイトルとサブタイトルの間にスペースを追加
                            const Text(
                              'placeholder (マイページの設定を引っ張ってくる)',
                              textAlign: TextAlign.center, // サブタイトルを中央揃え
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 16),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card.filled(
                        color: Colors.red[50],
                        shadowColor: Colors.red,
                        elevation: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:
                              MainAxisAlignment.center, // 縦方向にセンタリング
                          children: <Widget>[
                            const Text(
                              '緊急連絡先',
                              textAlign: TextAlign.center, // タイトルを中央揃え
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 20), // タイトルとサブタイトルの間にスペースを追加
                            const Text(
                              'placeholder (マイページの設定を引っ張ってくる)',
                              textAlign: TextAlign.center, // サブタイトルを中央揃え
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
        ));
  }
}