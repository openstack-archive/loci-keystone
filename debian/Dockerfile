FROM debian:jessie

ARG REF
ARG REPO
ARG TAG
ENV PATH=/virtualenv/bin:${PATH} \
    REPO=${REPO:-yaodu/requirements} \
    TAG=${TAG:-latest-debian} \
    PROJECT=keystone \
    REF=${REF}

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        apache2 \
        ca-certificates \
        curl \
        git \
        libapache2-mod-wsgi \
        virtualenv \
    && TOKEN=$(curl -sSL "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${REPO}:pull" | \
            python -c "import sys, json; print json.load(sys.stdin)['token']") \
    && BLOB=$(curl -sSL -H "Authorization: Bearer ${TOKEN}" https://registry.hub.docker.com/v2/${REPO}/manifests/${TAG} | \
            python -c "import sys, json; print json.load(sys.stdin)['fsLayers'][0]['blobSum']") \
    && curl -sSL -H "Authorization: Bearer ${TOKEN}" https://registry.hub.docker.com/v2/${REPO}/blobs/${BLOB} > /tmp/wheels.tar.gz \
    && git clone https://github.com/openstack/${PROJECT}.git /tmp/${PROJECT} \
    && if [ -n "${REF+x}" ]; then \
        git --git-dir /tmp/${PROJECT}/.git fetch https://git.openstack.org/openstack/${PROJECT} ${REF} \
        && git --git-dir /tmp/${PROJECT}/.git checkout FETCH_HEAD; \
       fi \
    && mkdir /tmp/packages \
    && tar xf /tmp/wheels.tar.gz -C /tmp/packages/ --strip-components=2 root/packages \
    && virtualenv /virtualenv \
    && hash -r \
    && pip install --no-compile --upgrade pip setuptools \
    && pip install --no-index --no-compile --find-links /tmp/packages --constraint /tmp/packages/upper-constraints.txt /tmp/${PROJECT} \
    && apt-get purge -y --auto-remove \
        ca-certificates \
        curl \
        git \
        virtualenv \
    && rm -rf /var/lib/apt/lists/* /tmp/* /root/.cache \
    && find / -type f \( -name "*.pyc" -o -name "pip" -o -name "easy_install" -o -name "wheel" \) -delete \
    && groupadd -g 42424 ${PROJECT} && useradd -u 42424 -g ${PROJECT} -s /sbin/nologin -c "${PROJECT} user" ${PROJECT} \
    && mkdir -p /etc/${PROJECT} /var/log/${PROJECT} /var/lib/${PROJECT} /var/cache/${PROJECT} \
    && chown ${PROJECT}:${PROJECT} /etc/${PROJECT} /var/log/${PROJECT} /var/lib/${PROJECT} /var/cache/${PROJECT}
