FROM php:7.3-apache

#set System timezone
ENV TZ=Asia/Kolkata

#set our application folder as an environment variable
ENV APP_HOME=/var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    libzip-dev \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    openssl \
    cron \
    libxml2-dev \
    libgmp-dev

# Install Redis
RUN pecl install redis && docker-php-ext-enable redis

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl soap gmp
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# Set working directory
WORKDIR $APP_HOME