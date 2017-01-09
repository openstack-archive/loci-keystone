#!/bin/bash
set -x
set -e
set -u

for repo in debian ubuntu; do
	sed -e "s/%%DISTRO%%/${repo}/" downloader.sh > ${repo}/downloader.sh
    chmod +x ${repo}/downloader.sh
    cp install.sh ${repo}/install.sh
    cp cleanup.sh ${repo}/cleanup.sh
done
