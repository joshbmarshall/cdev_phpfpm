# cdev_phpfpm

PHP FPM for development

## docker-compose example

  phpfpm:
    image: joshbmarshall/cdev_phpfpm
    restart: always
    links:
      - mariadb
      - mailhog
      - "nginx:$MY_DOMAIN_NAME"
    ports:
      - "9000:9000"
    env_file:
      - .env
    user: 1000:1000
    volumes:
      - ./public:/var/www
      - ~/.composer:/home/php/.composer
      - ~/.ssh/id_rsa:/home/php/.ssh/id_rsa
      - ~/.ssh/known_hosts:/home/php/.ssh/known_hosts

