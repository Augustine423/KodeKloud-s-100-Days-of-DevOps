FROM ubuntu:24.04

RUN apt update && \
    apt install -y apache2 && \
    apt clean

RUN sed -i 's/Listen 80/Listen 8089/g' /etc/apache2/ports.conf && \
    sed -i 's/:80/:8089/g' /etc/apache2/sites-enabled/000-default.conf

EXPOSE 8089

CMD ["apache2ctl", "-D", "FOREGROUND"]