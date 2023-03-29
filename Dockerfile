ARG NODE_IMAGE=node:16
ARG NGINX_IMAGE=nginx:latest

FROM ${NODE_IMAGE} AS web-build 
WORKDIR /usr/src/app
COPY package.json .
RUN npm install --force
COPY . .
RUN npm run build

FROM ${NGINX_IMAGE} AS web-server
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
RUN mkdir -p /usr/share/nginx/buffer
COPY --from=web-build /usr/src/app/.next /usr/share/nginx/buffer
COPY --from=web-build /usr/src/app/deploy.sh /usr/share/nginx/buffer
RUN chmod +x /usr/share/nginx/buffer/deploy.sh
RUN cd /usr/share/nginx/buffer && ./deploy.sh
RUN mkdir /usr/share/nginx/log
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
