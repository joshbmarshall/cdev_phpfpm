FROM joshbmarshall/phpnode

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version \
    && mkdir /t \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /t \
    && mv /t/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -fr /t

RUN mkdir -p /var/www/cms

# Default git user

RUN su php -c 'git config --global user.email "dev@jm1.me"'
RUN su php -c 'git config --global user.name "Development Environment"'

# Install ffmpeg
RUN apk add --update ffmpeg && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

RUN chown -R php.php /home/php
RUN mkdir /tmpdir
RUN chmod 777 /tmpdir

# Install ssmtp to send email to mailhog
RUN apk add --update ssmtp && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

COPY ssmtp.conf /etc/ssmtp/ssmtp.conf
