FROM centos:latest
LABEL maintainer="kang@insecure.ws"

# Base packages
RUN yum update -y && \
    yum install -y sudo && \
    yum install -y epel-release

# Install app
RUN yum install -y nginx

# Final yum cleanup
RUN yum clean -y all && \
    rm -rf /var/cache/yum

# Nginx
ADD etc/nginx.conf /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
        && ln -sf /dev/stderr /var/log/nginx/error.log
EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
