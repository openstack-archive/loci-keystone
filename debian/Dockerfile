FROM debian:jessie

ENV VIRTUAL_ENV /virtualenv
ENV PATH "$VIRTUAL_ENV/bin:$PATH"
COPY cleanup.sh downloader.sh install.sh /
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
	&& /install.sh keystone \
	&& apt-get purge -y --auto-remove \
		ca-certificates \
		curl \
		git \
		virtualenv \
	&& /cleanup.sh
