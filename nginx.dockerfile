FROM nginx
LABEL maintainer="Chris Buckner<christopher.d.buckner@gmail.com>"

# This is to support noninteractive apt-get installs
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	nginx-extras \
	net-tools \
	telnet \
	curl \
	vim

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /usr/share/nginx/html -r
RUN mkdir /etc/ssl/nginx

COPY ssl /etc/ssl/nginx
COPY nginx/default.conf /etc/nginx/conf.d
COPY nginx/nginx.conf /etc/nginx
COPY bootstrap_html /usr/share/nginx/
