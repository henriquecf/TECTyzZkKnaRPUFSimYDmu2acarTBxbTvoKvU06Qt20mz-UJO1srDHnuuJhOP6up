# Askmybook

This code was written with the following requirements in mind:

- Read a PDF for a book and extract pages (or sentences)
- Get embeddings from pages of a book
- Get a question related to that book
- Get a embedding from that book
- Compare embeddings with the question and get the most relevant sections based on similarity
- Construct a prompt to GPT with the following struct:
  - AUTHOR_NAME is the author of BOOK_NAME.
  - Answer the following question: QUESTION
  - Given the following passages from BOOK_NAME as context
  - MOST_RELEVANT_PAGES (all all pages by order of relevance)

Given that, we chose Elixir because it has the capabilities of getting models from HuggingFace and using them from within. This allows us to do the Semantic Search part of the requirements.

And Elixir also has great capabilities of substitution for both Rails and React, using Phoenix and Phoenix LiveView. So we have a SPA like behaviour with great testing and functionality in a single language.

On Macbook with M1 chip:

  * Run `brew install elixir`
  * Install deps for ML models `brew install cmake llvm` -> follow instructions for post installation (given when installation finishes)
  * Make sure Postgres is installed and running
  * Set postgres username / password are postgres / postgres. If yours is different change `config/dev.exs` file
  * Run `mix deps.get`
  * Run `mix ecto.setup`
  * Run `OPENAI_API_KEY="YOUR_KEY" mix phx.server`
  * Visit [`localhost:4000`](http://localhost:4000) from your browser

First we need to install dependencies:

  * Make sure you have docker and docker-compose installed and running

To start your Phoenix server:

  * Open `docker-compose.yaml` and change `OPENAI_API_KEY` to a valid value
  * Run `docker-compose up`

Should take some minutes. Once you see something like this:

![docker-compose up finished](https://user-images.githubusercontent.com/3901045/230472596-03c34957-685f-4cf2-a1d4-c7c8518f090a.png)

You can visit [`localhost:4000`](http://localhost:4000) from your browser.
