FROM msaraiva/elixir-dev:1.3.4
RUN apk --update add erlang-xmerl && \
    rm -rf /var/cache/apk/*

WORKDIR /app

RUN apk update
#RUN apk add openssh build-base erlang-dev
RUN apk add openssh gcc "g++" libc-dev make erlang-dev

#COPY jenkins-docker /
#COPY jenkins-docker.pub /
#RUN mkdir /root/.ssh
#COPY known_hosts_github /root/.ssh/known_hosts

ENV MIX_ENV=prod

COPY mix.exs /app/mix.exs

#RUN chmod 600 /jenkins-docker \
#    && eval "$(ssh-agent -s)" \
#    && ssh-add /jenkins-docker \
#    && mix deps.get
RUN mix deps.get
RUN mix deps.compile

COPY config /app/config/
COPY lib /app/lib/
COPY web /app/web/
COPY priv /app/priv/

RUN mix compile
RUN mix phoenix.digest

#ARG GITHASH
#ARG CLOUDFRONT_ADD
#ENV GITHASH=${GITHASH}
#ENV CLOUDFRONT_ADD=${CLOUDFRONT_ADD}

ENV PORT=8080

ENTRYPOINT elixir --no-halt --name "b10g@`hostname -i`" --cookie "MONSTER" -S mix phoenix.server