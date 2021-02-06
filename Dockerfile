# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jnakahod <jnakahod@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/29 14:48:10 by jnakahod          #+#    #+#              #
#    Updated: 2021/02/04 23:06:41 by jnakahod         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# get base image
FROM debian:buster

ENV ENTRYKIT_VERSION 0.4.0
ENV DEBCONF_NOWARNINGS yes

COPY ./srcs/init_container.sh .
COPY ./srcs/localhost.tmpl /tmp/
COPY ./srcs/config.inc.php /tmp/
COPY ./srcs/set.sql /tmp/

RUN set -ex; \
    apt-get update; \
    apt-get install -y nginx vim wget openssl \
        php-fpm php-mysql php-curl php-mysql php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip php-bz2 \
        mariadb-server mariadb-client; \
    rm -rf /var/lib/apt/lists/*; \
    wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
    tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
    rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
    mv entrykit /bin/entrykit; \
    chmod +x /bin/entrykit; \
    entrykit --symlink

ENTRYPOINT ["render", "/tmp/localhost", \
            "--", "bash", "./init_container.sh"]
