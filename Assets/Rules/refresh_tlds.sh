#!/bin/sh
scriptdir="$(dirname "$(realpath "$0")")"
curl -s -o "${scriptdir}/supported_domains.txt" 'https://www.google.com/supported_domains'
