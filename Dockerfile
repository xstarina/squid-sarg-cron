FROM ubuntu:latest

RUN set -eux; apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends squid ca-certificates tzdata supervisor sarg busybox \
 && DEBIAN_FRONTEND=noninteractive apt-get remove --purge --auto-remove -y \
 && rm -rf /var/lib/apt/lists/* \
 && rm -f /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/private/ssl-cert-snakeoil.key

RUN set -eux \
 && test -f /etc/logrotate.d/squid && sed -i -r 's/(\s)daily/\1weekly/g; s/(\srotate\s)[0-9]+/\15/; /\sdelaycompress/d;' /etc/logrotate.d/squid \
 && test -x /etc/cron.weekly/sarg && chmod -x /etc/cron.weekly/sarg

COPY docker/ /
WORKDIR /www
VOLUME /var/log/squid /var/spool/squid
EXPOSE 80 3128 3129

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
