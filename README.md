# Dev Setup

Ubuntu上に自分の開発環境を初期化するやつ（fish + mise + docker + npm）。WSLでもOK。

## 0. (Windowsの場合) WSLを入れる

PowerShell（管理者）で実行：

```powershell
wsl --install
```


※ ヘルプが表示された場合：

```powershell
wsl --list --online
wsl --install -d Ubuntu
```

## 1. 依存パッケージ

```bash
sudo apt update && sudo apt install -y make curl git
```

## 2. プロジェクトをクローン

```bash
git clone https://github.com/conf8o/dev_setup_ubuntu.git
cd dev_setup_ubuntu
```

## 3. セットアップ実行

```bash
make install
```

なるべく冪等になるようにしてるから `make install` 連打してもOK

→ 内容：
- fish インストール
- mise インストール
- fish設定ファイルに activate を追記
- docker（+ compose）インストール（v2系）


## 4. 動作確認

```bash
make check
```

## 5. Docker を sudo なしで使うための設定

`make install` を実行すると、自動的に現在のユーザーを docker グループに追加する。
これにより、sudo 無しで docker が使えるようになるが、再ログインが必要。


## 6. 必要に応じて config_files からファイルをコピペ

config_filesに、miseで使う `.tool-versions` が入っているので、これをプロジェクト内にコピペしてね

## テスト: DockerでクリーンなUbuntuに対して `make install` と `make check` をテストする

```bash
make test
```

開発環境初期化で汚れるのが不安なのでテストも用意してる。

## VSCode用の設定（fishをデフォルトにしたいとき）

settings.json に以下を追加：

```json
"terminal.integrated.defaultProfile.linux": "fish",
"terminal.integrated.profiles.linux": {
  "fish": {
    "path": "/usr/bin/fish"
  }
}
```

## プロジェクト構成

```
.
├── README.md              # このドキュメント
├── Makefile               # 環境構築・テスト用スクリプト
├── Dockerfile             # テスト用のUbuntuイメージ
└── config_files/          # 設定ファイルのテンプレート
    └── .tool-versions     # mise用のバージョン管理ファイル
```