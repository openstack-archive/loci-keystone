#!/bin/bash -eux

rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -rf /root/.cache
find / -type f \( -name "*.pyc" -o -name "pip" -o -name "easy_install" -o -name "wheel" \) -delete
