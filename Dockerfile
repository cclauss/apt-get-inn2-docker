# TODO: Multistage build
FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive
# RUN mkdir -p /etc/news/
# COPY etc/inn.conf /etc/news/
# COPY etc/inn.conf /etc/

# ENV PERL_MM_USE_DEFAULT=1
# RUN cpan -T GD MIME::Parser

# RUN echo "localhost.localdomain" > /etc/hostname
# sudo mv hostname /etc/
# cat /etc/hostname

RUN usermod -d /usr/local/news news
RUN usermod -d /usr/local/news/etc/news news

WORKDIR /usr/local/news
COPY --chown=news:news etc/* etc/
COPY --chown=news:news etc/* etc/news/
COPY --chown=news:news etc/inn.conf .
COPY --chown=news:news db/* db/
COPY --chown=news:news lib/* lib/

RUN apt-get update -qq && \
  apt-get install --yes tini && \
  apt-get -o Dpkg::Options::=--force-confold install --yes inn2

#  mkdir -p /usr/local/news/etc/news && \
#  cp /usr/local/news/etc/inn.conf /usr/local/news/etc/news/ && \
#  ls -laR /usr/local/news/etc && \
#  apt-get -o Dpkg::Options::=--force-confold install -y inn2

RUN sed -i 's/#\(tlscapath:\)/\1/' etc/inn.conf && \
    sed -i 's/#\(tlscertfile:\)/\1/' etc/inn.conf && \
    sed -i 's/#\(tlskeyfile:\)/\1/' etc/inn.conf

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["-f"]

ENV PATH=/usr/local/news/bin:$PATH
VOLUME /usr/local/news/db
USER news
EXPOSE 119
EXPOSE 563
