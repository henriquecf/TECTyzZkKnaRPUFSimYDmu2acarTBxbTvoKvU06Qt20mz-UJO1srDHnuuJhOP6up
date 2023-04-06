# Askmybook

First we need to install dependencies:

  * Install elixir: https://elixir-lang.org/install.html
  * Install and run Postgres on default port 5432
  * Install dependencies to run ML models:
    * On ubuntu: `sudo apt install build-essential cmake libblas-dev liblapack-dev`
    * On mac: `brew install llvm cmake` and `export USE_LLVM_BREW=true`

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * On the first setup, also run `mix ecto.setup`
  * Add env variable for OpenAI: `export OPENAI_API_KEY=sk-rMAzgGXLelykdsadjaslfska`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
