FROM elixir:latest

RUN apt update && apt install -y build-essential cmake libblas-dev liblapack-dev postgresql-client

RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Phoenix packages
RUN mix local.hex --force && \
    mix local.rebar --force

RUN mix deps.get

RUN mix deps.compile

CMD ["/app/entrypoint.sh"]
