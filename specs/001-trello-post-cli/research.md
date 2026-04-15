# Research: Trello雑投稿CLIツール

**Date**: 2026-04-06  
**Feature**: 001-trello-post-cli

## R-001: ruby-openai gemでのタイトル・本文生成

**Decision**: OpenAI Chat Completions APIを使用し、1回のリクエストでJSON形式（titleとdescription）を返させる

**Rationale**: 
- ruby-openai gemは`client.chat`メソッドでChat Completions APIを呼び出せる
- `response_format: { type: "json_object" }`を指定することで構造化された出力を得られる
- 1回のAPI呼び出しでタイトルと本文を同時に生成できるため効率的

**Alternatives considered**:
- 2回のAPI呼び出し（タイトル用・本文用）→ 遅く、コストが2倍
- Completions API（レガシー）→ 非推奨

## R-002: ruby-trello gemでのカード作成

**Decision**: `Trello::Card.create`メソッドでカードを作成する

**Rationale**:
- ruby-trello gemは`Trello.configure`でグローバル設定後、`Trello::Card.create(name:, desc:, list_id:)`でカードを作成できる
- 認証にはdeveloper_public_key（APIキー）とmember_token（トークン）が必要

**Alternatives considered**:
- Trello REST APIを直接叩く → gemの抽象化を活かせない
- HTTPクライアントで直接API呼び出し → 認証処理の実装が必要

## R-003: 環境変数の設計

**Decision**: dotenv gemで`.env`ファイルから読み込み、以下の環境変数を使用する

| 環境変数 | 用途 |
|----------|------|
| `OPENAI_ACCESS_TOKEN` | OpenAI APIキー |
| `TRELLO_DEVELOPER_PUBLIC_KEY` | Trello APIキー |
| `TRELLO_MEMBER_TOKEN` | Trelloメンバートークン |
| `TRELLO_LIST_ID` | 投稿先のリストID |

**Rationale**:
- ruby-openai gemは`OPENAI_ACCESS_TOKEN`環境変数をデフォルトで参照する
- ruby-trello gemの設定に`developer_public_key`と`member_token`が必要
- リストIDがあればカード作成に十分（ボードIDは不要）

**Alternatives considered**:
- YAMLコンフィグファイル → シンプルなCLIツールには過剰
- コマンドライン引数で認証情報を渡す → セキュリティリスク

## R-004: プロジェクト構造

**Decision**: 単一のRubyスクリプト（`bin/trello_post`）＋ライブラリ分割（`lib/`配下）

**Rationale**:
- CLIツールとして`bin/`配下に実行ファイルを置くのがRubyの慣例
- ロジックを`lib/`に分割することでテスタビリティを確保
- Bundlerの`bundle exec`で実行可能

**Alternatives considered**:
- 単一ファイル → テストしにくく、責務の分離ができない
- gem化 → 配布の必要がないため過剰
