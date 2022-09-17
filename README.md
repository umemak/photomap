# photomap

## Local debug

```powershell
$port = 3000
$fwRuleName = "WSL 2 Firewall Unlock"
$wsl2Address = wsl -e hostname -I | ForEach-Object { $_.trim() }

New-NetFireWallRule -DisplayName $fwRuleName -Direction Inbound -LocalPort $port -Action Allow -Protocol TCP
netsh interface portproxy add v4tov4 listenport=$port listenaddress=* connectport=$port connectaddress=$wsl2Address
```

```sh
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 3000 --web-renderer html
```

```sh
cd functions
npm run serve
```

## ToDo

- [x] 画像アップロード処理
  - [x] 正方形トリミング
  - [x] サムネイル作成
- [x] 投稿リスト表示
- [ ] いいね
- [ ] 地図ごとのユーザー管理
- [x] ログアウトメニュー
- [ ] 投稿詳細画面
- [ ] 投稿編集
- [ ] 投稿削除
- [ ] 地図削除
- [ ] 戻る遷移
- [ ] ユーザー名登録
