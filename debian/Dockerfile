FROM debian:jessie

ENV PROJECT=keystone
ARG DOCKER_REPO=yaodu/openstack-requirements
ARG DOCKER_TAG=latest
ARG WHEELS
ARG GIT_REPO=https://github.com/openstack/${PROJECT}
ARG GIT_REF
ARG GIT_REF_REPO=https://git.openstack.org/openstack/${PROJECT}
ARG SCRIPTS=https://github.com/yaodu/common/archive/0.1.2.tar.gz

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && curl -sSL $SCRIPTS | tar xz -C /tmp/ --strip-components=2 \
    && /tmp/download.sh $DOCKER_REPO $DOCKER_TAG $WHEELS \
    && /tmp/install.sh $PROJECT $GIT_REPO $GIT_REF_REPO $GIT_REF \
    && apt-get install -y --no-install-recommends \
        apache2 \
        libapache2-mod-wsgi \
    && rm /etc/apache2/ports.conf /etc/apache2/sites-enabled/* /etc/apache2/sites-available/* \
    && touch /etc/apache2/ports.conf \
    && /tmp/cleanup.sh
