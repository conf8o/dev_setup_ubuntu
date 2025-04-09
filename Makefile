install:
	# 必要パッケージ
	sudo apt update && sudo apt install -y curl git fish ca-certificates gnupg make lsb-release

	# Docker公式GPGキーの登録
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg

	# Dockerリポジトリを追加
	echo \
	  "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	  $$(. /etc/os-release && echo $$VERSION_CODENAME) stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	# DockerとComposeのインストール
	sudo apt update && \
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	# fishの設定
	mkdir -p ~/.config/fish
	[ -f "$$HOME/.local/bin/mise" ] || curl https://mise.run | bash
	fish -c 'type mise >/dev/null 2>&1' || \
	echo '$$HOME/.local/bin/mise activate fish | source' >> ~/.config/fish/config.fish
