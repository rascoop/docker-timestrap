# Build image:
# docker build --tag timestrap:latest -f Dockerfile .
# 
# Run image, listen on port 8000, use db.sqlite3 from /database/ subfolder:
# docker run -v ./database/:/timestrap/database/ -p 8000:8000 rascoop/timestrap:latest
#
# Run interactively, for debugging and development:
# docker run -v ./database/:/timestrap/database/ -p 8000:8000 -i -t rascoop/timestrap:latest bash
# 
# Tag and push to Docker hub:
# docker tag timestrap:latest rascoop/timestrap:latest
# docker push rascoop/timestrap:latest


# Static file build step
FROM node:9.2-alpine as build

RUN apk add --no-cache git && \
    git clone https://github.com/overshard/timestrap

WORKDIR "/timestrap"

### Bump node-sass to latest version (default is no longer available)
RUN npm install --save node-sass@4.7.2

RUN npm install && \
    npm install -g gulp-cli@1.4.0 && \
    gulp build:production

### Remove some files no longer needed to reduce image size:
RUN rm -rf /timestrap/node_modules/

# Application build step
FROM alpine:3.7

COPY --from=build /timestrap /timestrap

WORKDIR "/timestrap"

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN apk add --no-cache bash postgresql-dev build-base python3-dev libffi-dev && \
    pip install pipenv && \
    pipenv install && \
    apk del postgresql-dev build-base python3-dev libffi-dev && \
    rm -rf /root/.cache/pip

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8000

CMD ["/bin/sh", "-c", "/entrypoint.sh"]
