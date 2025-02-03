# gojo202409

## 概要

東京女子大学コミュニケーション専攻の2024年度卒論「『互助』を促すアプリケーションの有効性ー互助に対する意識と⾏動の把握と地域で気軽に助け合いを⾏うサービスー」で使用する実証実験用アプリです．
互助をキーワードに地域の認知症当事者と支援者をつなぐことを目指しています．認知症当事者の予定を管理する機能と地域の支援者にヘルプを求めることができる「ヘルプカード」の機能を持っています．

このプロジェクトは Flutter  を用いて開発されたモバイルアプリケーション（iOS, Android, PWA）で，Firebase をバックエンドとして利用しています．

## ライセンス

本プロジェクトは MIT License のもとで公開されています．詳細は [LICENSE](LICENSE) ファイルをご参照ください．

## 使用技術

- **Flutter**: クロスプラットフォームのモバイルアプリ開発フレームワーク
- **Dart**: Flutter のプログラミング言語
- **Firebase**:
    - Authentication (ユーザー認証)
    - Cloud Firestore  (データ保存)

## セットアップ方法

Firebaseの設定が必要です．Flutterと連携させてください．下記ファイルの追加が必要です．

- lib/firebase_options.dart
- ios/Runner/GoogleService-Info.plist
- android/app/google-services.json