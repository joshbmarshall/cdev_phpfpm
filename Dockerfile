FROM joshbmarshall/phpnode

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version \
    && mkdir /t \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /t \
    && mv /t/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -fr /t

RUN mkdir -p /var/www/cms && \
# Default git user
    su php -c 'git config --global user.email "dev@jm1.me"' && \
    su php -c 'git config --global user.name "Development Environment"' && \
    chown -R php.php /home/php && \
    mkdir /tmpdir && \
    chmod 777 /tmpdir

# Install ffmpeg
RUN apk add --update ffmpeg && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

# Install ssmtp to send email to mailhog
RUN apk add --update ssmtp && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

# Upgrade ca certificates
RUN /usr/sbin/update-ca-certificates

COPY ssmtp.conf /etc/ssmtp/ssmtp.conf
