# Getting Started with PHP

To get started with PHP, I would highly recommend using docker as it is much simpler to setup then PHP itself on your local machine.

It will also be good to use [composer](https://getcomposer.org/) for dependency management.

## Setting up PHP and composer

```bash
sudo apt install php-common php-cli
wget https://getcomposer.org/download/2.8.2/composer.phar
sudo mv composer.phar /usr/local/bin/composer # Or any PATH directory
sudo chmod +x /usr/local/bin/composer
```

## Initialize your project with composer

```bash
composer init
```

```bash
  Welcome to the Composer config generator



This command will guide you through creating your composer.json config.

Package name (<vendor>/<name>) [animalalpaca/learning-php]: evanlab02/getting-started
Description []:
Author [Evanlab02 <evanlabuschagne70@gmail.com>, n to skip]:
Minimum Stability []:
Package Type (e.g. library, project, metapackage, composer-plugin) []: project
License []:

Define your dependencies.

Would you like to define your dependencies (require) interactively [yes]? no
Would you like to define your dev dependencies (require-dev) interactively [yes]? no
Add PSR-4 autoload mapping? Maps namespace "Evanlab02\GettingStarted" to the entered relative path. [src/, n to skip]:

{
    "name": "evanlab02/getting-started",
    "type": "project",
    "autoload": {
        "psr-4": {
            "Evanlab02\\GettingStarted\\": "src/"
        }
    },
    "authors": [
        {
            "name": "Evanlab02",
            "email": "evanlabuschagne70@gmail.com"
        }
    ],
    "require": {}
}

Do you confirm generation [yes]?
Generating autoload files
Generated autoload files
```

## Creating your first .php file

Create a folder `public` and put this file into as `index.php`.

```php
// public/index.php
<?php $user = "World"; ?>
<html>
<head></head>
<body>
Hello <?php echo $user; ?>!
</body>
</html>
```

## Setting up Dockerfile

```Dockerfile
# Dockerfile
FROM php:8.3.13-apache AS final

# Setup project
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY ./public/index.php /var/www/html/

# Set appropriate permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Set user to www-data
USER www-data
```

## Setting up compose file

```yaml
# compose.yaml
services:
  server:
    build: .
    ports:
      - 8000:80
```

## Running it

```bash
docker compose up -d
```
