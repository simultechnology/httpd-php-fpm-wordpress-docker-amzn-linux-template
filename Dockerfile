FROM amazonlinux:2

# install amazon-linux-extras install
RUN amazon-linux-extras install -y

# yum update & install
RUN yum update -y \
    && yum install \
        systemd \
        gcc \
        make \
        tar \
        unzip \
        sudo \
        procps \
        httpd \
        -y

# install aws cli v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install

# create user
RUN useradd "ec2-user" && echo "ec2-user ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN amazon-linux-extras enable php8.1

RUN yum install php-cli php-pdo php-fpm php-mysqlnd php-pear php-devel -y
RUN pecl install xdebug

RUN systemctl enable httpd \
    && systemctl enable httpd php-fpm.service


EXPOSE 80
# init
# CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
ENTRYPOINT ["/sbin/init"]