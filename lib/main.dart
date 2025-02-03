import 'dart:async';
import 'package:flutter/foundation.dart'; // kIsWeb を使うために必要
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'toppage.dart';
import 'alarm_test.dart';

// 明示的にWeb用のパッケージを読み込ませる
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:shared_preferences_web/shared_preferences_web.dart';

// import 'package:flutter/widgets.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';

final userProvider = StateProvider<User?>((ref) => null);

// ユーザ情報を端末に保存
// Future<void> loadUserFromPreferences(WidgetRef ref) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? uid = prefs.getString('uid');
//   if (uid != null) {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null && user.uid == uid) {
//       ref.read(userProvider.notifier).state = user;
//     }
//   }
// }

Future<void> loadUserFromPreferences(Function(ProviderListenable) read) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? uid = prefs.getString('uid');
  if (uid != null) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.uid == uid) {
      read(userProvider.notifier).state = user;
    }
  }
}

void main() async {
  // Web向けにプラグインを登録
  // SharedPreferencesPlugin.registerWith(Registrar());
  // if (kIsWeb) {
  //   // Web環境の場合のみプラグインを登録
  //   SharedPreferencesPlugin.registerWith(Registrar());
  // }
  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create a ProviderContainer to use the ref
  final container = ProviderContainer();
  await loadUserFromPreferences(container.read);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(),
    ),
  );
}

// void main() async {
//   // Web向けにプラグインを登録
//   SharedPreferencesPlugin.registerWith(Registrar());
//   //
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(ProviderScope(child: MyApp()));
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gojo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // textTheme: GoogleFonts.notoSansJpTextTheme(),
        textTheme: GoogleFonts.bizUDPGothicTextTheme(
          Theme.of(context).textTheme,
        ),
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
      _checkLoginState();
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => MyLogin()),
      // );
    });
  }

  // ログイン状態を確認して，ログインしていればトップページに遷移
  Future<void> _checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyLogin()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TopPage()),
          );
        }
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyLogin()),
      );
    }
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
                  // ログインボタン
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final User? user = (await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                          email: _email,
                          password: _password,
                        ))
                            .user;
                        //
                        if (user != null) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('isLoggedIn', true);
                          await prefs.setString('uid', user.uid);
                          ref.read(userProvider.notifier).state = user;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => TopPage()),
                          );
                        }
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff82d3e3),
                    ),
                    child: const Text('ログイン',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ),
                ),
                SizedBox(height: 32),
                // ユーザ登録ボタン
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
      backgroundColor: Color(0xff82d3e3),
      // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      toolbarHeight: 100.0,
      title: Center(
        child: Column(
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
                  color: Color(0xff7a4800),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.0);
}