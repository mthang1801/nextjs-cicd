ARG NODE_IMAGE=node:16
ARG NGINX_IMAGE=nginx:latest
ARG PORT=3000

FROM ${NODE_IMAGE} AS web-build 
WORKDIR /usr/src/app
COPY package.json .
RUN npm install --force
COPY . .
RUN npm run build
RUN ls -la

FROM ${NGINX_IMAGE} AS web-server
ARG NODE_ENV=production
ARG WORKDIR=/usr/src/app
ENV NODE_ENV=${NODE_ENV}
COPY --from=web-build /usr/src/app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE ${PORT}