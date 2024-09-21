import 'package:flutter/material.dart';
import 'helpCard/helpcard_top.dart';
import 'fixed_supports/support1.dart';
import 'tasklist/tasklist_top.dart';
import 'toppage.dart';

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
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TopPage()),
                    );
                  },
                  child: Image.asset('assets/images/GOJO.png', height: 50),
                ),
                // Image.asset('assets/images/GOJO.png', height: 50),
              ],
            ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text(
                    '今日の予定',
                    style: TextStyle(
                      color: Colors.orange, // 文字色を指定
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'ご協力依頼',
                    style: TextStyle(
                      color: Colors.orange, // 文字色を指定
                      fontSize: 20, // フォントの大きさを指定
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          color: Colors.black,
                        ),
                      ], // フォントの大きさを指定
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body-----------------------------
          body: TabBarView(
            children: <Widget>[
              // 今日の予定Tab
              TaskListPage(displayButton: true),
              // ご協力依頼Tab
              HelpCardListPage(),
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