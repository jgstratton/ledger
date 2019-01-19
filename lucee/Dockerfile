FROM ortussolutions/commandbox:lucee5-2.3.0

ARG ENABLE_SSL

COPY ./box.json /app/box.json
RUN cd /app && box install

COPY ./server.json /app/server.json
COPY ./config.json /app/config.json

RUN box server set web.SSL.enable=$ENABLE_SSL

RUN cd /app && box cfconfig import config.json
