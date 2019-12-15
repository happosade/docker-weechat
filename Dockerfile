FROM ubuntu:18.04 AS builder

WORKDIR bulid/

ENV DEBIAN_FRONTEND noninteractive
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update &&\
    apt-get install -y git libv8-dev python3-dev &&\
    apt-get build-dep -y weechat
RUN git clone --depth=1 https://github.com/weechat/weechat.git
RUN mkdir /install
RUN cd weechat && cmake -DCMAKE_INSTALL_PREFIX=/install -DCMAKE_BUILD_TYPE=Release -DENABLE_PHP=OFF && make && make install


# Actual one
FROM ubuntu:18.04

COPY --from=builder /install /
# needs libcurl3-gnutls
RUN apt-get update &&\
    apt-get install -y libcurl3-gnutls &&\
    rm -rf /var/lib/apt/lists/*

CMD [ "/bin/weechat" ]

