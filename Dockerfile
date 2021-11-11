FROM alpine:latest

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]

ENV NGINX_VERSION 1.21.1

RUN set -ex \
  && apk add --no-cache \
  ca-certificates \
  libressl \
  pcre \
  zlib \
  && apk add --no-cache --virtual .build-deps \
  build-base \
  linux-headers \
  libressl-dev \
  pcre-dev \
  wget \
  zlib-dev \
  && cd /tmp \
  && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar xzf nginx-${NGINX_VERSION}.tar.gz \
  && cd /tmp/nginx-${NGINX_VERSION} \
  \
  && wget https://github.com/openresty/headers-more-nginx-module/archive/refs/tags/v0.33.tar.gz \
  && tar xzf v0.33.tar.gz \
  \
  && ./configure \
  \
  --with-debug \
  \
  --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  \
  --user=nginx \
  --group=nginx \
  \
  --with-threads \
  \
  --with-file-aio \
  \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_auth_request_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_slice_module \
  --with-http_stub_status_module \
  \
  --http-log-path=/var/log/nginx/access.log \
  --http-client-body-temp-path=/var/cache/nginx/client_temp \
  --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
  --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
  --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
  \
  --with-mail \
  --with-mail_ssl_module \
  \
  --with-stream \
  --with-stream_ssl_module \
  --with-stream_realip_module \
  \
  --add-dynamic-module=headers-more-nginx-module-0.33 \
  \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  && adduser -D nginx \
  && mkdir -p /var/cache/nginx \
  && apk del .build-deps \
  && rm -rf /tmp/*
