FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Codespace環境でPostgreSQLデータベースにアクセスするためのクライアントツール
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client
