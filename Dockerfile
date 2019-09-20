FROM joshbmarshall/phpnode7

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
 && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version \
 && mkdir /t \
 && tar zxpf /tmp/blackfire-probe.tar.gz -C /t \
 && mv /t/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
 && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
 && rm -fr /t \
 && mkdir -p /var/www/cms \
# Default git user
 && su php -c 'git config --global user.email "dev@jm1.me"' \
 && su php -c 'git config --global user.name "Development Environment"' \
 && chown -R php.php /home/php \
 && mkdir /tmpdir \
 && chmod 777 /tmpdir \
# Install ffmpeg
 && apk add --update ffmpeg \
# Install ssmtp to send email to mailhog
 && apk add --update ssmtp \
# Install php-ast
 && apk add --update autoconf build-base \
 && pecl install ast \
 && printf "extension=ast.so\n" > $PHP_INI_DIR/conf.d/ast.ini \
 && apk del autoconf build-base \
 && rm -rf /tmp/* \
 && rm -rf /var/cache/apk/*
# Install some composer helpers
RUN su php -c "/usr/local/bin/composer global require hirak/prestissimo" \
 && su php -c "/usr/local/bin/composer global require phan/phan" \
 && su php -c "/usr/local/bin/composer global require overtrue/phplint" \
# Install Image optimisers
 && apk add --update jpegoptim optipng pngquant gifsicle \
# Install Typescript
 && npm install -g typescript \
# Install JS Linter
 && npm install -g eslint \
# Install Ghostscript for PDF
 && apk add ghostscript \
 && rm -rf /tmp/* \
 && rm -rf /var/cache/apk/*

COPY ssmtp.conf /etc/ssmtp/ssmtp.conf
