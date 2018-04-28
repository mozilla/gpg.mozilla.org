FROM centos:latest
LABEL maintainer="kang@insecure.ws"

# Base packages
RUN yum update -y && \
    yum install -y sudo && \
    yum install -y epel-release

# Install app
RUN yum install -y sks wget bzip2

# SKS data & config
RUN mkdir /var/sks && chown sks:sks /var/sks
VOLUME ["/var/sks"]
ADD --chown=sks:sks etc/sksconf /var/sks/
ADD --chown=sks:sks etc/membership /var/sks/
ADD --chown=sks:sks etc/mailsync /var/sks
ADD --chown=sks:sks etc/web /var/sks/web
ADD --chown=sks:sks etc/dump /var/sks/dump

EXPOSE 11371

# Final yum cleanup
RUN yum clean -y all && \
    rm -rf /var/cache/yum
USER sks
WORKDIR /var/sks
CMD /usr/bin/sks db
