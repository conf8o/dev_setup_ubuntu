SHELL := /bin/bash

install:
	# 必要パッケージをインストール（念のため事前にapt update）
	sudo apt update && sudo apt install -y fish ca-certificates gnupg lsb-release

	# Docker公式GPGキーを登録
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg

	# Dockerリポジトリを追加
	echo \
	  "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	  $$(. /etc/os-release && echo $$VERSION_CODENAME) stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	# DockerエンジンとComposeをインストール（統合形式）
	sudo apt update && \
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	# fish設定ディレクトリを作成
	mkdir -p ~/.config/fish

	# miseをインストール（すでにある場合はスキップ）
	[ -f "$$HOME/.local/bin/mise" ] || curl https://mise.run | bash

	# fish上でmiseが使えない場合、設定ファイルにactivateを追記（冪等）
	fish -c 'type mise >/dev/null 2>&1' || \
	echo '$$HOME/.local/bin/mise activate fish | source' >> ~/.config/fish/config.fish

check:
	# fish環境でmiseが使えるか確認
	fish -c 'which mise && mise --version'

docker:
	# このプロジェクトをDockerでテスト（冪等確認用）
	docker build -t wsl-dev-test .
	docker run --rm wsl-dev-test
