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
RUN sudo addgroup -g 1001 -S nodejs
RUN sudo adduser -S nextjs -u 1001
COPY --from=web-build --chown=nextjs:nodejs /usr/src/app/.next/standalone ./
COPY --from=web-build --chown=nextjs:nodejs /usr/src/app/.next/static ./.next/static
USER nextjs
ENV PORT=3000
EXPOSE ${PORT}
CMD ["node", "server.js"]
