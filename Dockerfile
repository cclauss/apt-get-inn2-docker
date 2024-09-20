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
    zlib-dev

ENV PERL_MM_USE_DEFAULT=1
RUN cpan -T GD MIME::Parser

ENV VERSION=2.7.2
RUN curl -sL https://github.com/InterNetNews/inn/releases/download/${VERSION}/inn-${VERSION}.tar.gz | tar xz

RUN usermod -d /usr/local/news news

WORKDIR /inn-${VERSION}
RUN ./configure --with-zlib
RUN make
RUN sed -i 's/#domain:/domain: news.localhost/' site/inn.conf && \
    make install

WORKDIR /usr/local/news
COPY etc/* etc/

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["-f"]

VOLUME /usr/local/news/db
USER news
EXPOSE 119
