FROM openjdk:8 AS build

RUN apt update && apt upgrade -y && \
    apt install build-essential autoconf libtool -y \
    && apt install swig libcrypto++-dev libsodium-dev zlib1g-dev \
    libsqlite3-dev libssl-dev libc-ares-dev -y \
    && apt install libcurl4-openssl-dev libfreeimage-dev \
    libreadline-dev libpcre++-dev -y

RUN git clone https://github.com/meganz/sdk

WORKDIR /sdk

RUN ./autogen.sh
RUN ./configure --enable-java --with-java-include-dir=/usr/local/openjdk-8/include
RUN make & make install

FROM openjdk:8-jre-slim

COPY --from=build /lib /lib
COPY --from=build /usr/lib /usr/lib
