# Quickstart: Trello雑投稿CLIツール

## セットアップ

1. 依存関係をインストール:
   ```bash
   bundle install
   ```

2. `.env`ファイルを作成し、環境変数を設定:
   ```bash
   cp .env.example .env
   ```

3. `.env`に以下を記入:
   ```
   OPENAI_ACCESS_TOKEN=sk-xxxxx
   TRELLO_DEVELOPER_PUBLIC_KEY=your_trello_api_key
   TRELLO_MEMBER_TOKEN=your_trello_member_token
   TRELLO_LIST_ID=your_target_list_id
   ```

## 使い方

```bash
bundle exec ruby bin/trello_post "ログイン画面のデザインを修正したい"
```

## 出力例

```
カードを作成しました: https://trello.com/c/xxxxxxxx
```

## APIキーの取得方法

- **OpenAI**: https://platform.openai.com/api-keys
- **Trello APIキー**: https://trello.com/app-key
- **Trello トークン**: APIキーページからトークン生成リンクで取得
- **リストID**: Trelloボードの対象リストのURLに`.json`を追加して確認
