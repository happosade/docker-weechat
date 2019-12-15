FROM ubuntu:18.04 AS builder

WORKDIR build/

ENV DEBIAN_FRONTEND noninteractive
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update &&\
    apt-get install -y git libv8-dev python3-dev &&\
    apt-get build-dep -y weechat
RUN git clone --depth=1 https://github.com/weechat/weechat.git
RUN mkdir /install
RUN cd weechat && cmake -DCMAKE_INSTALL_PREFIX=/install -DENABLE_PHP=OFF -DENABLE_GUILE=OFF -DWEECHAT_HOME=/weechat -DENABLE_IRC=ON &&\
    make && make install


# Actual one
FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive

COPY --from=builder /install /
# needs some libraries
RUN apt-get update &&\
    apt-get install -y libcurl3-gnutls \
    libv8-3.14.5 \
    liblua5.1-0 \
    libpython3.6 \
    libruby2.5 \
    libaspell15 \
    libtcl8.6 \
    libperl5.26 &&\
    rm -rf /var/lib/apt/lists/*

RUN ln -s / /install
USER 1000:1000
WORKDIR /weechat
CMD [ "/bin/weechat" ]

