FROM centos:7

MAINTAINER Harold Heramis <haroldheramis@altus-dc.com>

COPY config/nginx/nginx.repo /etc/yum.repos.d/nginx.repo

RUN yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

RUN yum-config-manager --enable remi-php70

RUN rpm -ivh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm

RUN yum -y install  nginx supervisor \
                    php \
                    php-bcmath \
                    php-cli \
                    php-fpm \
                    php-gd \
                    php-intl \
                    php-mbstring \
                    php-mcrypt \
                    php-mysqlnd \
                    php-pdo \
                    php-pecl-igbinary \
                    php-pecl-imagick \
                    php-pecl-oauth \
                    php-pecl-redis \
                    php-pecl-zendopcache \
                    php-process \
                    php-soap \
                    php-xml \
                    php-zip \
                    curl && yum clean all

RUN echo "license_key: LICENSE_KEY" | tee -a /etc/newrelic-infra.yml

RUN curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo

RUN yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'

RUN yum install newrelic-infra -y

COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/www.conf /etc/nginx/conf.d/default.conf

COPY config/php/www.conf /etc/php-fpm.d/www.conf

RUN mkdir -p /run/php-fpm

COPY config/supervisor/nginx.ini /etc/supervisord.d/nginx.ini.config

RUN rm -rf /var/www/html

COPY wordpress /var/www/html

RUN chmod 777 /var/www/html/wp-content/uploads

COPY bin/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod -v +x /usr/local/bin/entrypoint.sh

EXPOSE 80

VOLUME ["/var/www/html", "/var/log/nginx", "/var/log/php-fpm"]

CMD ["entrypoint.sh"]