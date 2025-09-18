#!/bin/bash
set -e

# 🔧 強制的に本番環境を設定（Renderの独自動作を回避）
export RAILS_ENV=production
export PORT=3000
export RACK_ENV=production

# Render環境の検出と報告
if [ -n "$RENDER" ]; then
  echo "🔧 RENDER環境検出: 強制productionモード"
fi

echo "🌍 Environment: $RAILS_ENV"
echo "🚪 Port: $PORT"

# server.pid削除
rm -f /rails/tmp/pids/server.pid

# 本番環境のDBセットアップ（環境変数で確実に判定）
if [ "$RAILS_ENV" = "production" ]; then
  echo "🔄 データベース接続確認中..."
  bundle exec rails db:version 2>/dev/null || echo "データベース未初期化"
  
  echo "🗄️ データベースマイグレーション実行中..."
  bundle exec rails db:migrate
  
  echo "🌱 シードデータ投入中..."
  bundle exec rails db:seed 2>/dev/null || echo "シードデータ投入スキップ（重複エラー等）"
  
  echo "✅ データベース初期化完了！"
fi

# 🚀 強制的にproductionで起動（CMDを無視してでも確実に）
echo "🚀 Railsサーバーを強制productionモードで起動..."
exec bundle exec rails server -e production -b 0.0.0.0 -p 3000

