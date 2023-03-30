ARG NODE_IMAGE=node:16
ARG NGINX_IMAGE=nginx:latest

FROM ${NODE_IMAGE} AS web-build 
WORKDIR /usr/src/app
COPY package.json .
RUN npm install --force
COPY . .
RUN npm run build

FROM ${NODE_IMAGE} AS web-server
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
COPY --from=web-build  /usr/src/app/.next/standalone ./
COPY --from=web-build  /usr/src/app/.next/static ./.next/static
EXPOSE 3000
CMD ["node", "server.js"]
