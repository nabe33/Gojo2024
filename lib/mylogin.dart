import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'dart:async';

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
      resizeToAvoidBottomInset: true, // キーボード表示時に画面をリサイズ
      body: SafeArea(
        child: SingleChildScrollView(
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
                                style:
                                    TextStyle(color: Colors.red, fontSize: 32),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('ユーザ登録（新規作成）',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
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
                                style: TextStyle(
                                    color: Colors.green, fontSize: 24),
                              ),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              // content: Text('ログイン失敗: ${e.message}'),
                              content: Text(
                                'ログイン失敗（ユーザ登録しましたか？）',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 32),
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
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}