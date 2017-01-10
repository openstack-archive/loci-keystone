FROM debian:jessie

ARG DOCKER_REPO
ARG GIT_REPO
ARG GIT_REF
ARG GIT_REF_REPO
ARG TAG
ARG WHEELS
ENV DOCKER_REPO=${DOCKER_REPO:-yaodu/requirements} \
    GIT_REPO=${GIT_REPO:-https://github.com/openstack/keystone} \
    GIT_REF=${GIT_REF} \
    GIT_REF_REPO=${GIT_REF_REPO:-https://git.openstack.org/openstack/keystone} \
    PATH=/virtualenv/bin:${PATH} \
    PROJECT=keystone \
    TAG=${TAG:-latest-debian} \
    WHEELS=${WHEELS}

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        apache2 \
        ca-certificates \
        curl \
        git \
        libapache2-mod-wsgi \
    && if [ -n "$WHEELS" ]; then \
        curl -sSL ${WHEELS} > /tmp/wheels.tar.gz; \
       else \
        TOKEN=$(curl -sSL "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${DOCKER_REPO}:pull" | \
                    python -c "import sys, json; print json.load(sys.stdin)['token']") \
        && BLOB=$(curl -sSL -H "Authorization: Bearer ${TOKEN}" https://registry.hub.docker.com/v2/${DOCKER_REPO}/manifests/${TAG} | \
                    python -c "import sys, json; print json.load(sys.stdin)['fsLayers'][0]['blobSum']") \
        && curl -sSL -H "Authorization: Bearer ${TOKEN}" https://registry.hub.docker.com/v2/${DOCKER_REPO}/blobs/${BLOB} > /tmp/wheels.tar.gz; \
       fi \
    && git clone ${GIT_REPO} /tmp/${PROJECT} \
    && if [ -n "$REF" ]; then \
        git --git-dir /tmp/${PROJECT}/.git fetch ${GIT_REF_REPO} ${REF} \
        && git --git-dir /tmp/${PROJECT}/.git checkout FETCH_HEAD; \
       fi \
    && mkdir /tmp/packages \
    && tar xf /tmp/wheels.tar.gz -C /tmp/packages/ --strip-components=2 root/packages \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py \
    && rm get-pip.py \
    && pip install virtualenv \
    && virtualenv /virtualenv \
    && hash -r \
    && pip install --no-index --no-compile --find-links /tmp/packages --constraint /tmp/packages/upper-constraints.txt /tmp/${PROJECT} \
    && apt-get purge -y --auto-remove \
        ca-certificates \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/* /tmp/* /root/.cache \
    && find / -type f \( -name "*.pyc" -o -name "pip" -o -name "easy_install" -o -name "wheel" \) -delete \
    && groupadd -g 42424 ${PROJECT} && useradd -u 42424 -g ${PROJECT} -s /sbin/nologin -c "${PROJECT} user" ${PROJECT} \
    && mkdir -p /etc/${PROJECT} /var/log/${PROJECT} /var/lib/${PROJECT} /var/cache/${PROJECT} \
    && chown ${PROJECT}:${PROJECT} /etc/${PROJECT} /var/log/${PROJECT} /var/lib/${PROJECT} /var/cache/${PROJECT}
