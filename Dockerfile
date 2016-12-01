FROM elixir:1.3.4

WORKDIR /app
ENV MIX_ENV=prod

COPY mix.exs /app/mix.exs

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

COPY config /app/config/
COPY lib /app/lib/
COPY web /app/web/
COPY priv /app/priv/

RUN mix compile
RUN mix phoenix.digest

EXPOSE 4000
ENTRYPOINT mix phoenix.server
