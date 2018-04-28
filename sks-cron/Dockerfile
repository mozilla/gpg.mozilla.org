FROM centos:latest
LABEL maintainer="kang@insecure.ws"

# Base packages
RUN yum update -y && \
    yum install -y sudo && \
    yum install -y epel-release

# Install app
RUN yum install -y sks crontabs

# SKS data & config
VOLUME ["/var/sks"]

# Cron
RUN sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond
ADD etc/cron.d/cron /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron
RUN crontab /etc/cron.d/cron

# Final yum cleanup
RUN yum clean -y all && \
    rm -rf /var/cache/yum
CMD crond -n
