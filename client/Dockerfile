FROM node:8.15-alpine

ENV NODE_PATH=/node_modules
ENV PATH=$PATH:/node_modules/.bin
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install

RUN mkdir /app
WORKDIR /app

COPY ["run.sh", "/app/"]


#ENTRYPOINT ["/bin/ash", "/app/run.sh"]
ENTRYPOINT ["/bin/ash"]
CMD ["start"]