### Base
FROM nginx:1.21.3-alpine as base
COPY ./nginx/nginx.conf.template /etc/nginx/templates/default.conf.template

COPY ./nginx/bin/nginx-healtcheck.sh /usr/local/bin/nginx-healtcheck.sh
RUN chmod +x /usr/local/bin/nginx-healtcheck.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD ["/usr/local/bin/nginx-healtcheck.sh"]

### Stable
FROM base as stable
COPY ./../app/www/ /var/www/html/www
RUN apt-get clean -y && rm -rf /var/lib/apt/lists/*

### Development
FROM base as local
