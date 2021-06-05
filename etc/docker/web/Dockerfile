FROM nginx:1.18.0

ARG APP_ENV
ARG SET_REAL_IP_FROM
ARG SERVER_NAME
ARG WEB_PORT
ENV APP_ENV=$APP_ENV
ENV SET_REAL_IP_FROM=$SET_REAL_IP_FROM
ENV SERVER_NAME=$SERVER_NAME
ENV WEB_PORT=$WEB_PORT

RUN apt-get update \
  && apt-get install -y vim curl \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*

ENV LANG C.UTF-8
WORKDIR /var/www/html

COPY ./etc/docker/common/.vimrc /root/.vimrc
COPY ./etc/docker/common/.bashrc /root/.bashrc
COPY ./etc/docker/web/nginx.conf /etc/nginx/nginx.conf
COPY ./etc/docker/web/conf.d/default.conf /etc/nginx/conf.d/

RUN if [ -n "$SERVER_NAME" ]; then \
      sed -i "s%localhost%$SERVER_NAME%" /etc/nginx/conf.d/default.conf; \
      sed -i "s%8831%$WEB_PORT%" /etc/nginx/conf.d/default.conf; \
  fi

COPY ./etc/docker/web/docker-entrypoint.sh /bin/docker-entrypoint.sh
CMD ["/bin/docker-entrypoint.sh"]
