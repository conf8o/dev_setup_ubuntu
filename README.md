# WSL Dev Setup

WSL上のUbuntuに開発環境（fish + mise + docker）を作るやつ。個人用。ChatGPTで生成したので未検証


## 0. WindowsでWSLを入れる

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

git clone https://github.com/your-username/wsl-dev-setup.git
cd wsl-dev-setup

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

## 5. DockerでクリーンなUbuntuに対して `make install` をテスト

```bash
make docker
```

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
