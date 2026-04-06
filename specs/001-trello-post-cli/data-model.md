# Data Model: Trello雑投稿CLIツール

**Date**: 2026-04-06  
**Feature**: 001-trello-post-cli

## Entities

### Message (入力)

ユーザーがCLIから入力するざっくりとしたテキスト。

| 属性 | 説明 | 制約 |
|------|------|------|
| text | ユーザーの入力メッセージ | 必須、空文字不可 |

### GeneratedCard (AI生成結果)

AIが生成したカードのタイトルと本文。

| 属性 | 説明 | 制約 |
|------|------|------|
| title | カードのタイトル（簡潔な要約） | 必須 |
| description | カードの本文（詳細な説明） | 必須 |

### TrelloCard (作成結果)

Trello上に作成されたカード。

| 属性 | 説明 | 制約 |
|------|------|------|
| name | カードタイトル | GeneratedCard.titleから |
| desc | カード本文 | GeneratedCard.descriptionから |
| list_id | 投稿先リストID | 環境変数から |
| url | 作成後のカードURL | Trello APIの返却値 |

## データフロー

```
Message.text → [AI生成] → GeneratedCard(title, description) → [Trello投稿] → TrelloCard(url)
```

## 状態遷移

このツールはステートレスな単発実行のため、状態遷移は発生しない。
