FROM ubuntu:xenial

ENV VIRTUAL_ENV /virtualenv
ENV PATH "$VIRTUAL_ENV/bin:$PATH"
COPY downloader.sh /
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		apache2 \
		ca-certificates \
		curl \
		git \
		libapache2-mod-wsgi \
		virtualenv \
	&& /downloader.sh \
	&& git clone --depth 1 https://github.com/openstack/keystone.git /tmp/keystone \
	&& virtualenv $VIRTUAL_ENV \
	&& hash -r \
	&& pip install -U pip \
	&& pip install -c /tmp/packages/upper-constraints.txt --no-compile --find-links /tmp/packages /tmp/keystone \
	&& apt-get purge -y --auto-remove \
		ca-certificates \
		curl \
		git \
		virtualenv \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /root/.cache /usr/local/*
