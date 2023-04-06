FROM elixir:latest

RUN apt update && apt install -y cmake libblas-dev liblapack-dev wget postgresql-client

RUN wget https://github.com/bazelbuild/bazelisk/releases/download/v1.16.0/bazelisk-linux-amd64 && \
    mv bazelisk-linux-amd64 /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel

RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Phoenix packages
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new 1.7.2


WORKDIR /app

RUN mix deps.get

CMD ["/app/entrypoint.sh"]
