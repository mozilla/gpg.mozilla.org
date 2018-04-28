FROM centos:latest
LABEL maintainer="kang@insecure.ws"

# Base packages
RUN yum update -y && \
    yum install -y sudo && \
    yum install -y epel-release

# Install app
RUN yum install -y sks

# SKS data & config
VOLUME ["/var/sks"]

EXPOSE 11370

# Final yum cleanup
RUN yum clean -y all && \
    rm -rf /var/cache/yum
USER sks
WORKDIR /var/sks
CMD /usr/bin/sks recon
