# TODO: Multistage build
FROM alpine

RUN apk add --no-cache \
    tini \
    shadow \
    curl \
    tar \ 
    build-base \
    bison \
    perl \
    perl-dev \
    perl-utils \
    libgd \
    gd-dev \
    zlib-dev \
    openssl-dev \
    openssl

ENV PERL_MM_USE_DEFAULT=1
RUN cpan -T GD MIME::Parser

ARG VERSION=2.7.2
RUN curl -sL https://github.com/InterNetNews/inn/releases/download/${VERSION}/inn-${VERSION}.tar.gz | tar xz

RUN usermod -d /usr/local/news news

WORKDIR /inn-${VERSION}
RUN ./configure --with-zlib --with-openssl && \
    make && \
    sed -i 's/#domain:/domain: news.localhost/' site/inn.conf && \
    make install

WORKDIR /usr/local/news
COPY --chown=news:news etc/* etc/
COPY --chown=news:news db/* db/

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
