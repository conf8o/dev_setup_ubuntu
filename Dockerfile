FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Makefileが依存する最小限のパッケージだけ入れる
RUN apt-get update && apt-get install -y \
  make \
  curl \
  git \
  sudo

WORKDIR /app

COPY . .

# install + check の両方を実行
CMD ["bash", "-c", "make install && make check"]
