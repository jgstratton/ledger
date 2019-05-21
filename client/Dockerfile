# base image
FROM node:10.15.0 as build_stage

# set working directory
RUN mkdir /cache
WORKDIR /cache

# COPY application files
COPY ./src /cache/src
COPY ./public /cache/public
COPY package.json /cache/package.json
COPY package-lock.json /cache/package-lock.json

# install all dependencies needed for dev
RUN npm install

# create the production build for the react app
RUN mkdir /cache/build
RUN npm run build

# copy only the built production files
FROM node:10.15.0

WORKDIR /usr/app

COPY --from=build_stage /cache/public /usr/app/public
COPY --from=build_stage /cache/build /usr/app/build
COPY package.json /usr/app/package.json
COPY package-lock.json /usr/app/package-lock.json
COPY index.js /usr/app/index.js

# install only the production dependencies
RUN npm install --production


CMD ["node", "index.js"]
