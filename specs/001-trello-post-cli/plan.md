# Implementation Plan: Trello雑投稿CLIツール

**Branch**: `001-trello-post-cli` | **Date**: 2026-04-06 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-trello-post-cli/spec.md`

## Summary

ざっくりとしたメッセージをCLIから入力すると、OpenAI APIでタイトル・本文を自動生成し、Trelloの指定リストにカードとして投稿するRubyスクリプト。ruby-openai、ruby-trello、dotenvを使用。

## Technical Context

**Language/Version**: Ruby 4.0.1  
**Primary Dependencies**: ruby-openai 8.3.0, ruby-trello 4.2.0, dotenv  
**Storage**: N/A（ステートレス）  
**Testing**: minitest（Gemfile.lockに含まれる）  
**Target Platform**: macOS (darwin arm64)  
**Project Type**: CLI  
**Performance Goals**: 30秒以内にカード作成完了  
**Constraints**: OpenAI API / Trello APIのレート制限に依存  
**Scale/Scope**: 単一ユーザー、1回の実行で1枚のカード作成

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Constitutionはテンプレートのまま（プロジェクト固有の制約未定義）のため、ゲート違反なし。

**Pre-Phase 0 Check**: PASS  
**Post-Phase 1 Check**: PASS

## Project Structure

### Documentation (this feature)

```text
specs/001-trello-post-cli/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── cli.md           # CLI contract
└── checklists/
    └── requirements.md  # Spec quality checklist
```

### Source Code (repository root)

```text
bin/
└── trello_post          # CLIエントリーポイント

lib/
├── trello_zatsu_post.rb         # メインモジュール（ロード）
├── trello_zatsu_post/
│   ├── cli.rb                   # CLI引数パース・バリデーション
│   ├── ai_generator.rb          # OpenAI APIでタイトル・本文生成
│   └── trello_client.rb         # Trello APIでカード作成

.env.example                     # 環境変数テンプレート
```

**Structure Decision**: CLIツールとしてbin/にエントリーポイント、lib/にロジックを分割するRuby標準構成を採用。単一責任の原則に従い、CLI処理・AI生成・Trello投稿を分離する。
