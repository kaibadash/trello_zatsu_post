# Tasks: Trello雑投稿CLIツール

**Input**: Design documents from `/specs/001-trello-post-cli/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: テストは明示的に要求されていないため、テストタスクは含みません。

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: プロジェクト初期化と基本構成

- [x] T001 Create project directory structure: `bin/`, `lib/trello_zatsu_post/`
- [x] T002 [P] Create `.env.example` with required environment variables (OPENAI_ACCESS_TOKEN, TRELLO_DEVELOPER_PUBLIC_KEY, TRELLO_MEMBER_TOKEN, TRELLO_LIST_ID)
- [x] T003 [P] Create main module loader in `lib/trello_zatsu_post.rb` (require dotenv, require sub-modules)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: 全ユーザーストーリーに必要な基盤コンポーネント

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Implement CLI argument parsing and validation in `lib/trello_zatsu_post/cli.rb` — parse ARGV for message, validate non-empty, output usage on error to stderr with exit code 1
- [x] T005 Implement environment variable validation in `lib/trello_zatsu_post/cli.rb` — check all 4 required env vars are present, output specific missing var name to stderr with exit code 1

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - ざっくりメッセージからTrelloカードを作成する (Priority: P1) 🎯 MVP

**Goal**: CLIからメッセージを入力すると、AIがタイトル・本文を生成し、Trelloカードが作成される

**Independent Test**: `bundle exec ruby bin/trello_post "ログイン画面のデザイン修正したい"` を実行し、Trelloボード上にカードが作成されることを確認

### Implementation for User Story 1

- [x] T006 [P] [US1] Implement AI title/description generator in `lib/trello_zatsu_post/ai_generator.rb` — initialize OpenAI client, send chat completion request with system prompt instructing JSON output ({title, description}), parse response
- [x] T007 [P] [US1] Implement Trello card creator in `lib/trello_zatsu_post/trello_client.rb` — configure Trello with env vars, create card with name/desc/list_id, return card URL
- [x] T008 [US1] Create CLI entry point in `bin/trello_post` — require lib, load dotenv, run CLI validation, call ai_generator, call trello_client, print card URL to stdout
- [x] T009 [US1] End-to-end manual verification: run `bundle exec ruby bin/trello_post "テストメッセージ"` and confirm card appears on Trello board with AI-generated title and description

**Checkpoint**: User Story 1 should be fully functional - single command creates a Trello card with AI-generated content

---

## Phase 4: User Story 2 - エラー時にわかりやすいフィードバックを受ける (Priority: P2)

**Goal**: 環境変数未設定やAPI通信エラー時にわかりやすいエラーメッセージが表示される

**Independent Test**: 環境変数を未設定にして実行し、適切なエラーメッセージが表示されることを確認

### Implementation for User Story 2

- [x] T010 [US2] Add OpenAI API error handling in `lib/trello_zatsu_post/ai_generator.rb` — rescue Faraday errors and OpenAI-specific errors, output "エラー: OpenAI APIとの通信に失敗しました: <詳細>" to stderr
- [x] T011 [US2] Add Trello API error handling in `lib/trello_zatsu_post/trello_client.rb` — rescue Trello/Faraday errors, output "エラー: Trello APIとの通信に失敗しました: <詳細>" to stderr
- [x] T012 [US2] Wire error handling in `bin/trello_post` — ensure all errors are caught at top level, exit with code 1 on any failure
- [x] T013 [US2] Manual verification of all error paths: test with missing env vars, invalid API key, empty message

**Checkpoint**: All error scenarios produce clear, actionable error messages

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: 最終調整

- [x] T014 Add `.gitignore` entry for `.env` file
- [x] T015 Run quickstart.md validation — follow quickstart steps from scratch to verify setup works

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational phase completion
- **User Story 2 (Phase 4)**: Depends on User Story 1 completion (adds error handling to existing code)
- **Polish (Phase 5)**: Depends on all user stories being complete

### Within Each User Story

- Models/services before CLI entry point
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- T002, T003 can run in parallel (Setup phase)
- T006, T007 can run in parallel (different files, no dependencies)
- T010, T011 can run in parallel (different files)

---

## Parallel Example: User Story 1

```bash
# Launch AI generator and Trello client in parallel:
Task: "Implement AI generator in lib/trello_zatsu_post/ai_generator.rb"
Task: "Implement Trello client in lib/trello_zatsu_post/trello_client.rb"

# Then wire them together:
Task: "Create CLI entry point in bin/trello_post"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CLI validation)
3. Complete Phase 3: User Story 1 (AI生成 + Trello投稿)
4. **STOP and VALIDATE**: Test with real message → Trello card created
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test → MVP complete!
3. Add User Story 2 → Test → Error handling added
4. Polish → Final validation

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
