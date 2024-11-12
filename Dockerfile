FROM nginx
RUN apt-get update && apt-get install -y curl
COPY default.conf /etc/nginx/conf.d/default.conf:ro
EXPOSE 80
