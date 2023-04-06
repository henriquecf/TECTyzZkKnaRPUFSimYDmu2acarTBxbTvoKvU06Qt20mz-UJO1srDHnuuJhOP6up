FROM elixir:latest

# Install debian packages
RUN apt-get update && \
    apt-get install --yes build-essential gcc-9 libstdc++6 inotify-tools postgresql-client cmake libblas-dev liblapack-dev git

RUN apt install apt-transport-https curl gnupg -y && \
    curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg && \
    mv bazel-archive-keyring.gpg /usr/share/keyrings && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list

RUN apt update && apt install bazel -y

ADD . /app

# Install Phoenix packages
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new 1.7.2


WORKDIR /app

RUN mix deps.get

RUN XLA_BUILD=true mix deps.compile

EXPOSE 4000

CMD ["/app/entrypoint.sh"]
