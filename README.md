# trello_zatsu_post

A CLI tool that takes a casual message, uses AI to generate a proper title and description, and posts it as a Trello card. Works with OpenAI, OpenRouter, and any OpenAI-compatible API.

## Setup

```bash
bundle install
cp .env.example .env
```

## Usage

```bash
bundle exec ruby bin/trello_post "Fix the login page design"
```

## Lisence

MIT
