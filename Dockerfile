FROM alpine:latest as build

RUN apk update && apk add \
      gcc \
      g++ \
      cmake \
      pkgconfig \
      make \
      musl-dev

ADD . /code
WORKDIR /code/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make

FROM alpine:latest

COPY --from=build /code/build/mbusd /usr/bin/mbusd
COPY --from=build /code/build/mbusd.8 /usr/share/man/man8/mbusd.8

ENTRYPOINT ["/usr/bin/mbusd", "-d"]