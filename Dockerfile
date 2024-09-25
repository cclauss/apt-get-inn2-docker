# TODO: Multistage build
FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive

COPY etc/* etc/news/
COPY bin/* /usr/lib/news/bin/
COPY --chown=news:news db/* /var/lib/news/

RUN apt-get update -qq && \
  apt-get install --yes tini && \
  apt-get -o Dpkg::Options::=--force-confold install -y inn2 && \
  usermod -d /usr/lib/news news && \
  mkdir -p /run/news && \
  chown news:news /run/news


COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

ENV PATH=/usr/lib/news/bin:$PATH
VOLUME /var/lib/news
WORKDIR /usr/lib/news

EXPOSE 119
EXPOSE 563
