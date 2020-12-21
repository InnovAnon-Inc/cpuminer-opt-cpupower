FROM ubuntu:latest as base

MAINTAINER Innovations Anonymous <InnovAnon-Inc@protonmail.com>
LABEL version="1.0"                                                     \
      maintainer="Innovations Anonymous <InnovAnon-Inc@protonmail.com>" \
      about="Dockerized Crypto Miner"                                   \
      org.label-schema.build-date=$BUILD_DATE                           \
      org.label-schema.license="PDL (Public Domain License)"            \
      org.label-schema.name="Dockerized Crypto Miner"                   \
      org.label-schema.url="InnovAnon-Inc.github.io/docker"             \
      org.label-schema.vcs-ref=$VCS_REF                                 \
      org.label-schema.vcs-type="Git"                                   \
      org.label-schema.vcs-url="https://github.com/InnovAnon-Inc/docker"

ARG  DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND ${DEBIAN_FRONTEND}

ARG  TZ=UTC
ENV  TZ ${TZ}
ARG  LANG=C.UTF-8
ENV  LANG ${LANG}
ARG  LC_ALL=C.UTF-8
ENV  LC_ALL ${LC_ALL}

RUN apt update \
 && apt full-upgrade -y

FROM base as builder
USER root

COPY ./scripts/dpkg-dev.list /dpkg-dev.list
RUN test -x                  /dpkg-dev.list \
 &&                          /dpkg-dev.list \
 && apt install -y          `/dpkg-dev.list` \
 && rm -v                    /dpkg-dev.list

FROM builder as scripts
USER root

RUN mkdir -v                /app \
 && chown -v nobody:nogroup /app
COPY --chown=root                \
      ./scripts/entrypoint.sh  /app/entrypoint.sh
COPY --chown=root                \
      ./scripts/healthcheck.sh /app/healthcheck.sh
WORKDIR /app
USER nobody

ARG CONF
ENV CONF ${CONF}
ARG CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
ARG CXXFLAGS
ENV CFLAGS ${CFLAGS}
ENV CXXFLAGS ${CXXFLAGS}

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}

RUN shc -Drv -f healthcheck.sh   \
 && shc -Drv -f entrypoint.sh    \
 && test -x     healthcheck.sh.x \
 && test -x     entrypoint.sh.x

FROM builder as app
USER root

COPY --chown=root ./scripts/configure.sh        /configure.sh
COPY --chown=root ./scripts/compile.sh          /compile.sh
RUN git clone --depth=1 --recursive   \
   git://github.com/cpu-pool/cpuminer-opt-cpupower.git \
                            /app      \
 && chown -R nobody:nogroup /app
WORKDIR                     /app
USER nobody

ARG CONF
ENV CONF ${CONF}
ARG CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
ARG CXXFLAGS
ENV CFLAGS ${CFLAGS}
ENV CXXFLAGS ${CXXFLAGS}

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}

RUN                                /compile.sh \
 && strip --strip-all cpuminer
#RUN upx --all-filters --ultra-brute cpuminer

FROM base
USER root
WORKDIR /

COPY  ./scripts/dpkg.list      /dpkg.list
RUN test -x                    /dpkg.list  \
 &&                            /dpkg.list  \
 && apt install    -y         `/dpkg.list` \
 && rm -v                      /dpkg.list  \
 && apt autoremove -y                      \
 && apt clean      -y                      \
 && rm -rf /var/lib/apt/lists/*            \
           /usr/share/info/*               \
           /usr/share/man/*                \
           /usr/share/doc/*
COPY --chown=root --from=app \
       /app/cpuminer           /usr/local/bin/cpuminer

ARG COIN=cpuchain
ENV COIN ${COIN}

COPY "./mineconf/${COIN}.d/"   /conf.d/
VOLUME                         /conf.d
COPY --chown=root --from=scripts \
      ./app/entrypoint.sh.x  /usr/local/bin/entrypoint

COPY --chown=root --from=scripts \
      ./app/healthcheck.sh.x /usr/local/bin/healthcheck
HEALTHCHECK --start-period=30s --interval=1m --timeout=3s --retries=3 \
CMD ["/usr/local/bin/healthcheck"]

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}
COPY --chown=root                \
      ./scripts/test.sh        /test
RUN                            /test \
 && rm -v                      /test

#EXPOSE 4048
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD        ["default"]

