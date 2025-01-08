# Getting Started with Laravel

You will need npm and node for these projects.

## Setting up node and npm

```bash
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts
nvm use --lts
```

## Setting up laravel

```bash
/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
composer global require laravel/installer
```

## Creating new application

This will help you setup a very bare-bones basic application:

```bash
laravel new Play
```

```

   _                               _
  | |                             | |
  | |     __ _ _ __ __ ___   _____| |
  | |    / _` | '__/ _` \ \ / / _ \ |
  | |___| (_| | | | (_| |\ V /  __/ |
  |______\__,_|_|  \__,_| \_/ \___|_|


 ┌ Would you like to install a starter kit? ────────────────────┐
 │ No starter kit                                               │
 └──────────────────────────────────────────────────────────────┘

 ┌ Which testing framework do you prefer? ──────────────────────┐
 │ Pest                                                         │
 └──────────────────────────────────────────────────────────────┘

 ┌ Would you like to initialize a Git repository? ──────────────┐
 │ No                                                           │
 └──────────────────────────────────────────────────────────────┘
 
 ┌ Which database will your application use? ───────────────────┐
 │ SQLite                                                       │
 └──────────────────────────────────────────────────────────────┘

 ┌ Would you like to run the default database migrations? ──────┐
 │ Yes                                                          │
 └──────────────────────────────────────────────────────────────┘
```

## Start the application

Start the application:

```bash
cd Play
npm install && npm run build
composer run dev
```

## Docker

You can also setup up Laravel to run with docker:


### .dockerignore

Create a .dockerignore with the following values:

```.dockerignore
vendor
node_modules
```
### Custom Apache Config

You will need to setup a custom apache config file, within the config directory (`config/custom.conf`):

```
<Directory /var/www/html/public/>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
```

### Dockerfile

```Dockerfile
FROM node:20.17.0-alpine3.20 AS build

WORKDIR /var/www/html

COPY package.json /var/www/html/package.json
COPY package-lock.json /var/www/html/package-lock.json
COPY postcss.config.js /var/www/html/postcss.config.js
COPY tailwind.config.js /var/www/html/tailwind.config.js
COPY vite.config.js /var/www/html/vite.config.js

COPY resources /var/www/html/resources
COPY public /var/www/html/public

RUN npm ci && npm run build

FROM php:8.3.13-apache AS final

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    libcurl4-gnutls-dev

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN docker-php-ext-install curl

ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

COPY ./config/custom.conf /etc/apache2/conf-available/custom.conf
RUN a2enmod rewrite
RUN a2enconf custom

COPY --from=composer:2.8.2 /usr/bin/composer /usr/bin/composer

COPY app /var/www/html/app
COPY bootstrap /var/www/html/bootstrap
COPY config /var/www/html/config
COPY database /var/www/html/database
COPY routes /var/www/html/routes
COPY storage /var/www/html/storage

COPY artisan /var/www/html/artisan
COPY composer.json /var/www/html/composer.json
COPY composer.lock /var/www/html/composer.lock

COPY --from=build /var/www/html/resources /var/www/html/resources
COPY --from=build /var/www/html/public /var/www/html/public

COPY .env /var/www/html/.env

RUN composer install --no-interaction

RUN php artisan optimize
RUN php artisan config:cache
RUN php artisan event:cache
RUN php artisan route:cache
RUN php artisan view:cache

RUN chown -R www-data:www-data /var/www/html/
USER www-data
EXPOSE 80
```

### Compose file

You can setup your compose.yaml file like so:

```yaml
services:
  server:
    build: .
    ports:
      - 8000:80
```
