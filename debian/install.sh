#!/bin/bash -eux

PROJECT=$1

git clone --depth 1 https://github.com/openstack/${PROJECT}.git /tmp/${PROJECT}
virtualenv $VIRTUAL_ENV
hash -r
pip install --upgrade pip setuptools
pip install --no-index --no-compile --find-links /tmp/packages --constraint /tmp/packages/upper-constraints.txt /tmp/${PROJECT}
