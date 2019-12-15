FROM ubuntu:18.04 AS builder

WORKDIR build/

ENV DEBIAN_FRONTEND noninteractive
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update &&\
    apt-get install -y git libv8-dev python3-dev &&\
    apt-get build-dep -y weechat
RUN git clone https://github.com/weechat/weechat.git && cd weechat && git checkout v2.7
RUN cd weechat && cmake -DCMAKE_INSTALL_PREFIX=/ -DENABLE_PHP=OFF -DENABLE_GUILE=OFF -DWEECHAT_HOME=/weechat -DCMAKE_BUILD_TYPE=Release &&\
    make && make install


# Actual one
FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
COPY --from=builder /include/weechat/weechat-plugin.h /include/weechat/weechat-plugin.h
COPY --from=builder /lib/weechat/ /lib/weechat/
COPY --from=builder /bin/weechat /bin
COPY --from=builder /bin/weechat-headless /bin
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

# RUN ln -s / /install
USER 1000:1000
WORKDIR /weechat
CMD [ "/bin/weechat-headless" ]

