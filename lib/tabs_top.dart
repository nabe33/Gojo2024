import 'package:flutter/material.dart';
import 'helpCard/helpcard_top.dart';
import 'fixed_supports/support1.dart';

class TabsTopPage extends StatefulWidget {
  const TabsTopPage({super.key});

  @override
  State<TabsTopPage> createState() => _TabsTopPageState();
}

class _TabsTopPageState extends State<TabsTopPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
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
              // ご協力依頼Tab
              HelpCardListPage(),
              /*
              ListView(
                children: [
                  SizedBox(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Text('下記カードをクリックして相手に協力を求めてください',
                          style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Support1Page()),
                      );
                    },
                    child: Card1(text: 'サポートを求める'), // カスタムカードウィジェット
                  ),
                  Card1(text: 'サポートを求める'),
                  Card1(text: '道に迷ったとき'),
                  Card1(text: '操作方法がわからないとき'),
                  Card1(text: '何か聞きたいことがあるとき'),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // アイコンとテキストを中央揃え
                        children: [
                          Icon(Icons.add,
                              size: 28, color: Colors.black), // 挿入するアイコン
                          SizedBox(width: 8), // アイコンとテキストの間の余白
                          Text(
                            'カードを追加',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // アイコンとテキストを中央揃え
                        children: [
                          Icon(Icons.edit,
                              size: 28, color: Colors.black), // 挿入するアイコン
                          SizedBox(width: 8), // アイコンとテキストの間の余白
                          Text(
                            'カードを編集・削除',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              */
            ],
          ),
        ));
  }
}

// 最初から用意されている協力依頼を見せるカード
class Card1 extends StatelessWidget {
  final String text; // 引数を追加

  const Card1({super.key, required this.text}); // コンストラクタで引数を受け取る

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text, // 渡されたtextを表示
                style: TextStyle(fontSize: 24),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.more_vert),
          ],
        ),
      ),
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.orange, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.all(16.0),
    );
  }
}