SHELL := /bin/bash

install:
	# 必要パッケージのインストール
	sudo apt update && sudo apt install -y \
	  curl git make fish ca-certificates gnupg lsb-release

	# Docker GPGキーとリポジトリ追加
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	  $$(. /etc/os-release && echo $$VERSION_CODENAME) stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	# Dockerとcomposeのインストール
	sudo apt update && sudo apt install -y \
	  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	# Dockerグループにユーザーを追加（冪等）
	@if groups $(USER) | grep -qw docker; then \
	  echo "✅ $(USER) はすでに docker グループに入っています"; \
	else \
	  echo "➕ $(USER) を docker グループに追加します"; \
	  sudo usermod -aG docker $(USER); \
	  echo "👉 この変更はログアウト後に有効になります"; \
	fi

	# miseのインストール
	[ -f "$$HOME/.local/bin/mise" ] || curl https://mise.run | bash

	# fish設定（miseのactivate）
	mkdir -p $$HOME/.config/fish
	fish -c 'type mise >/dev/null 2>&1' || \
	echo '$$HOME/.local/bin/mise activate fish | source' >> $$HOME/.config/fish/config.fish

	# Node.js（npm込み）をmise経由でインストール
	$$HOME/.local/bin/mise install node
	$$HOME/.local/bin/mise use -g node


check:
	# 各ツールの存在とバージョンを確認
	fish -c 'which mise && mise --version'
	fish -c 'which node && node -v'
	fish -c 'which npm && npm -v'
	fish -c 'which docker && sudo docker -v && sudo docker compose version'

test:
	# Docker を使ってプロジェクトをテスト実行（ビルド & 実行）
	sudo docker build --no-cache -t wsl-dev-test .
	sudo docker run --rm wsl-dev-test