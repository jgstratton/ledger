FROM ortussolutions/commandbox:lucee5-2.3.0


COPY ./box.json /app/box.json
RUN cd /app && box install

COPY ./server.json /app/server.json
COPY ./config.json /app/config.json

RUN cd /app && box cfconfig import config.json
