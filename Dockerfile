FROM php:5.6-fpm-alpine

COPY php.ini /usr/local/etc/php/

# Install dependencies
RUN apk --no-cache --update add \
    libxml2-dev \
    sqlite-dev \
    curl-dev \
    gmp \
    gmp-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libmcrypt-dev \
    openssh-client \
    freetype-dev \
    $PHPIZE_DEPS && \
    # Configure PHP extensions
    docker-php-ext-configure json && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-configure curl && \
    docker-php-ext-configure ctype && \
    docker-php-ext-configure dom && \
    docker-php-ext-configure exif && \
    docker-php-ext-configure tokenizer && \
    docker-php-ext-configure simplexml && \
    docker-php-ext-configure mbstring && \
    docker-php-ext-configure zip && \
    docker-php-ext-configure pdo && \
    docker-php-ext-configure pdo_sqlite && \
    docker-php-ext-configure pdo_mysql && \
    docker-php-ext-configure mysql && \
    docker-php-ext-configure mysqli && \
    docker-php-ext-configure opcache && \
    docker-php-ext-configure iconv && \
    docker-php-ext-configure session && \
    docker-php-ext-configure sockets && \
    docker-php-ext-configure mcrypt && \
    docker-php-ext-configure xml && \
    docker-php-ext-configure phar && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    # Build and install PHP extensions
    docker-php-ext-install json \
    session \
    bcmath \
    ctype \
    exif \
    tokenizer \
    simplexml \
    dom \
    gmp \
    mbstring \
    mcrypt \
    zip \
    pdo \
    pdo_sqlite \
    pdo_mysql \
    mysql \
    mysqli \
    opcache \
    curl \
    iconv \
    soap \
    sockets \
    xml  \
    phar \
    gd && \
    # Install XDebug
    pecl install -f xdebug-2.5.5 && \
    apk del $PHPIZE_DEPS && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > $PHP_INI_DIR/conf.d/xdebug.ini
RUN echo "display_errors = On" >> $PHP_INI_DIR/conf.d/xdebug.ini

RUN sed -i -e "s/pm.max_children = 5/pm.max_children = 30/g" /usr/local/etc/php-fpm.d/www.conf

# Create user 1000
RUN adduser -D -u 1000 php && \
    mkdir -p /home/php/.ssh && \
    chmod 700 /home/php/.ssh && \
    chown -R php.php /home/php

