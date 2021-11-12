FROM ubuntu:20.04
RUN  apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update && \
      apt-get -y install sudo
RUN apt-get install apache2 php7.4 libapache2-mod-php7.4 php7.4-curl php-pear php7.4-gd php7.4-dev php7.4-zip php7.4-mbstring php7.4-mysql php7.4-xml curl -y
#RUN systemctl start apache2
#RUN systemctl enable apache2
RUN sudo /etc/init.d/apache2 start
RUN sudo apt-get install -y git
RUN sudo curl -sS https://getcomposer.org/installer | php
RUN sudo mv composer.phar /usr/local/bin/composer
RUN sudo chmod +x /usr/local/bin/composer
WORKDIR /var/www/html
WORKDIR /var/www/html/laravelapp
RUN sudo composer create-project laravel/laravel laravelapp --prefer-dist
RUN sudo chown -R www-data:www-data /var/www/html/laravelapp
RUN sudo chmod -R 775 /var/www/html/laravelapp/storage
COPY /app/SampleProj/laravel.conf /etc/apache2/sites-available/
RUN sudo nano /etc/apache2/sites-available/laravel.conf
RUN sudo a2ensite laravel.conf
RUN sudo a2enmod rewrite
RUN sudo systemctl restart apache2
