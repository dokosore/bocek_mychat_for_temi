# bocek_mychat_for_temi

### Temi へのインストール方法

1. Temi と同じネットワークに接続
2. Temi の開発者用設定にて、ポートを開放
3. `adb connect 192.168.2.200`
4. Flutter をデバッグするには `fvm flutter run`
5. Flutter をリリースするには `fvm flutter build apk`
6. Temi にインストール `adb install build/app/outputs/flutter-apk/app-release.apk`
7. Temi Center でホームアプリに設定

### 開発参加方法

1. `fvm install` で Flutter SDK をインストール
