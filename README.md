# trello_zatsu_post

A CLI tool that takes a casual message, uses AI to generate a proper title and description, and posts it as a Trello card. Works with OpenAI, OpenRouter, and any OpenAI-compatible API.

## Setup

```bash
bundle install
cp .env.example .env
# Edit .env with your API keys
```

## Usage

```bash
bundle exec ruby bin/trello_zatsu_post "Fix the login page design"
```

### Run from anywhere

Add the `bin/` directory to your PATH:

```bash
cd trello_zatsu_post
echo "export PATH=\"$PWD/bin:\$PATH\"" >> ~/.zshrc
source ~/.zshrc
```

Then you can run it from any directory:

```bash
trello_zatsu_post "Fix the login page design"
```

## License

MIT
