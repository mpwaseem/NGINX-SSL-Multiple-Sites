FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install net-tools nginx-full && \
    useradd -ms /bin/bash aurora
RUN apt-get update
RUN apt-get install nano
RUN apt-get install -y supervisor
RUN apt-get update && apt-get install -y software-properties-common curl zip git
RUN apt-get install -y php7.4 php7.4-fpm php7.4-cli php7.4-pdo php7.4-mysql php7.4-bcmath php7.4-gmp php7.4-mbstring php7.4-curl
RUN mkdir -p /run/php && touch /run/php/php7.4-fpm.sock && touch /run/php/php7.4-fpm.pid

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Expose port 9000 and start php-fpm server
EXPOSE 9000
COPY nginx/ssl/ /etc/nginx/ssl/
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/sites-available/ /etc/nginx/sites-available/
COPY nginx/sites-enabled/default /etc/nginx/sites-enabled/default 
RUN chown -R www-data:www-data /usr/share/nginx/html/* && \
chmod -R 0755 /usr/share/nginx/html/*

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]