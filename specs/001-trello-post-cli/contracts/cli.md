# CLI Contract: trello_post

## コマンド

```
bundle exec ruby bin/trello_post <message>
```

## 引数

| 引数 | 必須 | 説明 |
|------|------|------|
| `message` | はい | Trelloカードの元になるメッセージ（文字列） |

## 環境変数

| 変数名 | 必須 | 説明 |
|--------|------|------|
| `OPENAI_ACCESS_TOKEN` | はい | OpenAI APIキー |
| `TRELLO_DEVELOPER_PUBLIC_KEY` | はい | Trello APIキー |
| `TRELLO_MEMBER_TOKEN` | はい | Trelloメンバートークン |
| `TRELLO_LIST_ID` | はい | 投稿先リストID |

## 出力

### 成功時 (exit code: 0)

stdout:
```
カードを作成しました: https://trello.com/c/xxxxxxxx
```

### エラー時 (exit code: 1)

stderr:
```
エラー: メッセージを入力してください
Usage: bundle exec ruby bin/trello_post <message>
```

```
エラー: 環境変数 TRELLO_LIST_ID が設定されていません
```

```
エラー: OpenAI APIとの通信に失敗しました: <詳細>
```

```
エラー: Trello APIとの通信に失敗しました: <詳細>
```
