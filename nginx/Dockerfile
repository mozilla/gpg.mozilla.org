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
# allow transversing the tmp dir
RUN chmod a+rx /var/lib/nginx/tmp && \
    chmod a+rx /var/lib/nginx && \
    chown -R nginx:nobody /var/lib/nginx/tmp && \
    chmod -R g+rwx /var/lib/nginx/tmp
EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
