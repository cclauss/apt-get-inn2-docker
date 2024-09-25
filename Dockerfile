# TODO: Multistage build
FROM debian:bookworm
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
  touch /etc/key.pem && \
  chown news:news /etc/key.pem && \
  mkdir -p /var/run/news && \
  touch /var/run/news/nnrpd-563.pid && \
  chown news:news /var/run/news/nnrpd-563.pid && \
  mkdir -p /run/news && \
  chown news:news /run/news && \
  mkdir -p /var/www/inn && \
  chown news:news /var/www/inn && \  
  echo "Startup" > /var/www/inn/inn_status.html && \
  chown news:news /var/www/inn/inn_status.html
  # cp /usr/share/doc/inn2/examples/filter/filter_innd.py /etc/news/filter
  # rm /etc/news/filter/filter_innd.py && \
  # ls -l /etc/news/filter/*.py

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["-f"]
# CMD ["bash"]

ENV PATH=/usr/lib/news/bin:$PATH
VOLUME /var/lib/news/db
USER news
EXPOSE 119
EXPOSE 563
