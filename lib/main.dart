import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'dart:async';
// import 'firebase.dart';
// import 'mylogin.dart';
import 'toppage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseOptions for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // 最初にスプラッシュ画面を表示
    );
  }
}

// スプラッシュ画面
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
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

//--------------------------
class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  // This widget is the root of your application.
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// Authentication
  String _email = '';
  String _password = '';

  //-------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
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
                decoration: const InputDecoration(
                  labelText: 'パスワード（6文字以上）',
                ),
              ),
              SizedBox(height: 32),
              // ユーザ登録ボタン
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              // Text('ユーザ登録成功:  ${user?.email}, ${user?.uid}'),
                              Text('ユーザ登録成功:  ${user?.email}',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 24,
                                  )),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // content: Text('ユーザ登録失敗: ${e.message}'),
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

              // ログインボタン
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // content: Text('ログイン成功: ${user?.email}, ${user?.uid}'),
                          content: Text(
                            'ログイン成功: ${user?.email}',
                            style: TextStyle(color: Colors.green, fontSize: 24),
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
                          // content: Text('ログイン失敗: ${e.message}'),
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
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}