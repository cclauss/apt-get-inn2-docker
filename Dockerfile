# TODO: Multistage build
FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN usermod -d /etc/news news
COPY --chown=news:news etc/* etc/news/
COPY --chown=news:news db/* db/

RUN apt-get update -qq && \
  apt-get install --yes tini && \
  apt-get -o Dpkg::Options::=--force-confold install -y inn2 && \
  sed -i 's/#\(tlscapath:\)/\1/' etc/news/inn.conf && \
  sed -i 's/#\(tlscertfile:\)/\1/' etc/news/inn.conf && \
  sed -i 's/#\(tlskeyfile:\)/\1/' etc/news/inn.conf && \
  mkdir -p /var/run/news && \
  touch /var/run/news/nnrpd-563.pid && \
  chown news:news /var/run/news/nnrpd-563.pid && \
  mkdir -p /run/news && \
  chown news:news /run/news

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["-f"]

ENV PATH=/usr/lib/news/bin:$PATH
VOLUME /var/lib/news/db
USER news
EXPOSE 119
EXPOSE 563
