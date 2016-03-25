FROM ubuntu:wily
MAINTAINER "Alexander Trauzzi" <atrauzzi@gmail.com>

WORKDIR /var/www

RUN apt-get update -y
RUN apt-get install -y \
	curl \
	git \
	mercurial \
	python \
	python-setuptools \
	php5-pgsql \
	php5-redis \
	php5-json \
	php5-mcrypt \
	php5-curl \
	php5-gd \
	php5-fpm \
	php5-cli

RUN easy_install pip

RUN php5enmod mcrypt

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs

RUN npm install -g jspm
RUN npm install -g gulp

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN pip install hg+https://bitbucket.org/dbenamy/devcron#egg=devcron

RUN touch /var/log/cron.log

COPY /resources/artisan /usr/local/bin/artisan
RUN chmod +x /usr/local/bin/artisan

RUN chmod 777 /run
RUN chmod 770 /home

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 9000

ENTRYPOINT ["/usr/sbin/php5-fpm"]
CMD ["-F", "-R"]
