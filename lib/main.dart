import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'toppage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'alarm_test.dart';

final userProvider = StateProvider<User?>((ref) => null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: AlarmPage.navigatorKey, // navigatorKey を設定
      home: SplashScreen(), // 最初にスプラッシュ画面を表示
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // アラームの設定を初期化時に実行
    AlarmPage().fetchAndSetAlarm(context);
    // 2秒後にログイン画面に遷移する
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyLogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                '今やりたいことを叶える\n助け合いアプリ',
                style: TextStyle(fontSize: 32, color: Colors.orange),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            Image.asset('assets/images/GOJO.png'),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// ログイン画面
class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gojo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gojo ログイン'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  String _email = '';
  String _password = '';
  bool _isObscure = true; // Add a boolean to manage the visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/GOJO.png'),
                SizedBox(height: 32),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'パスワード（6文字以上）',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure
                            ? Icons.visibility
                            : Icons.visibility_off, // Change icon
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure =
                              !_isObscure; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                  obscureText:
                      _isObscure, // Use the boolean to manage obscure text
                ),
                // TextField(
                //   onChanged: (value) {
                //     setState(() {
                //       _password = value;
                //     });
                //   },
                //   decoration: const InputDecoration(
                //     labelText: 'パスワード（6文字以上）',
                //   ),
                // ),
                SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final User? user = (await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                          email: _email,
                          password: _password,
                        ))
                            .user;
                        ref.read(userProvider.notifier).state = user;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ユーザ登録成功:  ${user?.email}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 24,
                                )),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'ユーザ登録失敗: ${e.message}',
                              style: TextStyle(color: Colors.red, fontSize: 32),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('ユーザ登録（新規作成）',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final User? user = (await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                          email: _email,
                          password: _password,
                        ))
                            .user;
                        ref.read(userProvider.notifier).state = user;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'ログイン成功: ${user?.email}',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 24),
                            ),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TopPage()),
                        );
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'ログイン失敗（ユーザ登録しましたか？）',
                              style: TextStyle(color: Colors.red, fontSize: 32),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('ログイン',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// カスタムWidget作成
// AppBarのタイトルを変更するためのカスタムWidget
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  MyAppBar({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      toolbarHeight: 100.0,
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
          Text(
            text,
            style: TextStyle(
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.0);
}