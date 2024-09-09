import 'package:flutter/material.dart';

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
              // 今日の予定
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
              // ご協力依頼
              Center(
                child: Text('ご協力依頼'),
              ),
            ],
          ),
        ));
  }
}