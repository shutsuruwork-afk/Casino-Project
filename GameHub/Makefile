.PHONY: dev-core dev-lobby dev-sub

# Windowsの場合は、Powershell等で直接以下のコマンドを叩くことを推奨します。
# Mac/Linux用のショートカットコマンドです。

dev-core:
	@echo "Starting Rust Core Server..."
	cd core-server && cargo run

dev-lobby:
	@echo "Starting Next.js Lobby UI..."
	cd lobby-ui && pnpm run dev

dev-sub:
	@echo "Starting Go Subsystem..."
	cd subsystem && go run main.go
