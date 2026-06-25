FROM nginx:alpine

# Копируем статическую страницу
COPY index.html /usr/share/nginx/html/index.html

# Копируем кастомный конфиг
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
