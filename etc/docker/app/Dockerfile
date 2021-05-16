FROM php:7.4.16-fpm

ARG APP_ENV
ARG SITE
ARG WORDPRESS_VERSION
ARG WOOCOMMERCE_VERSION
ARG PAYDESIGN_VERSION
ARG DB_HOST
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD
ARG DB_PORT

ENV APP_ENV=$APP_ENV
ENV SITE=$SITE
ENV WORDPRESS_VERSION=$WORDPRESS_VERSION
ENV WOOCOMMERCE_VERSION=$WOOCOMMERCE_VERSION
ENV PAYDESIGN_VERSION=$PAYDESIGN_VERSION
ENV DB_HOST=$DB_HOST
ENV DB_NAME=$DB_NAME
ENV DB_USER=$DB_USER
ENV DB_PASSWORD=$DB_PASSWORD
ENV DB_PORT=$DB_PORT

ENV ENTRYKIT_VERSION 0.4.0
ENV DOCKERIZE_VERSION v0.6.1

RUN echo $DB_HOST

RUN apt-get update -y && \
    apt-get install -y libzip-dev zip libpq-dev libpcre3-dev zlib1g-dev libpng-dev libmcrypt-dev curl libcurl4-openssl-dev vim libjpeg-dev libfreetype6-dev libxml2-dev libonig-dev \
  && docker-php-source extract \
  && docker-php-ext-configure zip --with-zip \
  && docker-php-ext-configure gd --with-freetype=/usr/include --with-jpeg=/usr/include \
  && docker-php-ext-install zip pdo pdo_mysql mysqli mbstring gd curl

# Install entrykit
RUN curl -OL https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && mv entrykit /bin/entrykit \
    && chmod +x /bin/entrykit \
    && entrykit --symlink

# Install dockerize
RUN curl -OL https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && rm dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Set composer environment
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV PATH $PATH:/composer/vendor/bin:/var/www/html/vendor/bin

COPY . /var/www/html
COPY ./etc/docker/common/.vimrc /root/.vimrc
COPY ./etc/docker/common/.bashrc /root/.bashrc

COPY ./etc/docker/app/docker-entrypoint.sh /bin/docker-entrypoint.sh
COPY ./etc/docker/app/php-fpm.d/docker.conf /usr/local/etc/php-fpm.d/zzz-docker.conf
COPY ./etc/docker/app/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/zzz-www.conf
COPY ./etc/docker/app/php.ini /usr/local/etc/php/php.ini
COPY ./etc/docker/bin/wait_db_connect.sh /usr/local/bin/wait_db_connect.sh
COPY ./etc/docker/app/bin /usr/local/bin

RUN composer self-update

RUN if [ "$APP_ENV" != 'local' ]; then \
      /usr/local/bin/wordpress_install.sh; \
      composer install --no-dev; \
      /usr/local/bin/setup_bedrock.sh; \
      /usr/local/bin/plugin_install.sh; \
      /usr/local/bin/theme_install.sh; \
      /usr/local/bin/file_install.sh; \
  fi

VOLUME /var/www/html

CMD ["/bin/docker-entrypoint.sh"]

