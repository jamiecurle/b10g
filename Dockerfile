FROM msaraiva/elixir-dev:1.3.4
RUN apk --update add erlang-xmerl && \
    rm -rf /var/cache/apk/*

WORKDIR /app

RUN apk update

RUN apk add openssh gcc "g++" libc-dev make erlang-dev

ENV MIX_ENV=prod

COPY mix.exs /app/mix.exs

RUN mix deps.get
RUN mix deps.compile

COPY config /app/config/
COPY lib /app/lib/
COPY web /app/web/
COPY priv /app/priv/

RUN mix compile
RUN mix phoenix.digest

ENV PORT=8080

#ENTRYPOINT mix ecto.migrate && mix phoenix.server
ENTRYPOINT mix ecto.migrate && elixir --no-halt --name "b10g@`hostname -i`" --cookie "MONSTER" -S mix phoenix.server