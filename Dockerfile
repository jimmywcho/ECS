# v1.0.0
#FROM nginx:alpine
#
#COPY index.html /usr/share/nginx/html/index.html
#
#RUN mkdir -p /var/cache/nginx/client_temp && \
#    chmod -R 777 /var/cache/nginx
#
#EXPOSE 80
#
#CMD ["nginx", "-g", "daemon off;"]

# v2.0.0
FROM nginx:alpine

COPY index_green.html /usr/share/nginx/html/index.html

RUN mkdir -p /var/cache/nginx/client_temp && \
    chmod -R 777 /var/cache/nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]